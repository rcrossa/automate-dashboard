# 📚 Documentación - Mi Primera App

Bienvenido a la documentación del proyecto. Esta guía te ayudará a navegar por todos los recursos disponibles.

---

## 📂 Estructura de Documentación

### 🚀 [01 - Getting Started](./01-getting-started/)
**Para**: Nuevos desarrolladores  
**Contenido**: Contexto del proyecto, guía de desarrollo inicial

- [Contexto del Proyecto](./01-getting-started/contexto_proyecto.md)
- [Gu ía de Desarrollo](./01-getting-started/guia_desarrollo.md)

---

### 🏗️ [02 - Architecture](./02-architecture/)
**Para**: Desarrolladores, arquitectos  
**Contenido**: Arquitectura del sistema, decisiones de diseño

- [ARCHITECTURE.md](./02-architecture/ARCHITECTURE.md) - Arquitectura general
- [Arquitectura Flutter](./02-architecture/arquitectura_flutter.md) - Clean Architecture
- [Sistema de Módulos](./02-architecture/modulos.md) - Módulos multi-tenant

---

### 📚 [03 - Guides](./03-guides/)
**Para**: Desarrolladores, administradores  
**Contenido**: Guías técnicas específicas por feature

#### Mobile & Build
- [Android APK](./03-guides/android-apk.md) - Generar e instalar APKs

#### UI/UX
- [Responsive Design](./03-guides/responsive-design.md) - Diseño adaptativo
- [Theming - User Guide](./03-guides/theming-user-guide.md) - Configuración visual
- [Theming - Technical](./03-guides/theming-technical.md) - Sistema de theming

#### Features
- [Speech-to-Text](./03-guides/speech-to-text.md) - Grabación y transcripción de audio

#### Testing
- [Integration Tests](./03-guides/testing/integration-tests.md) - Setup y ejecución

---

### 🗄️ [04 - Database](./04-database/)
**Para**: Desarrolladores backend, DBAs  
**Contenido**: Schemas, migrations, configuración de Supabase

- [Schema SQL](./04-database/schema.sql) - Schema maestro
- [Migrations](./04-database/migrations/) - Archivos de migraciones
- [Guides](./04-database/guides/) - Storage setup, theming SQL

---

### 📋 [05 - Project Management](./05-project-management/)
**Para**: Todo el equipo  
**Contenido**: Tareas, pendientes, walkthroughs

- [Pendientes](./05-project-management/pendientes.md) - Tareas y deuda técnica
- [Implementation Plan](./05-project-management/implementation_plan.md) - Plan actual
- [Walkthroughs](./05-project-management/walkthroughs/) - Sesiones de desarrollo

---

## 🎯 Guías Rápidas

### Para Nuevos Desarrolladores
1. Lee [Contexto del Proyecto](./01-getting-started/contexto_proyecto.md)
2. Configura tu entorno con [Guía de Desarrollo](./01-getting-started/guia_desarrollo.md)
3. Revisa [Arquitectura Flutter](./02-architecture/arquitectura_flutter.md)
4. Ejecuta tests: `flutter test`

### Para Generar APK
1. Lee [Android APK Guide](./03-guides/android-apk.md)
2. Ejecuta: `flutter build apk --debug`
3. APK en: `build/app/outputs/flutter-apk/`

### Para Configurar Theming
1. **Usuarios**: [Theming User Guide](./03-guides/theming-user-guide.md)
2. **Técnico**: [Theming Technical](./03-guides/theming-technical.md)

### Para Migrar Base de Datos
1. Revisa [Database README](./04-database/README.md)
2. Ejecuta migration con Supabase CLI o Dashboard

---

## 🔍 Índice Alfabético

- Android APK → [03-guides/android-apk.md](./03-guides/android-apk.md)
- Architecture → [02-architecture/](./02-architecture/)
- Base de Datos → [04-database/](./04-database/)
- Contexto Proyecto → [01-getting-started/contexto_proyecto.md](./01-getting-started/contexto_proyecto.md)
- Getting Started → [01-getting-started/](./01-getting-started/)
- Integration Tests → [03-guides/testing/integration-tests.md](./03-guides/testing/integration-tests.md)
- Migrations → [04-database/migrations/](./04-database/migrations/)
- Módulos → [02-architecture/modulos.md](./02-architecture/modulos.md)
- Pendientes → [05-project-management/pendientes.md](./05-project-management/pendientes.md)
- Responsive Design → [03-guides/responsive-design.md](./03-guides/responsive-design.md)
- Schema SQL → [04-database/schema.sql](./04-database/schema.sql)
- Speech-to-Text → [03-guides/speech-to-text.md](./03-guides/speech-to-text.md)
- Theming → [03-guides/](./03-guides/) (User + Technical)

---

## 📊 Estado del Proyecto

### ✅ Completado (100%)
- Sistema de Theming Multi-Tenant
- Responsive Design (Mobile/Tablet/Desktop)
- Logo System
- Internacionalización (ES/EN)
- Integration Tests Setup
- Android APK Build Pipeline
- Speech-to-Text Module (Recording + Transcription)

### 🚧 En Progreso
Ver [Pendientes](./05-project-management/pendientes.md) para tareas actuales

---

## 🛠️ Stack Tecnológico

- **Frontend**: Flutter 3.32.2
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **State Management**: Riverpod
- **Testing**: flutter_test + integration_test
- **CI/CD**: (Pendiente)

---

## 📞 Contacto y Soporte

Para preguntas sobre la documentación o el proyecto:
- Revisa [Pendientes](./05-project-management/pendientes.md) primero
- Consulta la guía específica en [Guides](./03-guides/)
- Contacta al equipo de desarrollo

---

**Última actualización**: 14 Diciembre 2025  
**Versión de la app**: 1.0.0+1
