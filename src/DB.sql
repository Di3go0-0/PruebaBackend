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

INSERT INTO departments (id, name) VALUES
(1, 'Marketing'),
(2, 'Sales'),
(3, 'Human Resources'),
(4, 'IT');

INSERT INTO employees (id, name, department_id, salary) VALUES
(1, 'John Doe', 1, 50000.00),
(2, 'Jane Smith', 2, 60000.00),
(3, 'Mary Johnson', 3, 80000.00),
(4, 'James Brown', 4, 80000.00),
(5, 'Patricia Williams', 1, 50000.00),
(6, 'Robert Jones', 2, 60000.00),
(7, 'Jennifer Miller', 3, 80000.00),
(8, 'Michael Davis', 4, 80000.00);


SELECT dep.name AS "Departamento", AVG(emp.salary) AS "Salario Promedio"
FROM departments dep
JOIN employees emp ON dep.id = emp.department_id
GROUP BY dep.id
ORDER BY AVG(emp.salary) DESC;

SELECT dep.name AS "Departamento", AVG(emp.salary) AS "Salario Promedio"
FROM departments dep
JOIN employees emp ON dep.id = emp.department_id
GROUP BY dep.id
ORDER BY AVG(emp.salary) DESC
LIMIT 1;

SELECT dep.name AS "Departamento", AVG(emp.salary) AS "Salario Promedio"
FROM departments dep
JOIN employees emp ON dep.id = emp.department_id
GROUP BY dep.id
HAVING AVG(emp.salary) = (
  SELECT AVG(emp2.salary) AS "Salario Promedio"
  FROM employees emp2
  GROUP BY emp2.department_id
  ORDER BY "Salario Promedio" DESC
  LIMIT 1
)
ORDER BY "Salario Promedio" DESC;

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
