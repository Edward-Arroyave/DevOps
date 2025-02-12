# Live_Lis - Gestión de Versionamiento de Base de Datos

Este proyecto permite la gestión eficiente de migraciones de bases de datos utilizando **Flyway Community Desktop**, con integración continua mediante **GitHub Actions**.

## 📋 Requisitos

Para ejecutar y administrar las migraciones, asegúrese de contar con los siguientes requisitos:

- **Flyway Community Desktop**: Para administración avanzada.
- **GitHub**: Para integración continua y despliegues automatizados.
- **Git**: Para control de cambios 


## ⚙️ Configuración

Modifique `flyway.toml` con las credenciales de su base de datos:

```toml
flyway.url=jdbc:sqlserver://dev-ops-pruebas01.database.windows.net:1433;databaseName=LiveLis
flyway.user=tu_usuario
flyway.password=tu_contraseña
```

## 🚀 Ejecución de Migraciones

### ➤ Para ejecutar migraciones en el entorno local:

Ejecute el siguiente comando:

```sh
flyway migrate
```

## 🔄 Integración Continua

El proceso de despliegue está automatizado mediante **GitHub Actions**. Para ejecutar una migración automática:

1. Realice un **push** a la rama principal.
2. El workflow `deploy.yml` aplicará los cambios en la base de datos automáticamente.



