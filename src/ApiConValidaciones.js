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

