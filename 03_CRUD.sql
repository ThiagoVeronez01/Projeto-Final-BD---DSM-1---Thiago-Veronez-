-- CREATE
INSERT INTO consecionaria.clientes (cpf_clientes, nome_cliente, cep, rua, numero_casa) VALUES 
  ('073.481.295-17', 'Thiago Veronez', '14404-091', 'Cyro Eduardo Rosa Faleiros', 6767),
  ('047.846.525-34', 'Douglas Brito', '14405-670', 'Rua Amapá', 6908),
  ('233.822.218-45', 'Márcio Maestrelo', '14450-080', 'Av. São Antônio', 962);

INSERT INTO consecionaria.venda (data_venda, valor_venda, cpf_clientes, cpf_vendedor, chassi) VALUES
  ('2026-06-11', 23000.00, '047.846.525-34', '051.357.663-54', 'GRS25V43512'),
  ('2026-06-10', 87500.00, '073.481.295-17', '052.364.676-57', 'WSY27V00000'),
  ('2026-06-09', 145000.00, '233.822.218-45', '053.371.689-60', 'WJK28V73248');

-- READ
SELECT * FROM consecionaria.venda
WHERE valor_venda BETWEEN 50000 AND 120000;

SELECT * FROM consecionaria.seguro
WHERE tipo_seguro = 'Seguro Básico';

-- UPDATE
UPDATE consecionaria.seguro
SET tipo_seguro = 'Seguro Total',
    valor_seguro = 6500
WHERE id_seguro = 34;

UPDATE consecionaria.venda
SET valor_venda = 220000,
    data_venda = '2026-06-10'
WHERE id_venda = 49;

-- DELETE
DELETE FROM consecionaria.venda
WHERE cpf_clientes = '073.481.295-17';

DELETE FROM consecionaria.clientes
WHERE nome_cliente = 'Thiago Veronez';