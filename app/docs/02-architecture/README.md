# 🏗️ Architecture

Documentación sobre la arquitectura del sistema y decisiones de diseño.

---

## 📄 Documentos en esta sección

### [ARCHITECTURE.md](./ARCHITECTURE.md)
Arquitectura general de la aplicación, incluyendo diagramas y flujos de datos.

### [Arquitectura Flutter](./arquitectura_flutter.md)
Implementación de Clean Architecture en Flutter, organización de capas y principios SOLID.

### [Sistema de Módulos](./modulos.md)
Documentación del sistema de módulos multi-tenant y cómo funcionan los permisos granulares.

---

## 🎯 Principios Arquitectónicos

### Clean Architecture
- **Domain Layer**: Entidades y lógica de negocio
- **Data Layer**: Repositories e implementaciones
- **Presentation Layer**: UI, providers y widgets

### Dependency Injection
- **Riverpod**: Providers centralizados
- **Supabase Client**: Inyección via provider

### State Management
- **Riverpod**: Estado reactivo
- **AsyncValue**: Manejo de estados asíncronos

---

## 📊 Diagrama de Capas

```
┌──────────────────────────────────┐
│   Presentation Layer             │
│   (Widgets, Screens, Providers)  │
└──────────────┬───────────────────┘
               │
┌──────────────▼───────────────────┐
│   Domain Layer                   │
│   (Entities, Repositories)       │
└──────────────┬───────────────────┘
               │
┌──────────────▼───────────────────┐
│   Data Layer                     │
│   (Supabase, API, Local DB)      │
└──────────────────────────────────┘
```

---

## 🔗 Enlaces Relacionados

- [Guías Técnicas](../03-guides/README.md)
- [Base de Datos](../04-database/README.md)
- [Getting Started](../01-getting-started/README.md)
