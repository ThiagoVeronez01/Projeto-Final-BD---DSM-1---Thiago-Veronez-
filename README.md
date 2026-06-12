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

5 - Inserção de 50 dados por tabela

``` sql
-- =============================================
-- CLIENTES
-- =============================================
INSERT INTO consecionaria.clientes (cpf_clientes, nome_clientes, cep, rua, numero_casa) VALUES
  ('001.007.013-03', 'Carlos Eduardo Mendes', '14406-600', 'Rua XV de Novembro', 205),
  ('002.014.026-06', 'Fernanda Lima Costa', '14409-900', 'Rua São João', 236),
  ('003.021.039-09', 'Ricardo Souza Alves', '14403-300', 'Rua São João', 779),
  ('004.028.052-12', 'Juliana Martins Pereira', '14401-100', 'Rua das Acácias', 747),
  ('005.035.065-15', 'Anderson Silva Rocha', '14406-600', 'Rua Tiradentes', 701),
  ('006.042.078-18', 'Patrícia Oliveira Santos', '14408-800', 'Av. Brasil', 961),
  ('007.049.091-21', 'Marcelo Ferreira Gomes', '14409-900', 'Av. Getúlio Vargas', 205),
  ('008.056.104-24', 'Camila Rodrigues Nunes', '14406-600', 'Av. Santos Dumont', 603),
  ('009.063.117-27', 'Felipe Carvalho Lopes', '14403-300', 'Av. Independência', 843),
  ('010.070.130-30', 'Aline Nascimento Cruz', '14406-600', 'Av. Paulista', 156),
  ('011.077.143-33', 'Bruno Teixeira Dias', '14407-700', 'Rua São João', 871),
  ('012.084.156-36', 'Renata Pinto Cardoso', '14409-900', 'Av. Independência', 85),
  ('013.091.169-39', 'Gustavo Moreira Barbosa', '14408-800', 'Av. Brasil', 481),
  ('014.098.182-42', 'Larissa Freitas Monteiro', '14405-500', 'Rua XV de Novembro', 44),
  ('015.105.195-45', 'Diego Araújo Ribeiro', '14404-400', 'Rua Tiradentes', 8),
  ('016.112.208-48', 'Vanessa Castro Vieira', '14406-600', 'Av. Paulista', 372),
  ('017.119.221-51', 'Thiago Correia Melo', '14408-800', 'Av. Brasil', 474),
  ('018.126.234-54', 'Priscila Cunha Azevedo', '14408-800', 'Av. Paulista', 621),
  ('019.133.247-57', 'Rafael Batista Moraes', '14407-700', 'Rua das Flores', 367),
  ('020.140.260-60', 'Letícia Duarte Cavalcanti', '14402-200', 'Av. Paulista', 976),
  ('021.147.273-63', 'Rodrigo Farias Neto', '14402-200', 'Av. Getúlio Vargas', 610),
  ('022.154.286-66', 'Beatriz Mendonça Torres', '14402-200', 'Rua Tiradentes', 677),
  ('023.161.299-69', 'Leandro Queiroz Macedo', '14402-200', 'Rua das Flores', 113),
  ('024.168.312-72', 'Tatiane Borges Ramos', '14400-000', 'Rua São João', 486),
  ('025.175.325-75', 'Fabio Andrade Peixoto', '14406-600', 'Av. Brasil', 960),
  ('026.182.338-78', 'Monique Tavares Rezende', '14406-600', 'Av. Brasil', 147),
  ('027.189.351-81', 'Henrique Campos Stein', '14404-400', 'Av. Santos Dumont', 6),
  ('028.196.364-84', 'Natalia Vasconcelos Brum', '14406-600', 'Av. Independência', 140),
  ('029.203.377-87', 'Vinicius Leal Sampaio', '14408-800', 'Rua XV de Novembro', 206),
  ('030.210.390-90', 'Claudia Matos Figueiredo', '14400-000', 'Av. Paulista', 454),
  ('031.217.403-93', 'Alexandre Pinheiro Braga', '14404-400', 'Rua Tiradentes', 414),
  ('032.224.416-96', 'Simone Guimarães Lacerda', '14402-200', 'Av. Independência', 964),
  ('033.231.429-00', 'Paulo Santana Vilela', '14407-700', 'Rua das Flores', 135),
  ('034.238.442-03', 'Isabela Rocha Evangelista', '14409-900', 'Rua São João', 623),
  ('035.245.455-06', 'Mauricio Barros Fontes', '14406-600', 'Av. Brasil', 99),
  ('036.252.468-09', 'Daniela Coelho Branco', '14401-100', 'Rua São João', 304),
  ('037.259.481-12', 'Sergio Nogueira Assis', '14402-200', 'Rua São João', 420),
  ('038.266.494-15', 'Luciana Moura Esteves', '14402-200', 'Av. Paulista', 902),
  ('039.273.507-18', 'Tiago Almeida Bastos', '14408-800', 'Av. Independência', 790),
  ('040.280.520-21', 'Elaine Ferraz Magalhães', '14407-700', 'Av. Paulista', 867),
  ('041.287.533-24', 'Cesar Nobre Quinto', '14404-400', 'Av. Brasil', 879),
  ('042.294.546-27', 'Adriana Siqueira Prado', '14405-500', 'Rua São João', 695),
  ('043.301.559-30', 'Jonathan Reis Nascimento', '14401-100', 'Rua Tiradentes', 295),
  ('044.308.572-33', 'Cristiane Luz Furtado', '14400-000', 'Av. Santos Dumont', 853),
  ('045.315.585-36', 'Willian Soares Teles', '14400-000', 'Av. Independência', 222),
  ('046.322.598-39', 'Mariana Gama Veloso', '14406-600', 'Rua XV de Novembro', 345),
  ('047.329.611-42', 'Nelson Abreu Coutinho', '14406-600', 'Rua XV de Novembro', 425),
  ('048.336.624-45', 'Sabrina Paiva Wanderley', '14405-500', 'Rua Tiradentes', 95),
  ('049.343.637-48', 'Joao Pedro Meirelles', '14402-200', 'Rua das Flores', 946),
  ('050.350.650-51', 'Flavia Dias Cordeiro', '14405-500', 'Rua XV de Novembro', 790);

-- =============================================
-- VENDEDORES
-- =============================================
INSERT INTO consecionaria.vendedor (cpf_vendedor, nome_vendedor, email, cargo, data_contratacao) VALUES
  ('051.357.663-54', 'Roberto Alves Junior', 'roberto.alves@concessionaria.com.br', 'Gerente de Vendas', '2017-07-31'),
  ('052.364.676-57', 'Marcia Teles Souza', 'marcia.teles@concessionaria.com.br', 'Consultor de Vendas', '2022-05-04'),
  ('053.371.689-60', 'Fabiano Costa Ramos', 'fabiano.costa@concessionaria.com.br', 'Vendedor Sênior', '2022-04-30'),
  ('054.378.702-63', 'Silvana Lopes Meira', 'silvana.lopes@concessionaria.com.br', 'Consultor de Vendas', '2016-03-09'),
  ('055.385.715-66', 'Edson Carvalho Neto', 'edson.carvalho@concessionaria.com.br', 'Consultor de Vendas', '2017-06-14'),
  ('056.392.728-69', 'Patricia Ferreira Braga', 'patricia.ferreira@concessionaria.com.br', 'Vendedor Sênior', '2019-04-21'),
  ('057.399.741-72', 'Leonardo Monteiro Cruz', 'leonardo.monteiro@concessionaria.com.br', 'Consultor de Vendas', '2019-11-30'),
  ('058.406.754-75', 'Claudia Vieira Pinto', 'claudia.vieira@concessionaria.com.br', 'Vendedor', '2019-11-29'),
  ('059.413.767-78', 'Marcos Andrade Filho', 'marcos.andrade@concessionaria.com.br', 'Gerente de Vendas', '2017-11-15'),
  ('060.420.780-81', 'Renata Borges Senna', 'renata.borges@concessionaria.com.br', 'Vendedor', '2020-08-22'),
  ('061.427.793-84', 'Alexandre Gomes Teixeira', 'alexandre.gomes@concessionaria.com.br', 'Consultor de Vendas', '2022-09-05'),
  ('062.434.806-87', 'Fernanda Rocha Dias', 'fernanda.rocha@concessionaria.com.br', 'Consultor de Vendas', '2020-05-08'),
  ('063.441.819-90', 'Sergio Cunha Pires', 'sergio.cunha@concessionaria.com.br', 'Supervisor', '2016-06-05'),
  ('064.448.832-93', 'Juliana Melo Campos', 'juliana.melo@concessionaria.com.br', 'Consultor de Vendas', '2019-11-01'),
  ('065.455.845-96', 'Wagner Nascimento Luz', 'wagner.nascimento@concessionaria.com.br', 'Consultor de Vendas', '2019-08-04'),
  ('066.462.858-00', 'Adriana Sousa Albuquerque', 'adriana.sousa@concessionaria.com.br', 'Supervisor', '2016-10-14'),
  ('067.469.871-03', 'Felipe Barros Matos', 'felipe.barros@concessionaria.com.br', 'Consultor de Vendas', '2019-04-02'),
  ('068.476.884-06', 'Simone Carvalho Braga', 'simone.carvalho@concessionaria.com.br', 'Supervisor', '2021-12-09'),
  ('069.483.897-09', 'Henrique Lima Esteves', 'henrique.lima@concessionaria.com.br', 'Gerente de Vendas', '2017-03-07'),
  ('070.490.910-12', 'Monica Freitas Cavalcante', 'monica.freitas@concessionaria.com.br', 'Gerente de Vendas', '2018-10-11'),
  ('071.497.923-15', 'Carlos Peixoto Sena', 'carlos.peixoto@concessionaria.com.br', 'Vendedor Sênior', '2018-11-15'),
  ('072.504.936-18', 'Tatiana Ribeiro Fontes', 'tatiana.ribeiro@concessionaria.com.br', 'Vendedor', '2022-06-25'),
  ('073.511.949-21', 'Diego Moreira Vilela', 'diego.moreira@concessionaria.com.br', 'Consultor de Vendas', '2022-10-15'),
  ('074.518.962-24', 'Priscila Santos Novaes', 'priscila.santos@concessionaria.com.br', 'Consultor de Vendas', '2017-03-02'),
  ('075.525.975-27', 'Bruno Azevedo Maciel', 'bruno.azevedo@concessionaria.com.br', 'Vendedor Sênior', '2022-03-06'),
  ('076.532.988-30', 'Larissa Cunha Figueira', 'larissa.cunha@concessionaria.com.br', 'Consultor de Vendas', '2022-05-15'),
  ('077.539.002-33', 'Rodrigo Teixeira Brito', 'rodrigo.teixeira@concessionaria.com.br', 'Gerente de Vendas', '2022-12-02'),
  ('078.546.015-36', 'Vanessa Martins Farias', 'vanessa.martins@concessionaria.com.br', 'Vendedor Sênior', '2019-07-31'),
  ('079.553.028-39', 'Gustavo Pereira Lacerda', 'gustavo.pereira@concessionaria.com.br', 'Consultor de Vendas', '2022-05-13'),
  ('080.560.041-42', 'Daniela Queiroz Braga', 'daniela.queiroz@concessionaria.com.br', 'Gerente de Vendas', '2015-01-15'),
  ('081.567.054-45', 'Anderson Melo Duarte', 'anderson.melo@concessionaria.com.br', 'Vendedor', '2020-08-16'),
  ('082.574.067-48', 'Camila Borges Nunes', 'camila.borges@concessionaria.com.br', 'Supervisor', '2017-04-09'),
  ('083.581.080-51', 'Thiago Ramos Estrada', 'thiago.ramos@concessionaria.com.br', 'Vendedor', '2020-11-08'),
  ('084.588.093-54', 'Beatriz Nogueira Pinto', 'beatriz.nogueira@concessionaria.com.br', 'Consultor de Vendas', '2022-07-16'),
  ('085.595.106-57', 'Leandro Fontes Cavalcanti', 'leandro.fontes@concessionaria.com.br', 'Vendedor Sênior', '2020-09-24'),
  ('086.602.119-60', 'Natalia Cruz Monteiro', 'natalia.cruz@concessionaria.com.br', 'Gerente de Vendas', '2017-04-20'),
  ('087.609.132-63', 'Paulo Batista Moraes', 'paulo.batista@concessionaria.com.br', 'Consultor de Vendas', '2019-09-04'),
  ('088.616.145-66', 'Isabela Santana Barros', 'isabela.santana@concessionaria.com.br', 'Gerente de Vendas', '2021-04-14'),
  ('089.623.158-69', 'Vinicius Coelho Rezende', 'vinicius.coelho@concessionaria.com.br', 'Supervisor', '2022-01-08'),
  ('090.630.171-72', 'Elaine Pinheiro Tavares', 'elaine.pinheiro@concessionaria.com.br', 'Supervisor', '2022-01-31'),
  ('091.637.184-75', 'Mauricio Gama Branco', 'mauricio.gama@concessionaria.com.br', 'Supervisor', '2018-03-23'),
  ('092.644.197-78', 'Aline Ferraz Campos', 'aline.ferraz@concessionaria.com.br', 'Vendedor Sênior', '2015-03-26'),
  ('093.651.210-81', 'Joao Nobre Medeiros', 'joao.nobre@concessionaria.com.br', 'Vendedor', '2018-06-13'),
  ('094.658.223-84', 'Cristiane Meirelles Luz', 'cristiane.meirelles@concessionaria.com.br', 'Vendedor', '2021-07-05'),
  ('095.665.236-87', 'Willian Siqueira Assis', 'willian.siqueira@concessionaria.com.br', 'Vendedor', '2015-08-27'),
  ('096.672.249-90', 'Mariana Abreu Furtado', 'mariana.abreu@concessionaria.com.br', 'Gerente de Vendas', '2018-05-12'),
  ('097.679.262-93', 'Nelson Soares Wanderley', 'nelson.soares@concessionaria.com.br', 'Consultor de Vendas', '2021-04-01'),
  ('098.686.275-96', 'Sabrina Leal Paiva', 'sabrina.leal@concessionaria.com.br', 'Supervisor', '2021-06-12'),
  ('099.693.288-00', 'Jonathan Almeida Bastos', 'jonathan.almeida@concessionaria.com.br', 'Consultor de Vendas', '2017-03-05'),
  ('100.700.301-03', 'Flavia Reis Coutinho', 'flavia.reis@concessionaria.com.br', 'Vendedor', '2019-06-05');

-- =============================================
-- CLIENTES_VENDEDOR
-- =============================================
INSERT INTO consecionaria.clientes_vendedor (cpf_clientes, cpf_vendedor) VALUES
  ('026.182.338-78', '062.434.806-87'),
  ('017.119.221-51', '080.560.041-42'),
  ('022.154.286-66', '059.413.767-78'),
  ('009.063.117-27', '079.553.028-39'),
  ('045.315.585-36', '095.665.236-87'),
  ('025.175.325-75', '077.539.002-33'),
  ('036.252.468-09', '096.672.249-90'),
  ('012.084.156-36', '074.518.962-24'),
  ('017.119.221-51', '064.448.832-93'),
  ('018.126.234-54', '080.560.041-42'),
  ('037.259.481-12', '095.665.236-87'),
  ('025.175.325-75', '062.434.806-87'),
  ('031.217.403-93', '087.609.132-63'),
  ('041.287.533-24', '081.567.054-45'),
  ('043.301.559-30', '061.427.793-84'),
  ('005.035.065-15', '085.595.106-57'),
  ('016.112.208-48', '080.560.041-42'),
  ('034.238.442-03', '051.357.663-54'),
  ('008.056.104-24', '072.504.936-18'),
  ('032.224.416-96', '055.385.715-66'),
  ('022.154.286-66', '092.644.197-78'),
  ('047.329.611-42', '051.357.663-54'),
  ('037.259.481-12', '094.658.223-84'),
  ('035.245.455-06', '068.476.884-06'),
  ('041.287.533-24', '051.357.663-54'),
  ('038.266.494-15', '071.497.923-15'),
  ('027.189.351-81', '067.469.871-03'),
  ('011.077.143-33', '059.413.767-78'),
  ('038.266.494-15', '054.378.702-63'),
  ('026.182.338-78', '053.371.689-60'),
  ('004.028.052-12', '072.504.936-18'),
  ('033.231.429-00', '065.455.845-96'),
  ('036.252.468-09', '099.693.288-00'),
  ('019.133.247-57', '061.427.793-84'),
  ('029.203.377-87', '054.378.702-63'),
  ('045.315.585-36', '100.700.301-03'),
  ('027.189.351-81', '065.455.845-96'),
  ('013.091.169-39', '058.406.754-75'),
  ('032.224.416-96', '061.427.793-84'),
  ('018.126.234-54', '068.476.884-06'),
  ('043.301.559-30', '074.518.962-24'),
  ('005.035.065-15', '086.602.119-60'),
  ('013.091.169-39', '100.700.301-03'),
  ('036.252.468-09', '062.434.806-87'),
  ('045.315.585-36', '073.511.949-21'),
  ('042.294.546-27', '085.595.106-57'),
  ('006.042.078-18', '098.686.275-96'),
  ('044.308.572-33', '058.406.754-75'),
  ('047.329.611-42', '059.413.767-78'),
  ('009.063.117-27', '060.420.780-81'),
  ('035.245.455-06', '056.392.728-69'),
  ('003.021.039-09', '099.693.288-00'),
  ('033.231.429-00', '092.644.197-78'),
  ('025.175.325-75', '061.427.793-84'),
  ('023.161.299-69', '096.672.249-90');

-- =============================================
-- TELEFONE_CLIENTE
-- =============================================
INSERT INTO consecionaria.telefone_cliente (numero_tel_clientes, cpf_clientes) VALUES
  ('91991639941', '015.105.195-45'),
  ('91931623655', '049.343.637-48'),
  ('16955956438', '022.154.286-66'),
  ('61935231620', '041.287.533-24'),
  ('21924916401', '020.140.260-60'),
  ('71996288684', '010.070.130-30'),
  ('16941016953', '034.238.442-03'),
  ('11941588692', '025.175.325-75'),
  ('71990860167', '037.259.481-12'),
  ('21932343594', '006.042.078-18'),
  ('71960078777', '050.350.650-51'),
  ('51989094048', '017.119.221-51'),
  ('91963220892', '003.021.039-09'),
  ('41931317528', '002.014.026-06'),
  ('16948338517', '009.063.117-27'),
  ('41948936873', '036.252.468-09'),
  ('71967377600', '008.056.104-24'),
  ('16957478453', '005.035.065-15'),
  ('91952590764', '011.077.143-33'),
  ('51914639479', '022.154.286-66'),
  ('41991909407', '025.175.325-75'),
  ('81930232949', '015.105.195-45'),
  ('16948758633', '045.315.585-36'),
  ('61966250668', '048.336.624-45'),
  ('31933374636', '033.231.429-00'),
  ('61917324603', '034.238.442-03'),
  ('31996947051', '014.098.182-42'),
  ('21986125793', '017.119.221-51'),
  ('61910579676', '007.049.091-21'),
  ('16937116828', '037.259.481-12'),
  ('21994457907', '009.063.117-27'),
  ('16944171683', '020.140.260-60'),
  ('91967798024', '012.084.156-36'),
  ('16996378661', '010.070.130-30'),
  ('81963126796', '003.021.039-09'),
  ('11932231316', '029.203.377-87'),
  ('31955810956', '038.266.494-15'),
  ('21974179131', '028.196.364-84'),
  ('11959603516', '040.280.520-21'),
  ('21941221843', '033.231.429-00'),
  ('91975047290', '047.329.611-42'),
  ('11968564113', '014.098.182-42'),
  ('31933297273', '040.280.520-21'),
  ('71943342362', '009.063.117-27'),
  ('41932527491', '012.084.156-36'),
  ('81977713010', '042.294.546-27'),
  ('11941506270', '035.245.455-06'),
  ('81940437238', '016.112.208-48'),
  ('61963073746', '044.308.572-33'),
  ('81919728408', '034.238.442-03'),
  ('41953491345', '016.112.208-48'),
  ('91954854097', '050.350.650-51'),
  ('31923024227', '032.224.416-96'),
  ('16915132483', '041.287.533-24'),
  ('16952304230', '028.196.364-84');

-- =============================================
-- TELEFONE_VENDEDOR
-- =============================================
INSERT INTO consecionaria.telefone_vendedor (numero_tel_vendedor, cpf_vendedor) VALUES
  ('16998991832', '063.441.819-90'),
  ('21946000754', '069.483.897-09'),
  ('41911360484', '093.651.210-81'),
  ('81949638838', '087.609.132-63'),
  ('51925311048', '063.441.819-90'),
  ('51962242669', '061.427.793-84'),
  ('41981250312', '060.420.780-81'),
  ('31970719277', '067.469.871-03'),
  ('16957640491', '054.378.702-63'),
  ('21991640165', '065.455.845-96'),
  ('61912423902', '056.392.728-69'),
  ('51960367393', '073.511.949-21'),
  ('81930594273', '066.462.858-00'),
  ('11912890576', '100.700.301-03'),
  ('21938437758', '052.364.676-57'),
  ('51993313054', '065.455.845-96'),
  ('11996571817', '067.469.871-03'),
  ('61925295965', '051.357.663-54'),
  ('61920866903', '093.651.210-81'),
  ('51976728926', '095.665.236-87'),
  ('81960445205', '078.546.015-36'),
  ('81996519596', '100.700.301-03'),
  ('51956287978', '067.469.871-03'),
  ('41981292275', '058.406.754-75'),
  ('11914460129', '066.462.858-00'),
  ('41953763398', '065.455.845-96'),
  ('11946370475', '090.630.171-72'),
  ('91993868172', '070.490.910-12'),
  ('31969359791', '066.462.858-00'),
  ('71980061743', '093.651.210-81'),
  ('91945154818', '052.364.676-57'),
  ('61926367825', '055.385.715-66'),
  ('16947889457', '098.686.275-96'),
  ('71967152465', '082.574.067-48'),
  ('51978404557', '099.693.288-00'),
  ('91981750808', '066.462.858-00'),
  ('41963469147', '057.399.741-72'),
  ('31919143087', '100.700.301-03'),
  ('41970904100', '088.616.145-66'),
  ('71955431317', '098.686.275-96'),
  ('11912662540', '089.623.158-69'),
  ('91921222515', '054.378.702-63'),
  ('21965031946', '091.637.184-75'),
  ('61998987650', '063.441.819-90'),
  ('91987676386', '093.651.210-81'),
  ('16926289132', '052.364.676-57'),
  ('31937337156', '071.497.923-15'),
  ('11911707258', '093.651.210-81'),
  ('41934582938', '078.546.015-36'),
  ('41933788422', '059.413.767-78'),
  ('61924050363', '096.672.249-90'),
  ('21966188606', '070.490.910-12'),
  ('11920427087', '075.525.975-27'),
  ('81950787288', '068.476.884-06'),
  ('21946792649', '067.469.871-03');

-- =============================================
-- VEICULOS
-- =============================================
INSERT INTO consecionaria.veiculo (chassi, ano, cor, marca, modelo, quilometragem) VALUES
  ('TAP01V73248', 2016, 'Azul', 'Jeep', 'Wrangler', 33667),
  ('XPF02V56487', 2023, 'Azul', 'Jeep', 'Commander', 131099),
  ('FEG03V30636', 2018, 'Cinza', 'BMW', 'X1', 131725),
  ('FJM04V13875', 2018, 'Dourado', 'Fiat', 'Argo', 87),
  ('HVK05V86124', 2016, 'Preto', 'Fiat', 'Uno', 111609),
  ('LBE06V60363', 2016, 'Vermelho', 'Volkswagen', 'Polo', 30023),
  ('DFH07V43512', 2023, 'Vermelho', 'Honda', 'Civic', 84839),
  ('AWG08V26751', 2020, 'Dourado', 'Toyota', 'Yaris', 65564),
  ('MRF09V00000', 2017, 'Preto', 'Hyundai', 'Creta', 54709),
  ('VRP10V73248', 2022, 'Prata', 'Mercedes-Benz', 'A200', 146114),
  ('EMV11V56487', 2019, 'Preto', 'Toyota', 'RAV4', 40060),
  ('CBN12V30636', 2023, 'Azul', 'Hyundai', 'Creta', 145114),
  ('HYS13V13875', 2023, 'Azul', 'Toyota', 'RAV4', 111053),
  ('EDE14V86124', 2016, 'Bege', 'Fiat', 'Pulse', 142635),
  ('NJR15V60363', 2021, 'Azul', 'Honda', 'HR-V', 92206),
  ('DGC16V43512', 2015, 'Cinza', 'Fiat', 'Toro', 62100),
  ('PPZ17V26751', 2019, 'Verde', 'Ford', 'EcoSport', 33985),
  ('GTV18V00000', 2015, 'Dourado', 'BMW', 'X3', 37333),
  ('FNC19V73248', 2019, 'Verde', 'Fiat', 'Uno', 90602),
  ('AML20V56487', 2016, 'Bege', 'Volkswagen', 'Polo', 133029),
  ('ZCV21V30636', 2016, 'Cinza', 'BMW', 'X1', 93134),
  ('UNA22V13875', 2015, 'Vermelho', 'Toyota', 'Yaris', 53092),
  ('RUM23V86124', 2015, 'Vermelho', 'Toyota', 'Hilux', 40806),
  ('ZKX24V60363', 2023, 'Bege', 'Volkswagen', 'Gol', 8551),
  ('GRS25V43512', 2024, 'Verde', 'Hyundai', 'i30', 35699),
  ('GJX26V26751', 2015, 'Cinza', 'Mercedes-Benz', 'A200', 140580),
  ('WSY27V00000', 2019, 'Prata', 'BMW', 'X3', 125464),
  ('WJK28V73248', 2019, 'Laranja', 'Volkswagen', 'Virtus', 29),
  ('NUA29V56487', 2019, 'Vermelho', 'Ford', 'Ka', 41791),
  ('NFF30V30636', 2021, 'Cinza', 'Fiat', 'Argo', 69504),
  ('JDD31V13875', 2022, 'Bege', 'Volkswagen', 'Virtus', 83497),
  ('TEP32V86124', 2024, 'Preto', 'BMW', '530i', 145421),
  ('SDZ33V60363', 2018, 'Dourado', 'Honda', 'Fit', 86556),
  ('UNH34V43512', 2018, 'Branco', 'Honda', 'HR-V', 64845),
  ('VJZ35V26751', 2021, 'Vermelho', 'Hyundai', 'HB20', 48378),
  ('BBR36V00000', 2021, 'Vermelho', 'Volkswagen', 'Virtus', 88928),
  ('MYS37V73248', 2021, 'Laranja', 'Fiat', 'Toro', 72616),
  ('TDY38V56487', 2022, 'Laranja', 'Hyundai', 'Creta', 126741),
  ('ZLL39V30636', 2023, 'Bege', 'Mercedes-Benz', 'A200', 140444),
  ('LLC40V13875', 2015, 'Bege', 'Chevrolet', 'Onix', 90556),
  ('MJX41V86124', 2020, 'Preto', 'Chevrolet', 'Cruze', 31911),
  ('YNY42V60363', 2015, 'Branco', 'Ford', 'EcoSport', 35084),
  ('YUF43V43512', 2020, 'Preto', 'Toyota', 'Hilux', 10217),
  ('EYZ44V26751', 2018, 'Dourado', 'Toyota', 'Hilux', 120921),
  ('GJJ45V00000', 2020, 'Vermelho', 'Volkswagen', 'Gol', 118452),
  ('CPA46V73248', 2018, 'Verde', 'Volkswagen', 'T-Cross', 89167),
  ('ESH47V56487', 2019, 'Bege', 'Jeep', 'Renegade', 123083),
  ('ANC48V30636', 2016, 'Preto', 'Fiat', 'Toro', 926),
  ('EJP49V13875', 2019, 'Cinza', 'Volkswagen', 'Virtus', 43861),
  ('PFH50V86124', 2023, 'Branco', 'Honda', 'Fit', 18890),
  ('VSC51V60363', 2021, 'Cinza', 'Chevrolet', 'Cruze', 14080),
  ('WNV52V43512', 2021, 'Prata', 'Toyota', 'RAV4', 82413),
  ('EGT53V26751', 2017, 'Prata', 'Mercedes-Benz', 'C180', 16200),
  ('DHJ54V00000', 2017, 'Preto', 'Ford', 'Ranger', 92782),
  ('PFY55V73248', 2015, 'Vermelho', 'Volkswagen', 'Virtus', 29623);

-- =============================================
-- SEGURO
-- =============================================
INSERT INTO consecionaria.seguro (valor_seguro, validade, tipo_seguro, chassi) VALUES
  (6739.05, '2024-06-20', 'Seguro Família', 'TAP01V73248'),
  (2066.98, '2025-01-29', 'Seguro Básico', 'XPF02V56487'),
  (4325.3, '2026-01-06', 'Seguro Terceiros', 'FEG03V30636'),
  (7973.9, '2025-04-21', 'Seguro Terceiros', 'FJM04V13875'),
  (7493.93, '2026-11-09', 'Seguro Premium', 'HVK05V86124'),
  (2821.67, '2025-02-06', 'Seguro Premium', 'LBE06V60363'),
  (7580.05, '2025-07-30', 'Seguro Família', 'DFH07V43512'),
  (1069.43, '2025-03-23', 'Seguro Básico', 'AWG08V26751'),
  (7795.4, '2025-02-24', 'Seguro Total', 'MRF09V00000'),
  (4786.68, '2024-03-19', 'Seguro Terceiros', 'VRP10V73248'),
  (1025.43, '2025-02-09', 'Seguro Básico', 'EMV11V56487'),
  (7004.77, '2026-06-14', 'Seguro Total', 'CBN12V30636'),
  (1308.91, '2024-12-13', 'Seguro Total', 'HYS13V13875'),
  (2591.5, '2024-09-09', 'Seguro Total', 'EDE14V86124'),
  (1295.8, '2024-02-08', 'Seguro Básico', 'NJR15V60363'),
  (6539.77, '2026-01-30', 'Seguro Básico', 'DGC16V43512'),
  (2053.69, '2026-02-28', 'Seguro Família', 'PPZ17V26751'),
  (1137.73, '2025-01-03', 'Seguro Premium', 'GTV18V00000'),
  (2210.78, '2026-08-06', 'Seguro Básico', 'FNC19V73248'),
  (7448.13, '2025-12-26', 'Seguro Terceiros', 'AML20V56487'),
  (5760.76, '2025-09-21', 'Seguro Família', 'ZCV21V30636'),
  (1107.51, '2025-03-19', 'Seguro Terceiros', 'UNA22V13875'),
  (1120.67, '2025-10-09', 'Seguro Terceiros', 'RUM23V86124'),
  (5208.03, '2024-08-14', 'Seguro Básico', 'ZKX24V60363'),
  (6991.75, '2026-05-02', 'Seguro Terceiros', 'GRS25V43512'),
  (1691.36, '2024-11-30', 'Seguro Premium', 'GJX26V26751'),
  (6584.04, '2025-01-09', 'Seguro Terceiros', 'WSY27V00000'),
  (1738.67, '2026-05-22', 'Seguro Total', 'WJK28V73248'),
  (5033.39, '2025-06-26', 'Seguro Total', 'NUA29V56487'),
  (6439.93, '2025-03-03', 'Seguro Família', 'NFF30V30636'),
  (6328.72, '2024-02-06', 'Seguro Família', 'JDD31V13875'),
  (3972.9, '2026-07-18', 'Seguro Família', 'TEP32V86124'),
  (2750.35, '2025-06-03', 'Seguro Família', 'SDZ33V60363'),
  (3977.33, '2026-08-09', 'Seguro Família', 'UNH34V43512'),
  (3278.75, '2026-09-06', 'Seguro Terceiros', 'VJZ35V26751'),
  (6508.92, '2024-08-10', 'Seguro Terceiros', 'BBR36V00000'),
  (1292.08, '2024-05-22', 'Seguro Terceiros', 'MYS37V73248'),
  (5136.41, '2026-12-17', 'Seguro Terceiros', 'TDY38V56487'),
  (4568.79, '2026-05-08', 'Seguro Básico', 'ZLL39V30636'),
  (6553.02, '2025-07-31', 'Seguro Premium', 'LLC40V13875'),
  (2137.67, '2026-01-09', 'Seguro Família', 'MJX41V86124'),
  (1176.21, '2025-02-09', 'Seguro Família', 'YNY42V60363'),
  (6176.19, '2026-01-09', 'Seguro Terceiros', 'YUF43V43512'),
  (7634.57, '2026-09-14', 'Seguro Básico', 'EYZ44V26751'),
  (4895.19, '2026-08-06', 'Seguro Terceiros', 'GJJ45V00000'),
  (3272.27, '2025-05-11', 'Seguro Terceiros', 'CPA46V73248'),
  (5610.0, '2025-07-23', 'Seguro Terceiros', 'ESH47V56487'),
  (5200.41, '2024-07-27', 'Seguro Premium', 'ANC48V30636'),
  (5827.28, '2024-09-13', 'Seguro Premium', 'EJP49V13875'),
  (2803.19, '2025-06-10', 'Seguro Premium', 'PFH50V86124');

-- =============================================
-- VENDA
-- =============================================
INSERT INTO consecionaria.venda (data_venda, valor_venda, cpf_clientes, cpf_vendedor, chassi) VALUES
  ('2024-11-03', 317933.4, '014.098.182-42', '090.630.171-72', 'AML20V56487'),
  ('2024-03-18', 39353.26, '030.210.390-90', '068.476.884-06', 'XPF02V56487'),
  ('2024-10-07', 146658.96, '050.350.650-51', '075.525.975-27', 'EJP49V13875'),
  ('2020-09-18', 228982.57, '018.126.234-54', '086.602.119-60', 'LBE06V60363'),
  ('2020-10-11', 154520.8, '033.231.429-00', '087.609.132-63', 'ZLL39V30636'),
  ('2021-01-07', 201872.0, '013.091.169-39', '060.420.780-81', 'EGT53V26751'),
  ('2020-02-19', 284084.4, '007.049.091-21', '081.567.054-45', 'DFH07V43512'),
  ('2023-05-26', 311520.05, '020.140.260-60', '093.651.210-81', 'SDZ33V60363'),
  ('2022-03-28', 278587.71, '034.238.442-03', '098.686.275-96', 'TEP32V86124'),
  ('2020-01-07', 225963.46, '030.210.390-90', '088.616.145-66', 'TDY38V56487'),
  ('2023-05-06', 147982.18, '023.161.299-69', '071.497.923-15', 'DFH07V43512'),
  ('2023-11-13', 246776.93, '042.294.546-27', '058.406.754-75', 'VSC51V60363'),
  ('2020-11-26', 268907.84, '046.322.598-39', '069.483.897-09', 'MYS37V73248'),
  ('2021-03-03', 285127.54, '037.259.481-12', '081.567.054-45', 'VSC51V60363'),
  ('2020-03-31', 128882.79, '025.175.325-75', '093.651.210-81', 'NFF30V30636'),
  ('2024-09-13', 111710.39, '047.329.611-42', '054.378.702-63', 'CBN12V30636'),
  ('2021-02-26', 218720.54, '006.042.078-18', '075.525.975-27', 'CBN12V30636'),
  ('2022-12-27', 169824.47, '040.280.520-21', '060.420.780-81', 'EDE14V86124'),
  ('2023-03-11', 166787.03, '020.140.260-60', '057.399.741-72', 'LBE06V60363'),
  ('2024-12-27', 51920.39, '022.154.286-66', '082.574.067-48', 'VRP10V73248'),
  ('2021-04-20', 294713.92, '005.035.065-15', '055.385.715-66', 'GJX26V26751'),
  ('2021-05-20', 194028.23, '031.217.403-93', '063.441.819-90', 'BBR36V00000'),
  ('2024-06-13', 264112.68, '038.266.494-15', '078.546.015-36', 'TDY38V56487'),
  ('2023-05-22', 134370.85, '011.077.143-33', '079.553.028-39', 'MRF09V00000'),
  ('2024-03-02', 103816.81, '027.189.351-81', '080.560.041-42', 'JDD31V13875'),
  ('2021-06-01', 312305.54, '045.315.585-36', '075.525.975-27', 'RUM23V86124'),
  ('2020-06-03', 228670.73, '003.021.039-09', '064.448.832-93', 'TEP32V86124'),
  ('2022-11-30', 246951.9, '002.014.026-06', '079.553.028-39', 'EYZ44V26751'),
  ('2024-12-01', 166562.68, '004.028.052-12', '094.658.223-84', 'EDE14V86124'),
  ('2020-07-10', 171329.22, '041.287.533-24', '077.539.002-33', 'JDD31V13875'),
  ('2020-02-07', 90014.79, '005.035.065-15', '066.462.858-00', 'VJZ35V26751'),
  ('2023-08-20', 154288.46, '009.063.117-27', '092.644.197-78', 'NJR15V60363'),
  ('2021-10-03', 152534.61, '048.336.624-45', '093.651.210-81', 'RUM23V86124'),
  ('2023-11-28', 50338.02, '050.350.650-51', '087.609.132-63', 'MJX41V86124'),
  ('2022-09-08', 40214.47, '013.091.169-39', '077.539.002-33', 'BBR36V00000'),
  ('2022-04-07', 319942.71, '048.336.624-45', '059.413.767-78', 'TAP01V73248'),
  ('2021-10-07', 201742.3, '013.091.169-39', '068.476.884-06', 'ZKX24V60363'),
  ('2020-09-07', 108905.76, '019.133.247-57', '080.560.041-42', 'ZKX24V60363'),
  ('2023-07-02', 282131.25, '044.308.572-33', '098.686.275-96', 'EMV11V56487'),
  ('2020-02-27', 53603.88, '038.266.494-15', '083.581.080-51', 'FEG03V30636'),
  ('2022-12-06', 320326.03, '048.336.624-45', '071.497.923-15', 'SDZ33V60363'),
  ('2024-08-06', 122806.03, '003.021.039-09', '098.686.275-96', 'FEG03V30636'),
  ('2022-08-25', 89562.14, '019.133.247-57', '091.637.184-75', 'GRS25V43512'),
  ('2021-11-03', 41674.49, '043.301.559-30', '068.476.884-06', 'MYS37V73248'),
  ('2022-09-08', 212175.8, '038.266.494-15', '097.679.262-93', 'GJX26V26751'),
  ('2020-03-10', 94543.88, '006.042.078-18', '082.574.067-48', 'UNH34V43512'),
  ('2020-11-10', 99318.27, '046.322.598-39', '100.700.301-03', 'JDD31V13875'),
  ('2021-11-07', 67528.58, '033.231.429-00', '058.406.754-75', 'NUA29V56487'),
  ('2023-12-29', 222099.37, '048.336.624-45', '090.630.171-72', 'VRP10V73248'),
  ('2020-04-29', 270420.91, '010.070.130-30', '076.532.988-30', 'NJR15V60363'),
  ('2024-07-26', 102284.09, '047.329.611-42', '059.413.767-78', 'MJX41V86124'),
  ('2020-10-19', 36802.55, '018.126.234-54', '073.511.949-21', 'JDD31V13875'),
  ('2024-07-13', 93584.25, '029.203.377-87', '087.609.132-63', 'PFY55V73248'),
  ('2021-09-27', 60805.0, '032.224.416-96', '091.637.184-75', 'ESH47V56487'),
  ('2024-07-17', 46863.98, '024.168.312-72', '065.455.845-96', 'YNY42V60363'),
  ('2024-07-20', 70943.5, '001.007.013-03', '051.357.663-54', 'VSC51V60363'),
  ('2023-11-12', 72476.88, '033.231.429-00', '051.357.663-54', 'UNA22V13875'),
  ('2022-12-03', 169201.05, '050.350.650-51', '075.525.975-27', 'ESH47V56487'),
  ('2024-12-29', 300267.5, '015.105.195-45', '100.700.301-03', 'ESH47V56487'),
  ('2020-05-17', 140395.67, '046.322.598-39', '061.427.793-84', 'LLC40V13875');
  ```
6 - CRUD

  6.1 - Create
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


  6.2 - Read

  
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

6.3 - Update


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





