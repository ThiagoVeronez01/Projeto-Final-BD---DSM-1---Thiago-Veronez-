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
