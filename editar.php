<?php
require_once 'config/Conexion.php';

$title = 'Editar Producto';
$db = Conexion::getInstance();

// Verificar si se proporcionó un ID
if (!isset($_GET['id']) || empty($_GET['id'])) {
    header('Location: index.php?error=ID de producto no válido');
    exit;
}

$id = (int)$_GET['id'];

// Obtener el producto
$producto = $db->selectOne("SELECT * FROM productos WHERE id = ?", [$id]);

if (!$producto) {
    header('Location: index.php?error=Producto no encontrado');
    exit;
}

// Obtener categorías para el select
$categorias = $db->select("SELECT id, nombre FROM categorias WHERE activo = 1 ORDER BY nombre");

// Variables para el formulario
$nombre = $producto['nombre'];
$descripcion = $producto['descripcion'];
$precio = $producto['precio'];
$stock = $producto['stock'];
$categoria_id = $producto['categoria_id'];
$codigo_barras = $producto['codigo_barras'];
$activo = $producto['activo'];
$errores = [];

// Procesar formulario
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre = trim($_POST['nombre']);
    $descripcion = trim($_POST['descripcion']);
    $precio = trim($_POST['precio']);
    $stock = trim($_POST['stock']);
    $categoria_id = trim($_POST['categoria_id']);
    $codigo_barras = trim($_POST['codigo_barras']);
    $activo = isset($_POST['activo']) ? 1 : 0;
    
    // Validaciones
    if (empty($nombre)) {
        $errores[] = 'El nombre es requerido';
    }
    
    if (empty($precio) || !is_numeric($precio) || $precio <= 0) {
        $errores[] = 'El precio debe ser un número mayor a 0';
    }
    
    if (empty($stock) || !is_numeric($stock) || $stock < 0) {
        $errores[] = 'El stock debe ser un número mayor o igual a 0';
    }
    
    if (empty($categoria_id)) {
        $errores[] = 'La categoría es requerida';
    }
    
    // Verificar código de barras único (excluyendo el producto actual)
    if (!empty($codigo_barras)) {
        $existe = $db->selectOne("SELECT id FROM productos WHERE codigo_barras = ? AND id != ?", 
                                [$codigo_barras, $id]);
        if ($existe) {
            $errores[] = 'El código de barras ya existe';
        }
    }
    
    // Si no hay errores, actualizar
    if (empty($errores)) {
        try {
            $query = "UPDATE productos 
                      SET nombre = ?, descripcion = ?, precio = ?, stock = ?, 
                          categoria_id = ?, codigo_barras = ?, activo = ? 
                      WHERE id = ?";
            $params = [$nombre, $descripcion, $precio, $stock, $categoria_id, $codigo_barras, $activo, $id];
            
            if ($db->execute($query, $params)) {
                header('Location: index.php?mensaje=Producto actualizado exitosamente');
                exit;
            } else {
                $errores[] = 'Error al actualizar el producto';
            }
        } catch (Exception $e) {
            $errores[] = 'Error: ' . $e->getMessage();
        }
    }
}

include 'includes/header.php';
?>

<div class="row">
    <div class="col-md-8 mx-auto">
        <div class="card">
            <div class="card-header">
                <h4><i class="bi bi-pencil"></i> Editar Producto #<?php echo $id; ?></h4>
            </div>
            <div class="card-body">
                <!-- Mostrar errores -->
                <?php if (!empty($errores)): ?>
                    <div class="alert alert-danger">
                        <ul class="mb-0">
                            <?php foreach ($errores as $error): ?>
                                <li><?php echo htmlspecialchars($error); ?></li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                <?php endif; ?>
                
                <form method="POST" class="needs-validation" novalidate>
                    <div class="row">
                        <div class="col-md-8">
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre del Producto *</label>
                                <input type="text" class="form-control" id="nombre" name="nombre" 
                                       value="<?php echo htmlspecialchars($nombre); ?>" required>
                                <div class="invalid-feedback">
                                    El nombre es requerido
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="categoria_id" class="form-label">Categoría *</label>
                                <select class="form-select" id="categoria_id" name="categoria_id" required>
                                    <option value="">Seleccionar categoría</option>
                                    <?php foreach ($categorias as $categoria): ?>
                                        <option value="<?php echo $categoria['id']; ?>" 
                                                <?php echo $categoria_id == $categoria['id'] ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($categoria['nombre']); ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                                <div class="invalid-feedback">
                                    La categoría es requerida
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="descripcion" class="form-label">Descripción</label>
                        <textarea class="form-control" id="descripcion" name="descripcion" rows="3"><?php echo htmlspecialchars($descripcion); ?></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="precio" class="form-label">Precio *</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" id="precio" name="precio" 
                                           value="<?php echo htmlspecialchars($precio); ?>" 
                                           step="0.01" min="0" required>
                                </div>
                                <div class="invalid-feedback">
                                    El precio es requerido y debe ser mayor a 0
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="stock" class="form-label">Stock *</label>
                                <input type="number" class="form-control" id="stock" name="stock" 
                                       value="<?php echo htmlspecialchars($stock); ?>" 
                                       min="0" required>
                                <div class="invalid-feedback">
                                    El stock es requerido
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="codigo_barras" class="form-label">Código de Barras</label>
                                <input type="text" class="form-control" id="codigo_barras" name="codigo_barras" 
                                       value="<?php echo htmlspecialchars($codigo_barras); ?>">
                                <div class="form-text">Opcional - debe ser único</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="activo" name="activo" 
                                   <?php echo $activo ? 'checked' : ''; ?>>
                            <label class="form-check-label" for="activo">
                                Producto activo
                            </label>
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="index.php" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Cancelar
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle"></i> Actualizar Producto
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
// Validación de Bootstrap
(function() {
    'use strict';
    window.addEventListener('load', function() {
        var forms = document.getElementsByClassName('needs-validation');
        var validation = Array.prototype.filter.call(forms, function(form) {
            form.addEventListener('submit', function(event) {
                if (form.checkValidity() === false) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    }, false);
})();
</script>

<?php include 'includes/footer.php'; ?>