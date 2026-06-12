# Projeto-Final-BD---DSM-1---Thiago-Veronez-

1 – Cenário 


A Vrz Motors é uma concessionária que deseja modernizar sua gestão por meio de um sistema de banco de dados estruturado, capaz de controlar vendas de veículos, cadastro de clientes, funcionários e seguros contratados.

Clientes são cadastrados com seus dados pessoais, endereço completo (atributo composto, contendo rua, número e CEP) e telefone de contato (atributo multivalorado, permitindo múltiplos números por cliente). Um cliente pode realizar diversas compras ao longo do tempo.

Veículos disponíveis para venda são registrados com informações detalhadas: chassi (identificador único), cor, modelo, marca, ano de fabricação e quilometragem. Cada veículo pode estar associado a nenhum ou vários seguros.

Vendas são identificadas por um ID único e registram a data de realização e o valor total da transação. Cada venda está vinculada a um único veículo e a um único vendedor responsável.

Vendedores são cadastrados com CPF, nome, cargo, telefone, e-mail, data de contratação e tempo de contrato (atributo derivado, calculado a partir da data de contratação). Cada vendedor pode realizar diversas vendas, porém cada venda pertence a um único vendedor. Um vendedor pode atender vários clientes ao longo do tempo, assim como um cliente pode ser atendido por diferentes vendedores — caracterizando um relacionamento de muitos para muitos (N:N) entre clientes e vendedores.

Seguros são registrados com ID, tipo de cobertura, valor e data de validade. Cada seguro está vinculado a um veículo específico.


2 – Modelagem Conceitual 


<img width="853" height="676" alt="image" src="https://github.com/user-attachments/assets/f74e8fd5-c88f-4a45-9c09-fdee09380350" />


3 – Modelagem Lógica 


<img width="1299" height="853" alt="image" src="https://github.com/user-attachments/assets/9a7e6764-b8ee-4fbd-8a83-0769944d7218" />


4 - Modelagem Física



```sql
CREATE SCHEMA consecionaria;

SET search_path TO consecionaria;

-- Clientes
CREATE TABLE consecionaria.clientes (
  cpf_clientes  CHAR(14)      NOT NULL PRIMARY KEY,
  nome_cliente  CHAR(100)     NOT NULL,
  cep           CHAR(9),
  rua           VARCHAR(100),
  numero_casa   INT
);

-- Vendedor
CREATE TABLE consecionaria.vendedor (
  cpf_vendedor      CHAR(14)      NOT NULL PRIMARY KEY,
  nome_vendedor     VARCHAR(100)  NOT NULL,
  email             VARCHAR(100)  NOT NULL,
  cargo             VARCHAR(100)  NOT NULL,
  data_contratacao  DATE
);

-- Relacionamento N:N Cliente <-> Vendedor
CREATE TABLE consecionaria.clientes_vendedor (
  cpf_clientes  CHAR(14)  NOT NULL REFERENCES consecionaria.clientes(cpf_clientes),
  cpf_vendedor  CHAR(14)  NOT NULL REFERENCES consecionaria.vendedor(cpf_vendedor)
);

-- Telefones do Cliente (multivalorado)
CREATE TABLE consecionaria.telefone_cliente (
  id_telefone_clientes  SERIAL       NOT NULL PRIMARY KEY,
  numero_tel_clientes   VARCHAR(11)  NOT NULL,
  cpf_clientes          CHAR(14)     NOT NULL REFERENCES consecionaria.clientes(cpf_clientes)
);

-- Telefones do Vendedor (multivalorado)
CREATE TABLE consecionaria.telefone_vendedor (
  id_telefone_vendedor  SERIAL       NOT NULL PRIMARY KEY,
  numero_tel_vendedor   VARCHAR(11)  NOT NULL,
  cpf_vendedor          CHAR(14)     NOT NULL REFERENCES consecionaria.vendedor(cpf_vendedor)
);

-- Veículo
CREATE TABLE consecionaria.veiculo (
  chassi        VARCHAR(100)  NOT NULL PRIMARY KEY,
  ano           INT           NOT NULL,
  cor           VARCHAR(100)  NOT NULL,
  marca         VARCHAR(100)  NOT NULL,
  modelo        VARCHAR(100)  NOT NULL,
  quilometragem INT           NOT NULL
);

-- Seguro
CREATE TABLE consecionaria.seguro (
  id_seguro     SERIAL         NOT NULL PRIMARY KEY,
  valor_seguro  DECIMAL(10,2)  NOT NULL,
  validade      DATE           NOT NULL,
  tipo_seguro   VARCHAR(100)   NOT NULL,
  chassi        VARCHAR(100)   NOT NULL REFERENCES consecionaria.veiculo(chassi)
);

-- Venda
CREATE TABLE consecionaria.venda (
  id_venda      SERIAL         NOT NULL PRIMARY KEY,
  data_venda    DATE           NOT NULL,
  valor_venda   DECIMAL(12,2)  NOT NULL,
  cpf_clientes  CHAR(14)       NOT NULL REFERENCES consecionaria.clientes(cpf_clientes),
  cpf_vendedor  CHAR(14)       NOT NULL REFERENCES consecionaria.vendedor(cpf_vendedor),
  chassi        VARCHAR(100)   NOT NULL REFERENCES consecionaria.veiculo(chassi)
);
```

5 - CRUD

  5.1 - Create
```sql
insert into consecionaria.clientes (cpf_clientes, nome_cliente, cep, rua, numero_casa) values 
  ('073.481.295-17','Thiago Veronez','14404-091','Cyro Eduardo Rosa Faleiros',6767),
  ('047.846.525-34','Douglas Brito','14405-670','Rua Amapá',6908),
  ('233.822.218-45','Márcio Maestrelo','14450-080','Av. São Antônio',962);

insert into consecionaria.venda (data_venda, valor_venda, cpf_clientes, cpf_vendedor, chassi) values
  ('2026-06-11', 23000.00, '047.846.525-34', '051.357.663-54', 'GRS25V43512'),
  ('2026-06-10', 87500.00, '073.481.295-17', '052.364.676-57', 'WSY27V00000'),
  ('2026-06-09', 145000.00, '233.822.218-45', '053.371.689-60', 'WJK28V73248');
```

<img width="1919" height="947" alt="image" src="https://github.com/user-attachments/assets/a0fc1e32-e042-46f1-8c69-87b33905a6e4" />


  5.2 - Read

  
``` sql
select * from consecionaria.venda
where valor_venda between 50000 and 120000;
```

<img width="1919" height="953" alt="image" src="https://github.com/user-attachments/assets/29431a19-132b-4edd-a102-cf6695f4f4a6" />

```sql
select * from consecionaria.seguro 
where tipo_seguro = 'Seguro Básico';
```

<img width="1919" height="938" alt="image" src="https://github.com/user-attachments/assets/10425519-d0fb-4b49-90a4-d16c32b3b8bf" />

  5.3 - Update


```sql
update consecionaria.seguro
set tipo_seguro = 'Seguro Total',
    valor_seguro = 6500
where id_seguro = 34;
```

```sql
update consecionaria.venda
set valor_venda = 220000,
    data_venda = '2026-06-10'
where id_venda = 49;
```

<img width="1919" height="944" alt="image" src="https://github.com/user-attachments/assets/c7613f2a-7b0f-4471-abfd-73366c57dc48" />


  5.4 - Delete

```sql
DELETE FROM consecionaria.venda
WHERE cpf_clientes = '073.481.295-17';

DELETE FROM consecionaria.clientes
WHERE nome_cliente = 'Thiago Veronez';
```

<img width="1919" height="946" alt="image" src="https://github.com/user-attachments/assets/3a1781f2-44ea-478b-b331-95ad41ed49c2" />

6 - Relatórios

6.1 

```sql
SELECT v.id_venda, c.nome_cliente, vd.nome_vendedor, v.data_venda, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
JOIN consecionaria.vendedor vd ON v.cpf_vendedor = vd.cpf_vendedor
WHERE v.valor_venda > 0
ORDER BY v.data_venda DESC;
```

<img width="1919" height="943" alt="image" src="https://github.com/user-attachments/assets/82456e0c-1286-4390-9565-4750fd6f1c51" />


6.2

```sql
SELECT v.id_venda, c.nome_cliente, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
WHERE v.valor_venda > 200000
ORDER BY v.valor_venda DESC;
```

<img width="1919" height="945" alt="image" src="https://github.com/user-attachments/assets/98e2e69d-5da7-49b4-a609-c512e17622d9" />


6.3

```sql
SELECT v.id_venda, ve.marca, ve.modelo, ve.ano, ve.cor, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.veiculo ve ON v.chassi = ve.chassi
ORDER BY ve.marca;
```

<img width="1919" height="944" alt="image" src="https://github.com/user-attachments/assets/c372a899-de9f-4715-986f-4ddbe98fb480" />


6.4

```sql
SELECT c.nome_cliente, t.numero_tel_clientes
FROM consecionaria.clientes c
JOIN consecionaria.telefone_cliente t ON c.cpf_clientes = t.cpf_clientes
ORDER BY c.nome_cliente;
```

<img width="1919" height="943" alt="image" src="https://github.com/user-attachments/assets/77cfb031-2693-4b07-bb8e-2fe81ce622bb" />


6.5

```sql
SELECT s.id_seguro, s.tipo_seguro, s.valor_seguro, s.validade, ve.marca, ve.modelo
FROM consecionaria.seguro s
JOIN consecionaria.veiculo ve ON s.chassi = ve.chassi
WHERE s.validade > CURRENT_DATE
ORDER BY s.validade;
```

<img width="1919" height="940" alt="image" src="https://github.com/user-attachments/assets/8a60a410-b732-4e9f-b62d-2d402cf6288f" />


6.6

```sql
SELECT vd.nome_vendedor, vd.cargo, COUNT(v.id_venda) AS total_vendas
FROM consecionaria.vendedor vd
LEFT JOIN consecionaria.venda v ON vd.cpf_vendedor = v.cpf_vendedor
GROUP BY vd.nome_vendedor, vd.cargo
ORDER BY total_vendas DESC;
```

<img width="1919" height="948" alt="image" src="https://github.com/user-attachments/assets/fad92870-28db-4795-962a-b5caa097ed92" />



6.7

```sql
SELECT c.nome_cliente, ve.marca, ve.modelo, ve.ano, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
JOIN consecionaria.veiculo ve ON v.chassi = ve.chassi
WHERE ve.marca = 'Toyota'
ORDER BY c.nome_cliente;
```

<img width="1919" height="943" alt="image" src="https://github.com/user-attachments/assets/94399520-58dd-49cf-af91-6dfef9a0a3ac" />


6.8

```sql
SELECT v.id_venda, c.nome_cliente, vd.nome_vendedor, v.data_venda, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
JOIN consecionaria.vendedor vd ON v.cpf_vendedor = vd.cpf_vendedor
WHERE v.data_venda BETWEEN '2023-01-01' AND '2024-12-31'
ORDER BY v.data_venda;
```

<img width="1919" height="944" alt="image" src="https://github.com/user-attachments/assets/db66da1b-82f3-4c78-b5a6-680f5fb4dbd2" />


6.9

```sql
SELECT ve.marca, ve.modelo, ve.quilometragem, s.tipo_seguro, s.valor_seguro
FROM consecionaria.veiculo ve
JOIN consecionaria.seguro s ON ve.chassi = s.chassi
WHERE ve.quilometragem < 50000
ORDER BY ve.quilometragem;
```

<img width="1919" height="941" alt="image" src="https://github.com/user-attachments/assets/5369e8aa-caab-4eae-a56b-c41c4ec68c21" />


6.10

```sql
SELECT c.nome_cliente, vd.nome_vendedor, vd.cargo
FROM consecionaria.clientes_vendedor cv
JOIN consecionaria.clientes c ON cv.cpf_clientes = c.cpf_clientes
JOIN consecionaria.vendedor vd ON cv.cpf_vendedor = vd.cpf_vendedor
ORDER BY c.nome_cliente;
```

<img width="1919" height="945" alt="image" src="https://github.com/user-attachments/assets/879bf3dc-aaf5-4928-a71d-035f8a785d6a" />


