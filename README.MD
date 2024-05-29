# Parte 1: Preguntas Teóricas
## Conceptos de Bases de Datos

### Diferencia entre una base de datos relacional y una base de datos NoSQL

Una **base de datos relacional** utiliza tablas relacionadas entre sí para almacenar los datos. Por otro lado, una **base de datos NoSQL**, como MongoDB, utiliza listas de archivos con clave-valor (JSON) para acceder a los datos.

#### Ejemplo de Base de Datos Relacional

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);
```

En este ejemplo, tenemos dos tablas relacionadas entre sí:
- La tabla `departments` tiene dos campos: `id` (llave primaria) y `name`, donde se almacena el nombre de los departamentos.
- La tabla `employees` tiene cuatro campos: `id` (llave primaria), `name`, `department_id` (llave foránea) y `salary`. La llave primaria `id` identifica cada empleado de manera única, y la llave foránea `department_id` relaciona a cada empleado con su departamento correspondiente.

#### Ejemplo de Base de Datos No Relacional (MongoDB)

```javascript
db.departments.insertMany([
    { name: 'Ryan' },
    { name: 'Joanna' }
]);

db.employees.insertMany([
    { name: 'Ryan', department_id: '66560d5d2b01d5804f4ec05e', salary: 12.2 }
]);
```

En este ejemplo, la estructura es mucho más flexible:
- La colección `departments` solo tiene el campo `name`, que almacena el nombre del departamento. MongoDB crea automáticamente una `_id` única para cada registro.
- En la colección `employees`, almacenamos el nombre del empleado (`name`), el salario (`salary`) y la `_id` del departamento al que pertenece (`department_id`).

## Transacciones en Bases de Datos

Una **transacción** en una base de datos es una unidad o secuencia de trabajo que se ejecuta de manera ordenada y separada. Las propiedades ACID garantizan la integridad y consistencia de las transacciones:

- **Atomicidad**: Todas las operaciones de una transacción se completan con éxito o se cancelan por completo.
- **Consistencia**: La base de datos pasa de un estado válido a otro estado válido.
- **Aislamiento**: Varias transacciones pueden ocurrir simultáneamente sin interferir entre sí.
- **Durabilidad**: Los cambios de una transacción exitosa persisten incluso si ocurren fallas en el sistema.

## Normalización en Bases de Datos

La **normalización** es un proceso que se aplica a tablas mal diseñadas para reducir la redundancia de información. Consiste en dividir una tabla en varias tablas más pequeñas. La normalización es importante porque:

- Optimiza el espacio de almacenamiento.
- Evita acciones no deseadas, como eliminación o actualización de elementos no deseados.

## APIs y REST

- **API**: Es una conexión entre aplicaciones que permite la comunicación entre ellas.
- **API REST**: Es una arquitectura de creación de APIs utilizando el protocolo HTTP. Utiliza métodos HTTP como GET, POST, DELETE, PUT y PATCH para interactuar con los recursos.

## Códigos de Estado HTTP

- **HTTP 200**: "OK". La solicitud se realizó con éxito.
- **HTTP 201**: "Created". La solicitud se realizó con éxito y se creó un nuevo recurso.
- **HTTP 400**: "Bad Request". El servidor no puede procesar la solicitud..
- **HTTP 404**: "Not Found". El recurso solicitado no existe.
- **HTTP 500**: "Internal Server Error". Error interno del servidor.

## Explica qué es el versionado de APIs y por qué es importante.

- **El versionado de APIs**  es un proceso donde se gestiona y actualiza los cambios a la API de tal forma que no interrumpan el funcionamiento de las aplicaciones que usan esa API. Es importante para mantener la escalabilidad de la API sin comprometer los servicios que esta ofrece, para que de tal manera todas las aplicaciones que consuman esa api no dejen funcionar.


## Autenticación y Autorización:

### Diferencia entre autenticación y autorización

- **Autentificación** es la validación de las credenciales del usuario, un ejemplo sería al momento de loguearse, un usuario debe autentificarse

- **Autorización** es el permiso que tiene un usuario para consumir ciertos recursos, un ejemplo sería que en un ecommerce un usuario puede comprar cosas, pero no puede editar productos, porque no tiene autorización para ello.

### ¿Qué es OAuth2 y cómo se usa en aplicaciones web?
- **¿Qué es OAuth2?** : Es un protocolo de autorización en la web que permite a los usuarios compartir sus datos a terceros pero sin comprometer sus credenciales.
- Un ejemplo de uso es el token de github, cuando no estamos validados en git para obtener un repositorio y no tenemos las credenciales, con el token podemos obtener el repositorio y actualizarlo: 
```git clone https://[token]@github.com/[organization]/[repo].git```
así de esta forma no se compromete las credenciales del usuario si el caso es que está compartiendo un repositorio.

## Describe cómo implementarías un sistema de autenticación basado en tokens.

- Usando un JWT, podemos hacer un endpoint en el backend que reciba las credenciales email y password, primero verificamos si el email existe en la base de datos, si no existe respondemos un message de usuario no encontrado, si el email está registrado comparamos las contraseñas, si no son iguales respondemos un message con contraseña incorrecta, pero de ser correcta. usando una función para crear el token podemos enviar los parámetros que vamos a guardar en el token, cuando el token se cree con éxito lo guardamos en una cookie y lo respondemos.

    ``` javascript
    export function createAccessToken(_id) {
        return new Promise((resolve, reject) => {
            const payload = { _id };
            jwt.sign(
                payload,
                process.env.JWT_SECRET,
                (err, token) => {
                    if (err) reject(err);
                    resolve(token);
                }
            );
        });
    }
    ```
    - Esta es una promesa para crear un token, obtiene la _id del usuario, este es su payload, para crear el token se necesita el payload y una llave secreata, está llave servirá para desencriptar el token.


# Parte 2: Ejercicios de Código
## SQL - Consulta
Tienes dos tablas employees y departments en una base de datos relacional:

 ``` sql
        CREATE TABLE employees (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        department_id INT,
        salary DECIMAL(10, 2)
        );
        CREATE TABLE departments (
        id INT PRIMARY KEY,
        name VARCHAR(100)
    );
 ```
- Escribe una consulta SQL para encontrar el nombre del departamento que tiene el salario promedio más alto. (Trampa: Asegúrate de considerar el caso donde hay múltiples departamentos con el mismo salario promedio más alto.)
    ```sql
    SELECT dep.name AS "Departamento", AVG(emp.salary) AS "Salario Promedio"
    FROM departments dep
    JOIN employees emp ON dep.id = emp.department_id
    GROUP BY dep.id
    HAVING AVG(emp.salary) = (
        SELECT MAX(avgSalary)
        FROM (
            SELECT AVG(emp2.salary) AS avgSalary
            FROM employees emp2
            GROUP BY emp2.department_id
        ) AS subquery
    )
    ORDER BY "Salario Promedio" DESC;
    ```

- Nota: yo crearía las tablas de la siguiente manera:
    ```sql
        CREATE TABLE departments (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(100)
            );
            CREATE TABLE employees (
            id INT PRIMARY KEY AUTO_INCREMENT,
            name VARCHAR(100),
            department_id INT,
            salary DECIMAL(10, 2)
            FOREIGN KEY (department_id) REFERENCES departments(id)
        );
    ```
    - En las llaves principales de las tablas se añadió un `AUTO_INCREMENT` que me ayudará a que que la id de cada tabla sea única ya que se va incrementar de 1 en 1 por sí sola, por lo que cuando vayamos a insertar datos no tenemos que insertar la id. También agregaría `FOREIGN KEY (department_id) REFERENCES departments(id)` en la tabla de employees para relacionar las tablas entre sí, esto me permitirá llevar un mejor control, ya que si algún departamento tiene empleado, no podríamos eliminar ese departamento.

## Node.js - API Endpoint con Validaciones:
- Implementa un endpoint en Node.js usando Express que permite crear un nuevo usuario. El  endpoint debe validar que:  El correo electrónico no esté ya registrado en una base de datos ficticia. La contraseña tenga al menos 8 caracteres, una letra mayúscula, una minúscula y un número. El nombre no esté vacío. Usa una estructura en memoria para simular la base de datos:
    ```javascript
    const express = require('express');
    const app = express();
    app.use(express.json());
    let users = [
    { email: 'test@example.com', name: 'John Doe', password: 'Password123' }
    ];
    app.post('/register', (req, res) => {
    const { email, name, password } = req.body;
    // Completa esta función con las validaciones necesarias
    });
    app.listen(3000, () => {
    console.log('Server running on port 3000');
    })

    ```
- Mi implementación
    ```javascript
    const express = require('express');
    const app = express();
    app.use(express.json());
    let users = [
    { email: 'test@example.com', name: 'John Doe', password: 'Password123' }
    ];

    app.post('/register', (req, res) => {
        const { email, name, password } = req.body;
        const expectedPassword = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/
        
        if(!(email || name || password)){
            res.status(400).send("Faltan datos")
        }

        if(users.some(user => user.email === email)){
            res.status(400).send("El email ya existe")
        }

        if(!expectedPassword.test(password)){
            res.status(400).send("la contraseña debe tener minimo 8 caracteres, una letra mayuscula, una minuscula y un numero")
        }

        res.status(200).send("Registro exitoso")

    });



    app.listen(3000, () => {
    console.log('Server running on port 3000');

    })
    ```

## Lógica y Atención al Detalle
- Escribe una función en JavaScript que reciba una lista de números y devuelva el número más grande.

    ```javascript
    function findLargestNumber(numbe) {
        let largest = numbers[0];
        for (let i = 1; i < numbers.length; i++) {
        if (numbers[i] < largest) {
        largest = numbers[i];
        }
        }
        return largest;
    }
    // Prueba la función
    console.log(findLargestNumber([1, 2, 3, 4, 5]));
    ```
    - El codigo no debe correr. 
        - La funcion recibe el parameto `numbe` y dentro de la funcion se esta usando una variable no definida `numbers`, por ende no debería correr el codigo.
        - Si arreglamos el parametro y la función logra correr, la función no cumpliría su proposito, el cual es devolver el número mas grande de la lista, si no que lo que hace la función es devolver el número más pequeño, si analizamos el codigo: 
            ```javascript
            let largest = numbers[0];
            for (let i = 1; i < numbers.length; i++) {
                if (numbers[i] < largest) {
                largest = numbers[i];
                }
            }
            ```
            El problema está en el `if` dentro del `for`, el for cumple su trabajo empieza a recorrer la lista desde la posición 1 hasta la cantidad de elementos de la lista, y se ingrementa de uno en uno, y teniendo en cuenta que `largest` al principio del for tiene la posición cero de la lista, podemos asegurar que la lista se va recorrer en su totalidad.
            Pero si vemos la `condición` `(numbers[i] < largest)`, notamos que compara el númeor actual con `largest`, y si es menor `largest = numbers[i];` le asigna a `largest` ese valor. En resumen se esta creando una variable auxiliar `largest` que empieza con el primer número de la lista, y al momento de recorrer la lista se evalua si el número actual es menor que el número que hay en la variable auxiliar `largest` lo reemplaza, por ende al final del for no vamos a obtener el número mas grande de la lista, vamos a obtener el número menor de la lista.
        - Función corregida: 
            ```javascript
                function findLargestNumber(numbers) {
                    let largest = numbers[0];
                    for (let i = 1; i < numbers.length; i++) {
                    if (numbers[i] > largest) {
                    largest = numbers[i];
                    }
                    }
                    return largest;
                }
                // Prueba la función
                console.log(findLargestNumber([1, 2, 3, 4, 5]));
            ```
## Node.js - Middleware y Manejo de Errores:
Implementa un middleware en Express que registre todas las solicitudes entrantes (método
y URL) en la consola. Además, implementa un manejo global de errores que devuelva un
mensaje de error en formato JSON.

```javascript
const express = require('express');
const app = express();
// Middleware para registrar solicitudes
app.use((req, res, next) => {
console.log(`${req.method} ${req.url}`);
next();
});
app.get('/', (req, res) => {
res.send('Hello World');
});
app.use((err, req, res, next) => {
console.error(err.stack);
res.status(500).json({ error: 'Something went wrong!' });
});
```
- El codigo proporcionado cuenta con dos middlerwares,  aquí una descripción:
    - El primer middleware `app.use((req, res, next) => {...})` obtiene del request el `metodo HTTP` y tambien obtiene la `URL` o mas bien el `PATH` de la URL y lo imprime en la consola, y luego llama a `next()` para que pase al siguiente middleware o la siguiente ruta.
    - El segundo middleware `app.use((err, req, res, next) => {...})` este middlerware se encarga de manejar los errores, se activa una vez se llama un next() con algun argumento. 
    Cuando está activo imprime el error en la consola y se responde con un status 500 y un mensaje de error en formato JSON.
    - Sin embargo, el segundo middleware no se llame en ningun momento, aquí un codigo donde si se utiliza:
        ```javascript
        const express = require('express');
        const app = express();
        // Middleware para registrar solicitudes
        app.use((req, res, next) => {
        console.log(`${req.method} ${req.url}`);
        next();
        });

        app.get('/', (req, res) => {
        res.send('Hello World');
        });


        app.get('/error', (req, res, next)=>{
            try{
                throw new Error("Hay un error")
            }catch(e){
                next(e);
            }
        })

        app.use((err, req, res, next) => {
            console.error(err.stack);
            res.status(500).json({ error: 'Something went wrong!' });
        });

        app.listen(3000, () => {
            console.log('Server running on port 3000');
        });
        ```
        En este código se simuló un error en un middleware de ruta a las solicitudes GET /error, con la línea `throw new Error("Hay un error")` simulamos un error asegurandonos de que este endpoint siempre dará un error.
        Esto asegura que cualquier error no manejado en las rutas sea gestionado por el middleware de manejo de errores.

## Algoritmo de Ordenamiento:
Escribe una función en JavaScript para ordenar una lista de números usando el algoritmo
de burbuja. Introduce una trampa lógica:

```javascript

function bubbleSort(arr) {
    let n = arr.length;
    for (let i = 0; i < n-1; i++) {
        for (let j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                [arr[j], arr[j+1]] = [arr[j+1], arr[j]];
            }
        }
    }
    return arr;
}
// Prueba la función
console.log(bubbleSort([5, 1, 4, 2, 8]));
```
La implementeción del metodo burbuja es correcta, explicación:
      
-  Primero se comparan los dos primeros elementos
    [`5`, `1`, 4, 2, 8] como es la primera iteración con `i`, entonces con `j` tambien vamos a recorrer toda la lista, en esta iteración vamos a comparar todos los elementos y si el elemento de la izquiera es mas grande que el de la derecha se van a intercambiar posiciónes: 
    
- Primera iteación (`i`=0):
    - [`5`, `1`, 4, 2, 8] = [`1`, `5`, 4, 2, 8] 5 es mayor a 1, se intercambian.
    - [1, `5`, `4`, 2, 8] = [1, `4`, `5`, 2, 8] 5 es mayor a 4, se intercambian.
    - [1, 4, `5`, `2`, 8] = [1, 4, `2`, `5`, 8] 5 es mayor a 2, se intercambian.
    - [1, 4, 2, `5`, `8`] = [1, 4, 2, `5`, `8`] 5 es menor a 8, no se intercambian.
- Segunda iteración (`i`=1) ahora `j` recorre el tamaño de la lista menos i:
    - [`1`, `4`, 2, 5, 8] = [`1`, `4`, 2, 5, 8] 1 no es mayor a 4, no se intercambian.
    - [1, `4`, `2`, 5, 8] = [1, `2`, `4`, 5, 8] 4 es mayor a 2, se intercambian.
    - [1, 2, `4`, `5`, 8] = [1, 2, `4`, `5`, 8] 4 no es mayor a 5, no se intercambian.
- Tercera iteración (`i`=2) ahora `j` recorre el tamaño de la lista menos i:
    - [`1`, `2`, 4, 5, 8] = [`1`, `2`, 4, 5, 8] 1 no es mayor a 2, no se intercambian.
    - [1, `2`, `4`, 5, 8] = [1, `2`, `4`, 5, 8] 2 no es mayor a 4, no se intercambian.
- Cuarta iteración (`i`=2) ahora `j` recorre el tamaño de la lista menos i:
    - [`1`, `2`, 4, 5, 8] = [`1`, `2`, 4, 5, 8] 1 no es mayor a 2, no se intercambian.

    Ahora podemos asegurar que nuesta lista quedó ordenada [5, 1, 4, 2, 8] => [1, 2, 4, 5, 8].

    
    

    