CREATE DATABASE expressimmo;

USE expressimmo;

-- Table des utilisateurs
CREATE TABLE Utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('admin', 'partenaire','employe') DEFAULT 'partenaire',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des partenaires
CREATE TABLE Partenaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telephone VARCHAR(15),
    adresse VARCHAR(255),
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

-- Ajouter un partenaire par défaut
INSERT INTO Partenaires (nom, prenom, email, telephone, adresse, created_by) 
VALUES ('Partenaire', 'Défaut', 'default@expressimmo.com', '0000000000', 'Adresse par défaut', NULL);

-- Table des propriétés
CREATE TABLE Proprietes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    partenaire_id INT NOT NULL,
    libelle VARCHAR(150) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    description TEXT,
    etat ENUM ('location','vente'),
    prix_journalier DECIMAL(10, 2) DEFAULT NULL,
    prix_mensuel DECIMAL(10, 2) DEFAULT NULL,
    disponible BOOLEAN DEFAULT TRUE,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    poster VARCHAR(255) DEFAULT 'express.jpeg',
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (partenaire_id) REFERENCES Partenaires(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

-- Table des locataires
CREATE TABLE Locataires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propriete_id INT NOT NULL,
    nomComplet VARCHAR(100) DEFAULT NULL,
    telephone VARCHAR(100) DEFAULT NULL,
    adresse VARCHAR(100) DEFAULT NULL,
    email VARCHAR(100) DEFAULT NULL,
    date_naissance DATE DEFAULT NULL,
    lieu_naissance DATE DEFAULT NULL,
    nationalite VARCHAR(100) DEFAULT NULL,
    typePiece VARCHAR(100) DEFAULT NULL,
    numeroPiece VARCHAR(100) DEFAULT NULL,
    codePin VARCHAR(255) DEFAULT '81dc9bdb52d04dc20036dbd8313ed055',
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    FOREIGN KEY (propriete_id) REFERENCES Proprietes(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

-- Table des réservations
CREATE TABLE Reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propriete_id INT NOT NULL,
    nomComplet VARCHAR(255) DEFAULT NULL,
    telephone VARCHAR(255) DEFAULT NULL,
    adresse VARCHAR(255) DEFAULT NULL,
    statut ENUM('en attente', 'confirmée', 'annulée') DEFAULT 'en attente',
    date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (propriete_id) REFERENCES Proprietes(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

-- Table des contrats
CREATE TABLE Contrats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    date_debut TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_fin TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    montant_total DECIMAL(10, 2) NOT NULL,
    statut ENUM('actif', 'terminé', 'annulé') DEFAULT 'actif',
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES Reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

-- Table des paiements
CREATE TABLE Paiements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contrat_id INT NOT NULL,
    montant DECIMAL(10, 2) NOT NULL,
    date_paiement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mode_paiement ENUM('carte bancaire', 'virement', 'espèces') NOT NULL,
    statut ENUM('réussi', 'échoué', 'en attente') DEFAULT 'en attente',
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (contrat_id) REFERENCES Contrats(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

-- Table de la caisse
CREATE TABLE Caisse (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    date_transaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    montant DECIMAL(10, 2) NOT NULL,
    type_transaction ENUM('entrée', 'sortie') NOT NULL,
    description TEXT,
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

-- Table Comptabilite
CREATE TABLE Comptabilite (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reference VARCHAR(100) UNIQUE NOT NULL,
    type_transaction ENUM('entrée', 'sortie') NOT NULL,
    montant DECIMAL(10, 2) NOT NULL,
    description TEXT DEFAULT NULL,
    date_transaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source_transaction ENUM('contrat', 'paiement', 'autre') NOT NULL,
    contrat_id INT DEFAULT NULL,
    paiement_id INT DEFAULT NULL,
    created_by INT DEFAULT NULL,
    modify_by INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (contrat_id) REFERENCES Contrats(id) ON DELETE SET NULL,
    FOREIGN KEY (paiement_id) REFERENCES Paiements(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
    FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
);

 -- creation de la table menu 
 CREATE TABLE menu (
  id INT AUTO_INCREMENT PRIMARY KEY,
  famille VARCHAR(100) DEFAULT NULL,
  libelle VARCHAR(100) DEFAULT NULL,
  url VARCHAR(100) DEFAULT NULL,
  icons VARCHAR(20) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

 -- creation de la table TypeCharge
 CREATE TABLE typecharge (
  id INT AUTO_INCREMENT PRIMARY KEY,
  libelle VARCHAR(50) NOT NULL,
  commentaire TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- creation de la table chargefrais
CREATE TABLE chargesfrais (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_propriete INT DEFAULT NULL,
  id_type_charge INT DEFAULT NULL,
  montant DECIMAL(10,2) DEFAULT NULL,
  commentaire TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (id_propriete) REFERENCES proprietes(id) ON DELETE SET NULL,
  FOREIGN KEY (id_type_charge) REFERENCES typecharge(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- creation de la table materiel
CREATE TABLE materiels (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reference VARCHAR(50) DEFAULT NULL,
  libelle VARCHAR(100) DEFAULT NULL,
  description VARCHAR(100) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- creation de la table gestion materiel

CREATE TABLE gestion_materiels (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_materiel INT DEFAULT NULL,
  operation INT DEFAULT NULL,
  qte INT DEFAULT NULL,
  commentaire VARCHAR(100) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (id_materiel) REFERENCES materiels(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Création de la table employer
CREATE TABLE employer (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nomComplet VARCHAR(70) DEFAULT NULL,
  tel VARCHAR(30) DEFAULT NULL,
  adresse VARCHAR(30) DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  motDePasse VARCHAR(255) DEFAULT NULL,
  description VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut INT DEFAULT 1,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


 
-- Création de la table operation_employer
CREATE TABLE operation_employer (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_employer INT DEFAULT NULL,
  titre VARCHAR(40) DEFAULT NULL,
  details VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (id_employer) REFERENCES employer(id) ON DELETE SET NULL,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


 -- Création de la table `paiementloyer`
-- Création de la table `paiementloyer` avec clés étrangères directement
CREATE TABLE paiementloyer (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_contrat INT DEFAULT NULL,
  id_locateur INT DEFAULT NULL,
  libelle VARCHAR(50) DEFAULT NULL,
  debut_location DATE DEFAULT NULL,
  fin_location DATE DEFAULT NULL,
  montant DECIMAL(10,2) DEFAULT NULL,
  commentaire TEXT,
  created_by INT DEFAULT NULL,
  modify_by INT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  statut TINYINT(1) NOT NULL DEFAULT 1,
  -- Définition des clés étrangères
  CONSTRAINT fk_paiementloyer_id_contrat FOREIGN KEY (id_contrat) REFERENCES Contrats(id) ON DELETE SET NULL,
  CONSTRAINT fk_paiementloyer_id_locateur FOREIGN KEY (id_locateur) REFERENCES Locataires(id) ON DELETE SET NULL,
  CONSTRAINT fk_paiementloyer_created_by FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  CONSTRAINT fk_paiementloyer_modify_by FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Création de la table `commune`
CREATE TABLE commune (
  id INT AUTO_INCREMENT PRIMARY KEY,
  libelle VARCHAR(50) DEFAULT NULL,
  description VARCHAR(100) DEFAULT NULL,
  created_by INT DEFAULT NULL,
  modify_by INT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  statut INT DEFAULT 1,
  CONSTRAINT fk_commune_created_by FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  CONSTRAINT fk_commune_modify_by FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE quartier (
  id INT AUTO_INCREMENT PRIMARY KEY,
  libelle VARCHAR(50) DEFAULT NULL,
  description VARCHAR(100) DEFAULT NULL,
  created_by INT DEFAULT NULL,
  modify_by INT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  statut INT DEFAULT 1,
  CONSTRAINT fk_quartier_created_by FOREIGN KEY (created_by) REFERENCES utilisateurs(id) ON DELETE SET NULL,
  CONSTRAINT fk_quartier_modify_by FOREIGN KEY (modify_by) REFERENCES utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ville (
  id INT AUTO_INCREMENT PRIMARY KEY,
  libelle VARCHAR(50) DEFAULT NULL,
  description VARCHAR(100) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  modify_by INT DEFAULT NULL,
  statut INT DEFAULT 1,
  CONSTRAINT fk_ville_created_by FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  CONSTRAINT fk_ville_modify_by FOREIGN KEY (modify_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE typepropriete (
  id INT NOT NULL AUTO_INCREMENT,
  libelle VARCHAR(50) DEFAULT NULL,
  icons VARCHAR(50) DEFAULT NULL,
  commentaire TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut INT DEFAULT 1,
  PRIMARY KEY (id),
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

  -- creation de la table proprietaire 
  CREATE TABLE proprietaire (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nomComplet VARCHAR(70) DEFAULT NULL,
  telephone VARCHAR(30) DEFAULT NULL,
  adresse VARCHAR(50) DEFAULT NULL,
  codePin VARCHAR(30) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut INT DEFAULT NULL,
  ville_id INT NOT NULL,
  commune_id INT NOT NULL,
  quartier_id INT NOT NULL,
  typepropriete_id INT NOT NULL,
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (ville_id) REFERENCES ville(id) ON DELETE CASCADE,
  FOREIGN KEY (commune_id) REFERENCES commune(id) ON DELETE CASCADE,
  FOREIGN KEY (quartier_id) REFERENCES quartier(id) ON DELETE CASCADE,
  FOREIGN KEY (typepropriete_id) REFERENCES typepropriete(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




INSERT INTO typepropriete (id, libelle, icons, commentaire, created_at, created_by, updated_at, updated_by, statut) VALUES
(10, 'Appartement', NULL, 'Appartement Meuble...', '2024-05-05 01:43:03', NULL, '2024-05-05 01:43:03', NULL, 1),
(11, 'Maison', NULL, 'Maison dans une cours fermée', '2024-05-05 01:43:30', NULL, '2024-05-05 01:43:30', NULL, 1),
(12, 'Bureau', NULL, 'Idéale pour Entreprise', '2024-05-06 02:27:26', NULL, '2024-05-06 02:27:26', NULL, 1),
(13, 'Automobile', NULL, 'Voiture, Engins roulant bref', '2024-05-09 23:37:36', NULL, '2024-05-09 23:37:36', NULL, 1),
(14, 'Immeuble', NULL, 'Buildings', '2024-05-12 13:03:52', NULL, '2024-05-12 13:03:52', NULL, 1),
(15, 'Villa Simple', NULL, 'Dans une cour fermée', '2024-05-12 13:04:19', NULL, '2024-05-12 13:04:19', NULL, 1);

CREATE TABLE type_operation (
  id INT NOT NULL AUTO_INCREMENT,
  libelle VARCHAR(100) NOT NULL,
  caisse_id INT NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut INT DEFAULT NULL,
  CONSTRAINT fk_type_operation_caisse FOREIGN KEY (caisse_id) REFERENCES Caisse(transaction_id) ON DELETE CASCADE,
  CONSTRAINT fk_type_operation_created_by FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  CONSTRAINT fk_type_operation_updated_by FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



 CREATE TABLE type_depense (
  id INT NOT NULL AUTO_INCREMENT,
  libelle VARCHAR(100) NOT NULL,
  chargefrais_id INT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut INT DEFAULT NULL,
  CONSTRAINT fk_type_depense_chargefrais FOREIGN KEY (chargefrais_id) REFERENCES chargesfrais(id) ON DELETE CASCADE,
  CONSTRAINT fk_type_depense_created_by FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  CONSTRAINT fk_type_depense_updated_by FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE detailpropriete (
  id INT AUTO_INCREMENT PRIMARY KEY,
  idPropriete INT DEFAULT NULL,
  detail1 VARCHAR(50) DEFAULT NULL,
  detail2 VARCHAR(50) DEFAULT NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  createdBy INT DEFAULT NULL,
  modifyAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  modifyBy INT DEFAULT NULL,
  statut INT NOT NULL DEFAULT 1,
  FOREIGN KEY (idPropriete) REFERENCES proprietes(id) ON DELETE SET NULL,
  FOREIGN KEY (createdBy) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (modifyBy) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE periodicite (
  id INT NOT NULL AUTO_INCREMENT,
  libelle VARCHAR(50) DEFAULT NULL,
  commentaire TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut INT DEFAULT NULL,
  CONSTRAINT fk_periodicite_created_by FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  CONSTRAINT fk_periodicite_updated_by FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO periodicite (id, libelle, commentaire, created_at, created_by, updated_at, updated_by, statut) VALUES
(1, 'Mensuel', 'Paiement mensuel', '2024-05-06 02:34:31', NULL, '2024-05-06 02:34:31', NULL, 1),
(2, 'Annuelle', 'Paiement par ans', '2024-05-06 02:34:31', NULL, '2024-05-06 02:34:31', NULL, 1),
(3, 'Journalier', 'Paiement journalier', '2024-05-15 10:40:28', NULL, '2024-05-15 10:40:28', NULL, 1);


CREATE TABLE documents (
  idDocs INT NOT NULL AUTO_INCREMENT,
  libelle VARCHAR(100) DEFAULT NULL,
  description TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by INT DEFAULT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by INT DEFAULT NULL,
  statut INT DEFAULT 1,
  PRIMARY KEY (idDocs),
  FOREIGN KEY (created_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL,
  FOREIGN KEY (updated_by) REFERENCES Utilisateurs(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO commune (id, libelle, description, created_at, created_by, updated_at, modify_by, statut) VALUES
(1, 'Kaloum', 'Commune de Kaloum à Conakry', '2024-05-12 19:52:18', NULL, '2024-05-12 19:52:18', NULL, 1),
(2, 'Matoto', 'Commune de Matoto à Conakry', '2024-05-12 19:52:18', NULL, '2024-05-12 19:52:18', NULL, 1),
(3, 'Ratoma', 'Commune de Ratoma à Conakry', '2024-05-12 19:52:18', NULL, '2024-05-12 19:52:18', NULL, 1),
(4, 'Dixinn', 'Commune de Dixinn à Conakry', '2024-05-12 19:52:18', NULL, '2024-05-12 19:52:18', NULL, 1),
(5, 'Matam', 'Commune de Matam à Conakry', '2024-05-12 19:52:18', NULL, '2024-05-12 19:52:18', NULL, 1);



INSERT INTO quartier (id, libelle, description, created_by, modify_by, created_at, updated_at, statut) VALUES
(1, 'Matam', 'Quartier de Matam à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(2, 'Boulbinet', 'Quartier de Boulbinet à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(3, 'Kaporo', 'Quartier de Kaporo à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(4, 'Hamdallaye', 'Quartier de Hamdallaye à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(5, 'Taouyah', 'Quartier de Taouyah à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(6, 'Simbaya', 'Quartier de Simbaya à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(7, 'Ratoma', 'Quartier de Ratoma à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(8, 'Cimenterie', 'Quartier de Cimenterie à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(9, 'Kassonyia', 'Quartier de Kassonyia à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(10, 'Gbessia', 'Quartier de Gbessia à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(11, 'Camayenne', 'Quartier de Camayenne à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(12, 'Sonfonia', 'Quartier de Sonfonia à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(13, 'Matoto', 'Quartier de Matoto à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(14, 'Simbaya Gare', 'Quartier de Simbaya Gare à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(15, 'Enco 5', 'Quartier de Enco 5 à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(16, 'Minière', 'Quartier de Minière à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(17, 'Bonfi', 'Quartier de Bonfi à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(18, 'Bambeto', 'Quartier de Bambeto à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(19, 'Dixinn', 'Quartier de Dixinn à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(20, 'Dabondy', 'Quartier de Dabondy à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(21, 'Cosa', 'Quartier de Cosa à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(22, 'Kagbelén', 'Quartier de Kagbelén à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(23, 'Dar Es Salaam', 'Quartier de Dar Es Salaam à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(24, 'Hamdallaye II', 'Quartier de Hamdallaye II à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(25, 'Yimbayah', 'Quartier de Yimbayah à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(26, 'Soso', 'Quartier de Soso à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(27, 'Kipé', 'Quartier de Kipé à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(28, 'Koloma', 'Quartier de Koloma à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(29, 'Sangoyah', 'Quartier de Sangoyah à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(30, 'Koukou', 'Quartier de Koukou à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(31, 'Kassa', 'Quartier de Kassa à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(32, 'Damaro', 'Quartier de Damaro à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(33, 'Gbessia Port', 'Quartier de Gbessia Port à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(34, 'Hamdallaye Foulah', 'Quartier de Hamdallaye Foulah à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(35, 'Simbaya Village', 'Quartier de Simbaya Village à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(36, 'Nongo', 'Quartier de Nongo à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(37, 'Diallo-Bidé', 'Quartier de Diallo-Bidé à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(38, 'Hamdallaye 2', 'Quartier de Hamdallaye 2 à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(39, 'Dabompa', 'Quartier de Dabompa à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(40, 'Cimenterie', 'Quartier de Cimenterie à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(41, 'Hafia', 'Quartier de Hafia à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(42, 'Sangoyah Foia', 'Quartier de Sangoyah Foia à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1),
(43, 'Nongo Tangali', 'Quartier de Nongo Tangali à Conakry', NULL, NULL, '2024-05-12 19:54:03', '2024-05-12 19:54:03', 1);

  

INSERT INTO ville (id, libelle, description, created_at, created_by, updated_at, modify_by, statut) VALUES
(1, 'Conakry', 'La capitale de la Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(2, 'N\'zérékoré', 'Une ville importante dans le sud-est de la Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(3, 'Kankan', 'Une ville importante dans l\'est de la Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(4, 'Kindia', 'Une ville importante dans l\'ouest de la Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(5, 'Labé', 'Une ville importante dans le nord de la Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(6, 'Kissidougou', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(7, 'Guéckédou', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(8, 'Mamou', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(9, 'Macenta', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(10, 'Faranah', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(11, 'Fria', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(12, 'Koubia', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(13, 'Koundara', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(14, 'Dabola', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(15, 'Dalaba', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(16, 'Dinguiraye', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(17, 'Dubréka', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(18, 'Kerouane', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(19, 'Kouroussa', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(20, 'Lelouma', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(21, 'Lola', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(22, 'Mali', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(23, 'Mandiana', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(24, 'Môrô', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1),
(25, 'Siguiri', 'Une ville importante en Guinée', '2024-05-12 19:50:35', NULL, '2024-05-12 19:50:35', NULL, 1);




-- Exemple d'indexation pour améliorer les performances
CREATE INDEX idx_comptabilite_type_transaction ON Comptabilite(type_transaction);
CREATE INDEX idx_comptabilite_source_transaction ON Comptabilite(source_transaction);
CREATE INDEX idx_comptabilite_contrat_id ON Comptabilite(contrat_id);
CREATE INDEX idx_comptabilite_paiement_id ON Comptabilite(paiement_id);

-- Exemple d'indexation pour les performances
CREATE INDEX idx_utilisateur_email ON Utilisateurs(email);
CREATE INDEX idx_reservation_statut ON Reservations(statut);
CREATE INDEX idx_contrat_statut ON Contrats(statut);
CREATE INDEX idx_proprietes_disponible ON Proprietes(disponible);
CREATE INDEX idx_reservations_utilisateur_propriete ON Reservations(id, propriete_id);
CREATE INDEX idx_paiements_statut ON Paiements(statut);
CREATE INDEX idx_paiements_contrat_id ON Paiements(contrat_id);
