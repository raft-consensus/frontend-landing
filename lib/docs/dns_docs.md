
# Guía Técnica: Integración API DNS de Cloudflare para Raft DB

Este documento contiene la documentación completa paso a paso para administrar registros DNS de forma automatizada mediante la API v4 de Cloudflare para el dominio **coderhivex.com**.

---

## 1. Credenciales y Configuración de Zona

- **Dominio Principal:** `coderhivex.com`
- **Zone ID Activa:** `c1c62663d28fa916dc9bc030103e6e83`
- **Tipo de Autenticación:** Bearer API Token
- **Permisos requeridos en Cloudflare:** `Zone.DNS:Edit`

---

## 2. Paso 1: Obtención del Zone ID (Desde Cero)

Para consultar el identificador único (`zone_id`) del dominio desde cualquier consola cURL / Bash:

```bash
curl -X GET "https://api.cloudflare.com/client/v4/zones?name=coderhivex.com" \
     -H "Authorization: Bearer TU_API_TOKEN_CLOUDFLARE" \
     -H "Content-Type: application/json"
```

### Respuesta esperada (JSON):

Extraer el valor del campo `result[0].id` con estado `"status": "active"`.
En nuestro caso, el `zone_id` activo es: **`c1c62663d28fa916dc9bc030103e6e83`**.

---

## 3. Paso 2: Creación de Registro DNS tipo A (Sin Proxy / Direct TCP)

Para aprovisionar un subdominio directo apuntando a la IP pública de una instancia de base de datos Raft DB, el registro debe crearse con **`proxied: false`** (Nube gris) para permitir tráfico directo sin interferencia del CDN/WAF.

### Comando cURL Ejecutable:

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/c1c62663d28fa916dc9bc030103e6e83/dns_records" \
     -H "Authorization: Bearer TU_API_TOKEN_CLOUDFLARE" \
     -H "Content-Type: application/json" \
     --data '{
       "type": "A",
       "name": "midb",
       "content": "198.51.100.1",
       "ttl": 1,
       "proxied": false
     }'
```

---

## 4. Parámetros del Body (Payload)

| Parámetro  | Tipo    | Descripción                                                    | Ejemplo                                     |
| :---------- | :------ | :-------------------------------------------------------------- | :------------------------------------------ |
| `type`    | String  | Tipo de registro DNS                                            | `"A"`                                     |
| `name`    | String  | Subdominio a crear                                              | `"midb"` (Genera `midb.coderhivex.com`) |
| `content` | String  | Dirección IPv4 del servidor de BD                              | `"198.51.100.1"`                          |
| `ttl`     | Integer | Tiempo de vida (1 = Automático)                                | `1`                                       |
| `proxied` | Boolean | `false` desactiva el proxy de Cloudflare (Requerido para BDs) | `false`                                   |

---

## 5. Estructura de Respuesta Exitosa (200 OK)

```json
{
  "result": {
    "id": "372782c01476e4d7751c1496597806ef",
    "zone_id": "c1c62663d28fa916dc9bc030103e6e83",
    "zone_name": "coderhivex.com",
    "name": "midb.coderhivex.com",
    "type": "A",
    "content": "198.51.100.1",
    "proxiable": true,
    "proxied": false,
    "ttl": 1
  },
  "success": true,
  "errors": [],
  "messages": []
}
```

---

## 6. Siguientes Pasos (Integración en Backend C# / Node)

Cuando el backend aprovisione una base de datos o servicio DNS automáticamente:

1. Recibe el nombre asignado a la instancia.
2. Invoca el endpoint `POST /client/v4/zones/{zone_id}/dns_records`.
3. Inyecta el token Bearer en los cabezales HTTP.
4. Retorna al usuario el FQDN resolbible: `{subdominio}.coderhivex.com`.
