-- Banco de dados: escola_linguas_db
CREATE DATABASE IF NOT EXISTS escola_linguas_db
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_unicode_ci;
USE escola_linguas_db;

-- Professores
CREATE TABLE IF NOT EXISTS professor (
  professor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(200) NOT NULL,
  email VARCHAR(200),
  telefone VARCHAR(30)
) ENGINE=InnoDB;

-- Alunos
CREATE TABLE IF NOT EXISTS aluno (
  aluno_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(200) NOT NULL,
  email VARCHAR(200),
  telefone VARCHAR(30),
  data_matricula DATE DEFAULT CURDATE()
) ENGINE=InnoDB;

-- Cursos (ex.: Inglês Básico, Espanhol Avançado)
CREATE TABLE IF NOT EXISTS curso (
  curso_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(200) NOT NULL,
  nivel ENUM('iniciante','intermediario','avancado') DEFAULT 'iniciante',
  duracao_horas INT DEFAULT 0
) ENGINE=InnoDB;

-- Turmas / turmas do curso
CREATE TABLE IF NOT EXISTS turma (
  turma_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  curso_id BIGINT NOT NULL,
  professor_id BIGINT,
  horario VARCHAR(100),
  capacidade INT DEFAULT 20,
  ativo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (curso_id) REFERENCES curso(curso_id) ON DELETE CASCADE,
  FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Matrículas (aluno em turma)
CREATE TABLE IF NOT EXISTS matricula (
  matricula_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  aluno_id BIGINT NOT NULL,
  turma_id BIGINT NOT NULL,
  data_matricula DATE DEFAULT CURDATE(),
  status ENUM('matriculado','cancelado','concluido') DEFAULT 'matriculado',
  FOREIGN KEY (aluno_id) REFERENCES aluno(aluno_id) ON DELETE CASCADE,
  FOREIGN KEY (turma_id) REFERENCES turma(turma_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Aulas (ocorrências em uma turma)
CREATE TABLE IF NOT EXISTS aula (
  aula_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  turma_id BIGINT NOT NULL,
  data_aula DATE NOT NULL,
  topico VARCHAR(255),
  observacoes TEXT,
  FOREIGN KEY (turma_id) REFERENCES turma(turma_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Presenças (cada registro de presença por aula e aluno)
CREATE TABLE IF NOT EXISTS presenca (
  presenca_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  aula_id BIGINT NOT NULL,
  aluno_id BIGINT NOT NULL,
  presente BOOLEAN DEFAULT FALSE,
  observacao VARCHAR(255),
  FOREIGN KEY (aula_id) REFERENCES aula(aula_id) ON DELETE CASCADE,
  FOREIGN KEY (aluno_id) REFERENCES aluno(aluno_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Índices
CREATE INDEX idx_aluno_nome ON aluno(nome);
CREATE INDEX idx_professor_nome ON professor(nome);

-- Inserts de exemplo
INSERT INTO professor (nome, email, telefone) VALUES
  ('Ana Pereira', 'ana.pereira@example.com', '91111-0000'),
  ('Carlos Lima', 'carlos.lima@example.com', '92222-0000');

INSERT INTO aluno (nome, email, telefone) VALUES
  ('Lucas Silva', 'lucas@example.com', '93333-0000'),
  ('Mariana Costa', 'mariana@example.com', '94444-0000');

INSERT INTO curso (nome, nivel, duracao_horas) VALUES
  ('Inglês Básico', 'iniciante', 60),
  ('Espanhol Intermediário', 'intermediario', 45);

INSERT INTO turma (curso_id, professor_id, horario, capacidade) VALUES
  (1, 1, 'Seg/Qua/Sex 19:00-20:30', 20),
  (2, 2, 'Ter/Qui 18:00-19:30', 15);

-- Matrículas
INSERT INTO matricula (aluno_id, turma_id) VALUES
  (1, 1),
  (2, 2);

-- Aulas e presenças
INSERT INTO aula (turma_id, data_aula, topico) VALUES
  (1, DATE_ADD(CURDATE(), INTERVAL -7 DAY), 'Apresentações'),
  (1, CURDATE(), 'Presente simples');

INSERT INTO presenca (aula_id, aluno_id, presente) VALUES
  (1, 1, TRUE),
  (1, 2, FALSE);