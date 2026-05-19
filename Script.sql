create database Barbearia_do_Ze;
GO

Use Barbearia_do_Ze;
GO

create table Usuario( 
   ID_Usuario INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
   Nome VARCHAR(100) NOT NULL, 
   Telefone VARCHAR(11) NOT NULL, 
   Email VARCHAR(255) NOT NULL, 
   Tipo VARCHAR(15) NOT NULL, 
   CHECK (Tipo IN ('Admin', 'Cliente', 'Barbeiro')) 
); 

create table Servico( 
   ID_Servico INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
   Nome VARCHAR(50) NOT NULL, 
   Descricao VARCHAR(100) NOT NULL, 
   Preco DECIMAL(7,2) NOT NULL, 
   TempoEstimado TIME 
); 

create table Barbeiro( 
   ID_Barbeiro INT PRIMARY KEY NOT NULL, 
   DataAdmissao DATE NOT NULL, 
   Foto VARCHAR(255), 
   Avaliacao DECIMAL(2,1) NOT NULL, 
   CHECK (Avaliacao >= 0 AND Avaliacao <= 5), 
   constraint fk_barbeiro foreign key (ID_Barbeiro) 
   references Usuario(ID_Usuario) ON DELETE CASCADE 
); 

create table HorarioTrabalho ( 
   ID_Horario INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
   ID_Barbeiro INT, 
   DiaSemana VARCHAR(15) NOT NULL, 
   CHECK (DiaSemana IN ( 
       'Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 
       'Quinta-Feira', 'Sexta-Feira', 'Sábado', 'Domingo' 
   )), 
   HoraInicio TIME NOT NULL, 
   HoraFim TIME NOT NULL, 
   constraint fk_horario_barbeiro foreign key(ID_Barbeiro) 
   references Barbeiro(ID_Barbeiro) ON DELETE SET NULL 
); 

create table Agendamento ( 
   ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
   DataHoraInicio DATETIME NOT NULL, 
   DataHoraFim DATETIME NOT NULL, 
   Preco DECIMAL(7,2), 
   Status VARCHAR(15) NOT NULL, 
   CHECK (Status IN ('Confirmado', 'Concluido', 'Cancelado')), 
   ID_Usuario INT NOT NULL, 
   ID_Barbeiro INT, 
   ID_Servico INT NOT NULL, 
   constraint fk_agendamento_cliente foreign key(ID_Usuario) 
   references Usuario(ID_Usuario), 
   constraint fk_agendamento_barbeiro foreign key(ID_Barbeiro) 
   references Barbeiro(ID_Barbeiro) ON DELETE SET NULL, 
   constraint fk_agendamento_servico foreign key(ID_Servico) 
   references Servico(ID_Servico) 
); 

insert into Usuario(Nome, Telefone, Email, Tipo) 
values 
('Vinicius Martins Hallal', '16992006570', 'Vinicius.Hallal@gmail.com', 'Cliente'), 
('José Ferreira da Silva', '16992622983', 'José.Ferreira@gmail.com', 'Barbeiro'); 

insert into Servico(Nome, Descricao, Preco, TempoEstimado) 
values('Corte Masculino', 'Corte moderno e acabamento profissional', 40.00, '00:45:00'); 

insert into Barbeiro(ID_Barbeiro, DataAdmissao, Foto, Avaliacao) 
values(2, '2026-01-01', 'Fotos Barbeiros/José Ferreira.jpg', 5); 

insert into HorarioTrabalho(ID_Barbeiro, DiaSemana, HoraInicio, HoraFim) 
values 
(2, 'Segunda-Feira', '08:00:00', '18:00:00'), 
(2, 'Terça-Feira', '08:00:00', '18:00:00'); 

insert into Agendamento(ID_Usuario, ID_Barbeiro, ID_Servico, DataHoraInicio, DataHoraFim, Status, Preco) 
values 
(1, 2, 1, '2026-01-01 10:00:00', '2026-01-01 10:45:00', 'Concluido', 
(SELECT Preco FROM Servico WHERE ID_Servico = 1));

GO
CREATE VIEW Agendamento_Total AS
SELECT
    S.Nome          AS Servico,
    A.Preco         AS Valor,
    A.DataHoraInicio AS Inicio,
    A.DataHoraFim    AS Fim,
    U.Nome          AS Barbeiro
FROM Agendamento A
JOIN Servico S  ON A.ID_Servico  = S.ID_Servico
JOIN Barbeiro B ON A.ID_Barbeiro = B.ID_Barbeiro
JOIN Usuario U  ON B.ID_Barbeiro = U.ID_Usuario;