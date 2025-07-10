<?php
require_once 'config/Conexion.php';

$title = 'Lista de Productos';
$db = Conexion::getInstance();

// Configuración de paginación
$registros_por_pagina = 10;
$pagina = isset($_GET['pagina']) ? (int)$_GET['pagina'] : 1;
$offset = ($pagina - 1) * $registros_por_pagina;

// Búsqueda
$buscar = isset($_GET['buscar']) ? trim($_GET['buscar']) : '';
$where = '';
$params = [];

if (!empty($buscar)) {
    $where = "WHERE p.nombre LIKE ? OR p.descripcion LIKE ? OR c.nombre LIKE ?";
    $params = ["%$buscar%", "%$buscar%", "%$buscar%"];
}

// Consulta con paginación
$query = "SELECT p.*, c.nombre as categoria_nombre 
          FROM productos p 
          LEFT JOIN categorias c ON p.categoria_id = c.id 
          $where 
          ORDER BY p.id DESC 
          LIMIT $registros_por_pagina OFFSET $offset";

$productos = $db->select($query, $params);

// Contar total de registros
$query_count = "SELECT COUNT(*) as total 
                FROM productos p 
                LEFT JOIN categorias c ON p.categoria_id = c.id 
                $where";
$total_registros = $db->selectOne($query_count, $params)['total'];
$total_paginas = ceil($total_registros / $registros_por_pagina);

include 'includes/header.php';
?>

<!-- Alertas -->
<?php if (isset($_GET['mensaje'])): ?>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <?php echo htmlspecialchars($_GET['mensaje']); ?>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<?php endif; ?>

<?php if (isset($_GET['error'])): ?>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <?php echo htmlspecialchars($_GET['error']); ?>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<?php endif; ?>

<!-- Encabezado -->
<div class="row">
    <div class="col-md-6">
        <h1><i class="bi bi-box-seam"></i> Productos</h1>
    </div>
    <div class="col-md-6 text-end">
        <a href="crear.php" class="btn btn-success">
            <i class="bi bi-plus-circle"></i> Nuevo Producto
        </a>
    </div>
</div>

<!-- Barra de búsqueda -->
<div class="row mt-3">
    <div class="col-md-8">
        <form method="GET" class="d-flex">
            <input type="text" name="buscar" class="form-control me-2" 
                   placeholder="Buscar productos..." value="<?php echo htmlspecialchars($buscar); ?>">
            <button type="submit" class="btn btn-outline-primary">
                <i class="bi bi-search"></i>
            </button>
            <?php if (!empty($buscar)): ?>
                <a href="index.php" class="btn btn-outline-secondary ms-2">
                    <i class="bi bi-x-circle"></i>
                </a>
            <?php endif; ?>
        </form>
    </div>
    <div class="col-md-4 text-end">
        <small class="text-muted">
            Mostrando <?php echo count($productos); ?> de <?php echo $total_registros; ?> productos
        </small>
    </div>
</div>

<!-- Tabla de productos -->
<div class="card mt-3">
    <div class="card-body">
        <?php if (count($productos) > 0): ?>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Categoría</th>
                            <th>Precio</th>
                            <th>Stock</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($productos as $producto): ?>
                            <tr>
                                <td><?php echo $producto['id']; ?></td>
                                <td>
                                    <strong><?php echo htmlspecialchars($producto['nombre']); ?></strong>
                                    <?php if (!empty($producto['descripcion'])): ?>
                                        <br><small class="text-muted">
                                            <?php echo htmlspecialchars(substr($producto['descripcion'], 0, 50)); ?>...
                                        </small>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <?php if ($producto['categoria_nombre']): ?>
                                        <span class="badge bg-secondary">
                                            <?php echo htmlspecialchars($producto['categoria_nombre']); ?>
                                        </span>
                                    <?php else: ?>
                                        <span class="text-muted">Sin categoría</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <strong class="text-success">
                                        $<?php echo number_format($producto['precio'], 2); ?>
                                    </strong>
                                </td>
                                <td>
                                    <?php if ($producto['stock'] > 0): ?>
                                        <span class="badge bg-success"><?php echo $producto['stock']; ?></span>
                                    <?php else: ?>
                                        <span class="badge bg-danger">Agotado</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <?php if ($producto['activo']): ?>
                                        <span class="badge bg-success">Activo</span>
                                    <?php else: ?>
                                        <span class="badge bg-danger">Inactivo</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="editar.php?id=<?php echo $producto['id']; ?>" 
                                           class="btn btn-outline-primary" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger" 
                                                onclick="confirmarEliminacion(<?php echo $producto['id']; ?>, '<?php echo htmlspecialchars($producto['nombre']); ?>')"
                                                title="Eliminar">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php else: ?>
            <div class="text-center py-4">
                <i class="bi bi-inbox display-1 text-muted"></i>
                <h3 class="text-muted mt-3">No hay productos</h3>
                <p class="text-muted">
                    <?php if (!empty($buscar)): ?>
                        No se encontraron productos con el término "<?php echo htmlspecialchars($buscar); ?>"
                    <?php else: ?>
                        Comienza agregando tu primer producto
                    <?php endif; ?>
                </p>
                <a href="crear.php" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> Agregar Producto
                </a>
            </div>
        <?php endif; ?>
    </div>
</div>

<!-- Paginación -->
<?php if ($total_paginas > 1): ?>
    <nav aria-label="Paginación" class="mt-4">
        <ul class="pagination justify-content-center">
            <?php if ($pagina > 1): ?>
                <li class="page-item">
                    <a class="page-link" href="?pagina=<?php echo $pagina - 1; ?><?php echo !empty($buscar) ? '&buscar=' . urlencode($buscar) : ''; ?>">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>
            <?php endif; ?>
            
            <?php for ($i = 1; $i <= $total_paginas; $i++): ?>
                <li class="page-item <?php echo $i == $pagina ? 'active' : ''; ?>">
                    <a class="page-link" href="?pagina=<?php echo $i; ?><?php echo !empty($buscar) ? '&buscar=' . urlencode($buscar) : ''; ?>">
                        <?php echo $i; ?>
                    </a>
                </li>
            <?php endfor; ?>
            
            <?php if ($pagina < $total_paginas): ?>
                <li class="page-item">
                    <a class="page-link" href="?pagina=<?php echo $pagina + 1; ?><?php echo !empty($buscar) ? '&buscar=' . urlencode($buscar) : ''; ?>">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
            <?php endif; ?>
        </ul>
    </nav>
<?php endif; ?>

<!-- Modal de confirmación -->
<div class="modal fade" id="confirmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirmar Eliminación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>¿Estás seguro de que quieres eliminar el producto "<span id="producto-nombre"></span>"?</p>
                <p class="text-muted">Esta acción no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <a href="#" id="confirm-delete" class="btn btn-danger">Eliminar</a>
            </div>
        </div>
    </div>
</div>

<script>
function confirmarEliminacion(id, nombre) {
    document.getElementById('producto-nombre').textContent = nombre;
    document.getElementById('confirm-delete').href = 'eliminar.php?id=' + id;
    new bootstrap.Modal(document.getElementById('confirmModal')).show();
}
</script>

<?php include 'includes/footer.php'; ?>