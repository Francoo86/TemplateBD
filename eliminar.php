<?php
require_once 'config/Conexion.php';

$db = Conexion::getInstance();

// Verificar si se proporcionó un ID
if (!isset($_GET['id']) || empty($_GET['id'])) {
    header('Location: index.php?error=ID de producto no válido');
    exit;
}

$id = (int)$_GET['id'];

// Verificar si el producto existe
$producto = $db->selectOne("SELECT nombre FROM productos WHERE id = ?", [$id]);

if (!$producto) {
    header('Location: index.php?error=Producto no encontrado');
    exit;
}

try {
    // Verificar si el producto tiene pedidos asociados
    $pedidos = $db->selectOne("SELECT COUNT(*) as total FROM pedidos WHERE producto_id = ?", [$id]);
    
    if ($pedidos['total'] > 0) {
        // Si tiene pedidos, solo desactivar en lugar de eliminar
        $query = "UPDATE productos SET activo = 0 WHERE id = ?";
        $mensaje = "Producto desactivado (tenía pedidos asociados)";
    } else {
        // Si no tiene pedidos, eliminar completamente
        $query = "DELETE FROM productos WHERE id = ?";
        $mensaje = "Producto eliminado exitosamente";
    }
    
    if ($db->execute($query, [$id])) {
        header("Location: index.php?mensaje=" . urlencode($mensaje));
    } else {
        header('Location: index.php?error=Error al eliminar el producto');
    }
    
} catch (Exception $e) {
    header('Location: index.php?error=Error: ' . urlencode($e->getMessage()));
}

exit;
?>