CREATE SCHEMA consecionaria;

SET search_path TO consecionaria;

CREATE TABLE consecionaria.clientes (
  cpf_clientes  CHAR(14)      NOT NULL PRIMARY KEY,
  nome_cliente  CHAR(100)     NOT NULL,
  cep           CHAR(9),
  rua           VARCHAR(100),
  numero_casa   INT
);

CREATE TABLE consecionaria.vendedor (
  cpf_vendedor      CHAR(14)      NOT NULL PRIMARY KEY,
  nome_vendedor     VARCHAR(100)  NOT NULL,
  email             VARCHAR(100)  NOT NULL,
  cargo             VARCHAR(100)  NOT NULL,
  data_contratacao  DATE
);

CREATE TABLE consecionaria.clientes_vendedor (
  cpf_clientes  CHAR(14)  NOT NULL REFERENCES consecionaria.clientes(cpf_clientes),
  cpf_vendedor  CHAR(14)  NOT NULL REFERENCES consecionaria.vendedor(cpf_vendedor)
);

CREATE TABLE consecionaria.telefone_cliente (
  id_telefone_clientes  SERIAL       NOT NULL PRIMARY KEY,
  numero_tel_clientes   VARCHAR(11)  NOT NULL,
  cpf_clientes          CHAR(14)     NOT NULL REFERENCES consecionaria.clientes(cpf_clientes)
);

CREATE TABLE consecionaria.telefone_vendedor (
  id_telefone_vendedor  SERIAL       NOT NULL PRIMARY KEY,
  numero_tel_vendedor   VARCHAR(11)  NOT NULL,
  cpf_vendedor          CHAR(14)     NOT NULL REFERENCES consecionaria.vendedor(cpf_vendedor)
);

CREATE TABLE consecionaria.veiculo (
  chassi        VARCHAR(100)  NOT NULL PRIMARY KEY,
  ano           INT           NOT NULL,
  cor           VARCHAR(100)  NOT NULL,
  marca         VARCHAR(100)  NOT NULL,
  modelo        VARCHAR(100)  NOT NULL,
  quilometragem INT           NOT NULL
);

CREATE TABLE consecionaria.seguro (
  id_seguro     SERIAL         NOT NULL PRIMARY KEY,
  valor_seguro  DECIMAL(10,2)  NOT NULL,
  validade      DATE           NOT NULL,
  tipo_seguro   VARCHAR(100)   NOT NULL,
  chassi        VARCHAR(100)   NOT NULL REFERENCES consecionaria.veiculo(chassi)
);

CREATE TABLE consecionaria.venda (
  id_venda      SERIAL         NOT NULL PRIMARY KEY,
  data_venda    DATE           NOT NULL,
  valor_venda   DECIMAL(12,2)  NOT NULL,
  cpf_clientes  CHAR(14)       NOT NULL REFERENCES consecionaria.clientes(cpf_clientes),
  cpf_vendedor  CHAR(14)       NOT NULL REFERENCES consecionaria.vendedor(cpf_vendedor),
  chassi        VARCHAR(100)   NOT NULL REFERENCES consecionaria.veiculo(chassi)
);