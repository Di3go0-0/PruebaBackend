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