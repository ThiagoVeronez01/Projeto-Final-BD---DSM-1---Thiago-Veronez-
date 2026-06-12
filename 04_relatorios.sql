-- 1
SELECT v.id_venda, c.nome_cliente, vd.nome_vendedor, v.data_venda, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
JOIN consecionaria.vendedor vd ON v.cpf_vendedor = vd.cpf_vendedor
WHERE v.valor_venda > 0
ORDER BY v.data_venda DESC;

-- 2
SELECT v.id_venda, c.nome_cliente, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
WHERE v.valor_venda > 200000
ORDER BY v.valor_venda DESC;

-- 3
SELECT v.id_venda, ve.marca, ve.modelo, ve.ano, ve.cor, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.veiculo ve ON v.chassi = ve.chassi
ORDER BY ve.marca;

-- 4
SELECT c.nome_cliente, t.numero_tel_clientes
FROM consecionaria.clientes c
JOIN consecionaria.telefone_cliente t ON c.cpf_clientes = t.cpf_clientes
ORDER BY c.nome_cliente;

-- 5
SELECT s.id_seguro, s.tipo_seguro, s.valor_seguro, s.validade, ve.marca, ve.modelo
FROM consecionaria.seguro s
JOIN consecionaria.veiculo ve ON s.chassi = ve.chassi
WHERE s.validade > CURRENT_DATE
ORDER BY s.validade;

-- 6
SELECT vd.nome_vendedor, vd.cargo, COUNT(v.id_venda) AS total_vendas
FROM consecionaria.vendedor vd
LEFT JOIN consecionaria.venda v ON vd.cpf_vendedor = v.cpf_vendedor
GROUP BY vd.nome_vendedor, vd.cargo
ORDER BY total_vendas DESC;

-- 7
SELECT c.nome_cliente, ve.marca, ve.modelo, ve.ano, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
JOIN consecionaria.veiculo ve ON v.chassi = ve.chassi
WHERE ve.marca = 'Toyota'
ORDER BY c.nome_cliente;

-- 8
SELECT v.id_venda, c.nome_cliente, vd.nome_vendedor, v.data_venda, v.valor_venda
FROM consecionaria.venda v
JOIN consecionaria.clientes c ON v.cpf_clientes = c.cpf_clientes
JOIN consecionaria.vendedor vd ON v.cpf_vendedor = vd.cpf_vendedor
WHERE v.data_venda BETWEEN '2023-01-01' AND '2024-12-31'
ORDER BY v.data_venda;

-- 9
SELECT ve.marca, ve.modelo, ve.quilometragem, s.tipo_seguro, s.valor_seguro
FROM consecionaria.veiculo ve
JOIN consecionaria.seguro s ON ve.chassi = s.chassi
WHERE ve.quilometragem < 50000
ORDER BY ve.quilometragem;

-- 10
SELECT c.nome_cliente, vd.nome_vendedor, vd.cargo
FROM consecionaria.clientes_vendedor cv
JOIN consecionaria.clientes c ON cv.cpf_clientes = c.cpf_clientes
JOIN consecionaria.vendedor vd ON cv.cpf_vendedor = vd.cpf_vendedor
ORDER BY c.nome_cliente;