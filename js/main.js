// JavaScript personalizado para el CRUD

document.addEventListener('DOMContentLoaded', function() {
    // Auto-ocultar alertas después de 5 segundos
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
    
    // Agregar clase fade-in a las cards
    const cards = document.querySelectorAll('.card');
    cards.forEach(function(card) {
        card.classList.add('fade-in');
    });
    
    // Confirmar eliminación con SweetAlert (si está disponible)
    window.confirmarEliminacion = function(id, nombre) {
        if (typeof Swal !== 'undefined') {
            Swal.fire({
                title: '¿Estás seguro?',
                text: `¿Quieres eliminar el producto "${nombre}"?`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = `eliminar.php?id=${id}`;
                }
            });
        } else {
            // Fallback al modal de Bootstrap
            document.getElementById('producto-nombre').textContent = nombre;
            document.getElementById('confirm-delete').href = `eliminar.php?id=${id}`;
            new bootstrap.Modal(document.getElementById('confirmModal')).show();
        }
    };
    
    // Validación en tiempo real para formularios
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(function(form) {
        const inputs = form.querySelectorAll('input, select, textarea');
        
        inputs.forEach(function(input) {
            input.addEventListener('blur', function() {
                if (this.checkValidity()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                } else {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                }
            });
            
            input.addEventListener('input', function() {
                if (this.classList.contains('is-invalid') && this.checkValidity()) {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                }
            });
        });
    });
    
    // Formatear precio automáticamente
    const precioInput = document.getElementById('precio');
    if (precioInput) {
        precioInput.addEventListener('input', function() {
            let value = this.value;
            if (value && !isNaN(value)) {
                // Opcional: formatear mientras se escribe
                this.value = parseFloat(value).toFixed(2);
            }
        });
    }
    
    // Validación de stock
    const stockInput = document.getElementById('stock');
    if (stockInput) {
        stockInput.addEventListener('input', function() {
            if (this.value < 0) {
                this.value = 0;
            }
        });
    }
    
    // Búsqueda en tiempo real (opcional)
    const searchInput = document.querySelector('input[name="buscar"]');
    if (searchInput) {
        let searchTimeout;
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                if (this.value.length > 2 || this.value.length === 0) {
                    // Aquí podrías implementar búsqueda AJAX
                    console.log('Buscar:', this.value);
                }
            }, 300);
        });
    }
    
    // Tooltip para botones
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Mejorar la experiencia de la tabla
    const tableRows = document.querySelectorAll('tbody tr');
    tableRows.forEach(function(row) {
        const producto = row.querySelector('td:nth-child(2)'); // Columna del nombre
        if (producto) {
            const activo = row.querySelector('.badge').textContent.trim() === 'Activo';
            row.classList.add(activo ? 'producto-activo' : 'producto-inactivo');
        }
    });
    
    // Confirmar antes de salir si hay cambios sin guardar
    let formChanged = false;
    const formInputs = document.querySelectorAll('form input, form select, form textarea');
    formInputs.forEach(function(input) {
        input.addEventListener('change', function() {
            formChanged = true;
        });
    });
    
    window.addEventListener('beforeunload', function(e) {
        if (formChanged) {
            e.preventDefault();
            e.returnValue = '';
        }
    });
    
    // Resetear flag cuando se envía el formulario
    const submitButtons = document.querySelectorAll('button[type="submit"]');
    submitButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            formChanged = false;
        });
    });
    
    // Función para mostrar loading en botones
    window.showLoading = function(button) {
        const originalText = button.innerHTML;
        button.innerHTML = '<span class="loading"></span> Procesando...';
        button.disabled = true;
        
        // Restaurar después de 3 segundos (como fallback)
        setTimeout(function() {
            button.innerHTML = originalText;
            button.disabled = false;
        }, 3000);
    };
    
    // Aplicar loading a formularios
    forms.forEach(function(form) {
        form.addEventListener('submit', function(e) {
            if (form.checkValidity()) {
                const submitBtn = form.querySelector('button[type="submit"]');
                if (submitBtn) {
                    showLoading(submitBtn);
                }
            }
        });
    });
    
    // Función para números con formato
    window.formatearPrecio = function(precio) {
        return new Intl.NumberFormat('es-CL', {
            style: 'currency',
            currency: 'CLP'
        }).format(precio);
    };
    
    // Aplicar formato a precios existentes
    const precios = document.querySelectorAll('.text-precio');
    precios.forEach(function(precio) {
        const valor = precio.textContent.replace('$', '').replace(',', '');
        if (!isNaN(valor)) {
            precio.textContent = formatearPrecio(parseFloat(valor));
        }
    });
});

// Función para recargar la página con mensaje
window.recargarConMensaje = function(mensaje, tipo = 'success') {
    const url = new URL(window.location);
    url.searchParams.set(tipo === 'success' ? 'mensaje' : 'error', mensaje);
    window.location.href = url.toString();
};

// Función para copiar código de barras
window.copiarCodigoBarras = function(codigo) {
    navigator.clipboard.writeText(codigo).then(function() {
        // Mostrar tooltip o mensaje
        console.log('Código copiado:', codigo);
    });
};

// Función para exportar datos (básica)
window.exportarDatos = function() {
    const tabla = document.querySelector('.table');
    if (tabla) {
        const filas = tabla.querySelectorAll('tr');
        let csv = '';
        
        filas.forEach(function(fila) {
            const celdas = fila.querySelectorAll('th, td');
            const filaData = [];
            
            celdas.forEach(function(celda) {
                filaData.push(celda.textContent.trim());
            });
            
            csv += filaData.join(',') + '\n';
        });
        
        const blob = new Blob([csv], { type: 'text/csv' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'productos.csv';
        a.click();
        window.URL.revokeObjectURL(url);
    }
};