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
    res.status(500).json({ 
        message: 'Something went wrong!', 
        error: err.message, 
        stack: err.stack 
    });
});
app.listen(3000, () => {
    console.log('Server running on port 3000');
});