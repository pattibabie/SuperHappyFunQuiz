SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`AdminUser`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`AdminUser` ;

CREATE TABLE IF NOT EXISTS `mydb`.`AdminUser` (
  `adminUserID` INT NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NULL,
  PRIMARY KEY (`adminUserID`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Teams`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Teams` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Teams` (
  `teamName` VARCHAR(45) NULL,
  `TID` INT NOT NULL,
  PRIMARY KEY (`TID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PQWinnerArchive`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`PQWinnerArchive` ;

CREATE TABLE IF NOT EXISTS `mydb`.`PQWinnerArchive` (
  `date` DATE NOT NULL,
  `TID` INT NOT NULL,
  `score` INT NULL,
  `pointsPossible` INT NULL,
  `picture` BLOB NULL,
  PRIMARY KEY (`date`, `TID`),
  INDEX `fk_PQWinnerArchive_Teams1_idx` (`TID` ASC),
  UNIQUE INDEX `TID_UNIQUE` (`TID` ASC),
  CONSTRAINT `fk_PQWinnerArchive_Teams1`
    FOREIGN KEY (`TID`)
    REFERENCES `mydb`.`Teams` (`TID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PQFinalStandings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`PQFinalStandings` ;

CREATE TABLE IF NOT EXISTS `mydb`.`PQFinalStandings` (
  `Teams_TID` INT NOT NULL,
  `date` DATE NOT NULL,
  `standing` VARCHAR(45) NULL,
  `score` INT NULL,
  `pointsPossible` INT NULL,
  PRIMARY KEY (`Teams_TID`, `date`),
  INDEX `fk_PQFinalStandings_Teams1_idx` (`Teams_TID` ASC),
  CONSTRAINT `fk_PQFinalStandings_Teams1`
    FOREIGN KEY (`Teams_TID`)
    REFERENCES `mydb`.`Teams` (`TID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Category` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Category` (
  `CatID` INT NOT NULL,
  `CategoryName` VARCHAR(45) NULL,
  PRIMARY KEY (`CatID`),
  UNIQUE INDEX `CatID_UNIQUE` (`CatID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Answers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Answers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Answers` (
  `AID` INT NOT NULL,
  `correctAnswer` VARCHAR(45) NOT NULL COMMENT '	',
  `wrong1` VARCHAR(45) NULL,
  `wrong2` VARCHAR(45) NULL,
  `wrong3` VARCHAR(45) NULL,
  `wrong4` VARCHAR(45) NULL,
  `wrong5` VARCHAR(45) NULL,
  `wrong6` VARCHAR(45) NULL,
  PRIMARY KEY (`AID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Question` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Question` (
  `QID` INT NOT NULL,
  `answerID` INT NOT NULL,
  `categoryID` INT NOT NULL,
  `question` VARCHAR(512) NULL,
  PRIMARY KEY (`QID`, `answerID`, `categoryID`),
  INDEX `fk_Question_Answers1_idx` (`answerID` ASC),
  INDEX `fk_Question_Category1_idx` (`categoryID` ASC),
  CONSTRAINT `fk_Question_Answers1`
    FOREIGN KEY (`answerID`)
    REFERENCES `mydb`.`Answers` (`AID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Question_Category1`
    FOREIGN KEY (`categoryID`)
    REFERENCES `mydb`.`Category` (`CatID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CurrentSessionQuestions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CurrentSessionQuestions` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CurrentSessionQuestions` (
  `SessID` INT NOT NULL,
  `questionID` INT NOT NULL,
  PRIMARY KEY (`SessID`, `questionID`),
  INDEX `fk_CurrentSessionQuestions_Question1_idx` (`questionID` ASC),
  CONSTRAINT `fk_CurrentSessionQuestions_Question1`
    FOREIGN KEY (`questionID`)
    REFERENCES `mydb`.`Question` (`QID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AnswerHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`AnswerHistory` ;

CREATE TABLE IF NOT EXISTS `mydb`.`AnswerHistory` (
  `questionID` INT NOT NULL,
  `timesCorrect` INT NULL,
  `timesWrong` INT NULL,
  PRIMARY KEY (`questionID`),
  INDEX `fk_AnswerHistory_Question1_idx` (`questionID` ASC),
  CONSTRAINT `fk_AnswerHistory_Question1`
    FOREIGN KEY (`questionID`)
    REFERENCES `mydb`.`Question` (`QID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`UserHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`UserHistory` ;

CREATE TABLE IF NOT EXISTS `mydb`.`UserHistory` (
  `UHistID` INT NOT NULL,
  `date` DATETIME NULL,
  `score` INT NULL,
  `UserID` INT NOT NULL,
  `sessionID` INT NOT NULL,
  PRIMARY KEY (`UHistID`),
  INDEX `fk_UserHistory_UserAccount_idx` (`UserID` ASC),
  INDEX `fk_UserHistory_CurrentSessionQuestions1_idx` (`sessionID` ASC),
  CONSTRAINT `fk_UserHistory_UserAccount`
    FOREIGN KEY (`UserID`)
    REFERENCES `mydb`.`UserAccount` (`UID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UserHistory_CurrentSessionQuestions1`
    FOREIGN KEY (`sessionID`)
    REFERENCES `mydb`.`CurrentSessionQuestions` (`SessID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`UserAccount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`UserAccount` ;

CREATE TABLE IF NOT EXISTS `mydb`.`UserAccount` (
  `UID` INT NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NULL,
  `UserHistID` INT NOT NULL,
  PRIMARY KEY (`UID`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `UID_UNIQUE` (`UID` ASC),
  CONSTRAINT `UserHistID`
    FOREIGN KEY (`UserHistID`)
    REFERENCES `mydb`.`UserHistory` (`UHistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`HighScores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`HighScores` ;

CREATE TABLE IF NOT EXISTS `mydb`.`HighScores` (
  `sessionID` INT NOT NULL,
  `score` INT NULL,
  `date` DATE NULL,
  `UserID` INT NOT NULL,
  PRIMARY KEY (`sessionID`, `UserID`),
  INDEX `fk_HighScores_UserAccount1_idx` (`UserID` ASC),
  CONSTRAINT `fk_HighScores_UserAccount1`
    FOREIGN KEY (`UserID`)
    REFERENCES `mydb`.`UserAccount` (`UID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
