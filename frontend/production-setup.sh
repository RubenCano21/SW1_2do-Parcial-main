#!/bin/bash

# Frontend Production Setup Script
# Este script ayuda con tareas comunes de deployment del frontend

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Banner
echo "=================================================="
echo "   Frontend Production Setup Helper"
echo "   React + Vite + TypeScript"
echo "=================================================="
echo ""

# Menú principal
show_menu() {
    echo ""
    echo "Selecciona una opción:"
    echo "1) Instalar dependencias"
    echo "2) Build para producción"
    echo "3) Preview del build"
    echo "4) Limpiar y rebuild"
    echo "5) Verificar variables de entorno"
    echo "6) Crear archivo .env desde .env.example"
    echo "7) Analizar bundle size"
    echo "8) Test de build completo"
    echo "9) Verificar configuración de Render"
    echo "0) Salir"
    echo ""
}

# 1. Instalar dependencias
install_deps() {
    print_info "Instalando dependencias..."
    npm install
    print_success "Dependencias instaladas"
}

# 2. Build para producción
build_prod() {
    print_info "Construyendo para producción..."
    npm run build
    
    if [ -d "dist" ]; then
        print_success "Build completado exitosamente"
        print_info "Archivos en: ./dist"
        du -sh dist
    else
        print_error "Build falló - directorio dist no creado"
        exit 1
    fi
}

# 3. Preview del build
preview_build() {
    if [ ! -d "dist" ]; then
        print_error "No hay build disponible. Ejecuta 'npm run build' primero"
        exit 1
    fi
    
    print_info "Iniciando preview en http://localhost:4173"
    npm run preview
}

# 4. Limpiar y rebuild
clean_rebuild() {
    print_info "Limpiando directorios..."
    rm -rf dist
    rm -rf node_modules
    print_success "Limpieza completada"
    
    print_info "Instalando dependencias..."
    npm install
    
    print_info "Construyendo..."
    npm run build
    
    print_success "Rebuild completado"
}

# 5. Verificar variables de entorno
check_env() {
    print_info "Verificando configuración de variables de entorno..."
    
    if [ -f ".env" ]; then
        print_success "Archivo .env encontrado"
        echo ""
        echo "Variables configuradas:"
        cat .env | grep -v '^#' | grep -v '^$'
    else
        print_error "Archivo .env NO encontrado"
        print_info "Crea uno desde .env.example"
    fi
    
    echo ""
    print_info "Variables requeridas para producción:"
    echo "  - VITE_API_URL (URL del backend)"
    echo "  - VITE_WS_URL (URL WebSocket, normalmente igual al API)"
}

# 6. Crear .env desde .env.example
create_env() {
    if [ ! -f ".env.example" ]; then
        print_error ".env.example no encontrado"
        exit 1
    fi
    
    if [ -f ".env" ]; then
        print_info "Ya existe un archivo .env"
        read -p "¿Deseas sobrescribirlo? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
            print_info "Operación cancelada"
            return
        fi
    fi
    
    cp .env.example .env
    print_success "Archivo .env creado desde .env.example"
    print_info "Edita .env y configura tus variables"
}

# 7. Analizar bundle size
analyze_bundle() {
    print_info "Instalando herramienta de análisis..."
    npm install --save-dev rollup-plugin-visualizer
    
    print_info "Construyendo con análisis..."
    npm run build
    
    if [ -f "stats.html" ]; then
        print_success "Análisis completado"
        print_info "Abre stats.html en tu navegador para ver el análisis"
    else
        print_info "Agrega esto a vite.config.ts:"
        echo ""
        echo "import { visualizer } from 'rollup-plugin-visualizer'"
        echo ""
        echo "export default defineConfig({"
        echo "  plugins: [react(), visualizer({ open: true })]"
        echo "})"
    fi
}

# 8. Test de build completo
full_test() {
    print_info "Ejecutando test completo de build..."
    
    echo ""
    print_info "Paso 1/4: Linting..."
    npm run lint
    print_success "Linting completado"
    
    echo ""
    print_info "Paso 2/4: Limpiando build anterior..."
    rm -rf dist
    print_success "Limpieza completada"
    
    echo ""
    print_info "Paso 3/4: Building..."
    npm run build
    print_success "Build completado"
    
    echo ""
    print_info "Paso 4/4: Verificando dist/..."
    if [ -d "dist" ]; then
        echo "Contenido de dist/:"
        ls -lh dist/
        echo ""
        print_success "Test completo exitoso"
    else
        print_error "dist/ no fue creado"
        exit 1
    fi
}

# 9. Verificar configuración de Render
check_render_config() {
    print_info "Verificando configuración de Render..."
    
    echo ""
    echo "=== Checklist de Render ==="
    
    # Verificar render.yaml
    if [ -f "render.yaml" ]; then
        print_success "render.yaml encontrado"
    else
        print_error "render.yaml NO encontrado"
    fi
    
    # Verificar package.json scripts
    if grep -q '"start"' package.json; then
        print_success "Script 'start' definido en package.json"
    else
        print_error "Script 'start' NO encontrado en package.json"
    fi
    
    # Verificar .gitignore
    if grep -q '.env' .gitignore; then
        print_success ".env en .gitignore"
    else
        print_error ".env NO está en .gitignore"
    fi
    
    # Verificar dist/ no está committeado
    if grep -q 'dist' .gitignore; then
        print_success "dist/ en .gitignore"
    else
        print_error "dist/ NO está en .gitignore"
    fi
    
    echo ""
    print_info "Configuración esperada de Render:"
    echo "  - Build Command: npm install && npm run build"
    echo "  - Publish Directory: dist"
    echo "  - Root Directory: frontend"
    
    echo ""
    print_info "Variables de entorno requeridas en Render:"
    echo "  - VITE_API_URL=https://tu-backend.onrender.com"
    echo "  - VITE_WS_URL=https://tu-backend.onrender.com"
}

# Loop principal
while true; do
    show_menu
    read -p "Opción: " choice
    
    case $choice in
        1) install_deps ;;
        2) build_prod ;;
        3) preview_build ;;
        4) clean_rebuild ;;
        5) check_env ;;
        6) create_env ;;
        7) analyze_bundle ;;
        8) full_test ;;
        9) check_render_config ;;
        0) 
            print_success "¡Hasta luego!"
            exit 0
            ;;
        *)
            print_error "Opción inválida"
            ;;
    esac
done
