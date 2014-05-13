--USE [master]
--GO

----IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'ling')
--DROP DATABASE [ling]
--GO

--CREATE DATABASE [ling]
--GO

USE [ling]
--GO

-- Czyszczenie bazy -- 
IF OBJECT_ID('dbo.VariantLimits', 'U') IS NOT NULL DROP TABLE [dbo].[VariantLimits]
IF OBJECT_ID('dbo.VariantDependencies', 'U') IS NOT NULL DROP TABLE [dbo].[VariantDependencies]
IF OBJECT_ID('dbo.VariantConnections', 'U') IS NOT NULL DROP TABLE [dbo].[VariantConnections]
IF OBJECT_ID('dbo.VariantSetProperties', 'U') IS NOT NULL DROP TABLE [dbo].[VariantSetProperties]
IF OBJECT_ID('dbo.Variants', 'U') IS NOT NULL DROP TABLE [dbo].[Variants]
IF OBJECT_ID('dbo.VariantSets', 'U') IS NOT NULL DROP TABLE [dbo].[VariantSets]

IF OBJECT_ID('dbo.QuestionsOptions', 'U') IS NOT NULL DROP TABLE [dbo].[QuestionsOptions]
IF OBJECT_ID('dbo.MatchQuestionCategory', 'U') IS NOT NULL DROP TABLE [dbo].[MatchQuestionCategory]
IF OBJECT_ID('dbo.Questions', 'U') IS NOT NULL DROP TABLE [dbo].[Questions]
IF OBJECT_ID('dbo.VariantSetRequiredProperties', 'U') IS NOT NULL DROP TABLE [dbo].[VariantSetRequiredProperties]
IF OBJECT_ID('dbo.VariantDependenciesDefinitions', 'U') IS NOT NULL DROP TABLE [dbo].[VariantDependenciesDefinitions]

IF OBJECT_ID('dbo.GrammarForms', 'U') IS NOT NULL DROP TABLE [dbo].[GrammarForms]
IF OBJECT_ID('dbo.WordsProperties', 'U') IS NOT NULL DROP TABLE [dbo].[WordsProperties]
IF OBJECT_ID('dbo.Words', 'U') IS NOT NULL DROP TABLE [dbo].[Words]
IF OBJECT_ID('dbo.MatchWordCategory', 'U') IS NOT NULL DROP TABLE [dbo].[MatchWordCategory]
IF OBJECT_ID('dbo.Metawords', 'U') IS NOT NULL DROP TABLE [dbo].[Metawords]

IF OBJECT_ID('dbo.WordtypeRequiredProperties', 'U') IS NOT NULL DROP TABLE [dbo].[WordtypeRequiredProperties]
IF OBJECT_ID('dbo.GrammarFormsInactiveRules', 'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsInactiveRules]
IF OBJECT_ID('dbo.GrammarFormsDefinitionsProperties', 'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsDefinitionsProperties]
IF OBJECT_ID('dbo.GrammarFormsDefinitions', 'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsDefinitions]
IF OBJECT_ID('dbo.GrammarFormsGroups', 'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsGroups]

IF OBJECT_ID('dbo.GrammarPropertyOptions', 'U') IS NOT NULL DROP TABLE [dbo].[GrammarPropertyOptions]
IF OBJECT_ID('dbo.GrammarPropertyDefinitions', 'U') IS NOT NULL DROP TABLE [dbo].[GrammarPropertyDefinitions]
IF OBJECT_ID('dbo.ValueTypes', 'U') IS NOT NULL DROP TABLE [dbo].[ValueTypes]
IF OBJECT_ID('dbo.WordTypes', 'U') IS NOT NULL DROP TABLE [dbo].[WordTypes]

IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE [dbo].[Categories]
IF OBJECT_ID('dbo.UsersLanguages', 'U') IS NOT NULL DROP TABLE [dbo].[UsersLanguages]
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE [dbo].[Users]
IF OBJECT_ID('dbo.Languages', 'U') IS NOT NULL DROP TABLE [dbo].[Languages]
IF OBJECT_ID('dbo.Countries', 'U') IS NOT NULL DROP TABLE [dbo].[Countries]
  
-- Functions
IF OBJECT_ID('dbo.checkLanguageForGrammarPropertyDefinition', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkLanguageForGrammarPropertyDefinition]
IF OBJECT_ID('dbo.checkQuestionForVariantSet', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkQuestionForVariantSet]
IF OBJECT_ID('dbo.checkSetForVariant', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkSetForVariant]
IF OBJECT_ID('dbo.checkGrammarDefinitionWordtype', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkGrammarDefinitionWordtype]
IF OBJECT_ID('dbo.checkGrammarOptionProperty', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkGrammarOptionProperty]

GO


-- TABELE SYSTEMOWE --

-- Kraje
CREATE TABLE [dbo].[Countries] (
      [Id]			INT            IDENTITY (1, 1) NOT NULL
    , [ShortName]	NVARCHAR (3)   NOT NULL UNIQUE
    , [Name]		NVARCHAR (100) NOT NULL UNIQUE
--    , [FlagTop]     INT            NULL
--	  , [FlagLeft]    INT            NULL
    , CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED ([Id] ASC)
);
SET IDENTITY_INSERT [dbo].[Countries] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[Countries] ([Id], [ShortName], [Name])
	SELECT 1, N'POL', N'Polska'
COMMIT;
SET IDENTITY_INSERT [dbo].[Countries] OFF


GO


-- Języki
CREATE TABLE [dbo].[Languages] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [Name]			NVARCHAR (255)	NOT NULL UNIQUE
    , [Flag]			NVARCHAR (MAX)	NULL
    , [IsActive]		BIT				DEFAULT ((1)) NOT NULL
    , [OriginalName]	NVARCHAR (255)	NULL
    , CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED ([Id] ASC)
);

SET IDENTITY_INSERT [dbo].[Languages] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[Languages] ([Id], [Name], [Flag], [IsActive], [OriginalName])
	SELECT 1, N'polski', N'pol', 1, N'Polski' UNION ALL
	SELECT 2, N'angielski', N'gbr', 1, N'English' UNION ALL
	SELECT 3, N'hiszpański', N'esp', 1, N'Español' UNION ALL
	SELECT 4, N'włoski', N'ita', 1, N'Italiano'
COMMIT;
SET IDENTITY_INSERT [dbo].[Languages] OFF


GO


-- Userzy
CREATE TABLE [dbo].[Users] (
      [Id]				 INT            IDENTITY (1, 1) NOT NULL
    , [Username]         NVARCHAR (50)  NOT NULL UNIQUE
    , [Password]         NVARCHAR (MAX) NOT NULL
	, [FirstName]        NVARCHAR (100) NULL
    , [LastName]         NVARCHAR (100) NULL
    , [CountryId]        INT            NULL
    , [DateOfBirth]      DATETIME       NULL
    , [RegistrationDate] DATETIME       DEFAULT (GETDATE()) NOT NULL
    , [Email]            NVARCHAR (50)  NOT NULL UNIQUE
    , [IsActive]         BIT            DEFAULT ((1)) NOT NULL
    , [MailVerified]     BIT            DEFAULT ((0)) NOT NULL
    , [VerificationCode] NVARCHAR (MAX) NULL
    , [VerificationDate] DATETIME       NULL
    , CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_UserCountry] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Countries] ([Id])
);

SET IDENTITY_INSERT [dbo].[Users] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[Users] ([Id], [Username], [Password], [FirstName], [LastName], [CountryId], [Email])
SELECT 1, N'Mielnik', N'haslo', N'Tomasz', N'Mielniczek', 1, N'mielk@o2.pl'
COMMIT;
SET IDENTITY_INSERT [dbo].[Users] OFF

GO


-- Języki userów
CREATE TABLE [dbo].[UsersLanguages] (
      [Id]         INT		IDENTITY (1, 1) NOT NULL
    , [UserId]     INT		NOT NULL
    , [LanguageId] INT		NOT NULL
    , CONSTRAINT [PK_UsersLanguages] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_UserLanguage] UNIQUE NONCLUSTERED ([UserId] ASC, [LanguageId] ASC)
    , CONSTRAINT [FK_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
);

SET IDENTITY_INSERT [dbo].[UsersLanguages] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[UsersLanguages] ([Id], [UserId], [LanguageId])
	SELECT 1, 1, 1 UNION ALL
	SELECT 2, 1, 2 UNION ALL
	SELECT 3, 1, 3
COMMIT;
SET IDENTITY_INSERT [dbo].[UsersLanguages] OFF
GO


-- Kategorie
CREATE TABLE [dbo].[Categories] (
      [Id]         INT            IDENTITY (1, 1) NOT NULL
    , [Name]       NVARCHAR (255) NOT NULL
    , [ParentId]   INT            NULL
    , [IsActive]   BIT            DEFAULT ((1)) NOT NULL
    , [CreatorId]  INT            DEFAULT ((1)) NOT NULL
    , [CreateDate] DATETIME       DEFAULT (GETDATE()) NOT NULL
    , [IsApproved] BIT            DEFAULT ((0)) NOT NULL
    , [Positive]   INT            DEFAULT ((0)) NOT NULL
    , [Negative]   INT            DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_ExistingCategoryCanBeParent] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[Categories] ([Id])
    , CONSTRAINT [FK_CategoryUser] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
);

SET IDENTITY_INSERT [dbo].[Categories] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[Categories] ([Id], [Name], [ParentId]) 
SELECT 1, N'root', NULL UNION ALL
SELECT 2, N'Geografia', 1 UNION ALL
SELECT 3, N'Państwa', 2 UNION ALL
SELECT 4, N'Europa', 3 UNION ALL
SELECT 5, N'Ameryka Północna', 3 UNION ALL
SELECT 6, N'Ameryka Południowa', 3 UNION ALL
SELECT 7, N'Afryka', 3 UNION ALL
SELECT 8, N'Azja', 3 UNION ALL
SELECT 9, N'Oceania', 3 UNION ALL
SELECT 10, N'Miasta', 2 UNION ALL
SELECT 11, N'Rzeki', 2 UNION ALL
SELECT 12, N'Góry', 2 UNION ALL
SELECT 13, N'Morza', 2 UNION ALL
SELECT 14, N'Przyroda', 1 UNION ALL
SELECT 15, N'Rośliny', 14 UNION ALL
SELECT 16, N'Zwierzęta', 14 UNION ALL
SELECT 17, N'Ptaki', 16 UNION ALL
SELECT 18, N'Domowe', 16 UNION ALL
SELECT 19, N'Gospodarcze', 16 UNION ALL
SELECT 20, N'Ryby', 16 UNION ALL
SELECT 21, N'Owady', 16 UNION ALL
SELECT 22, N'Płazy i gady', 16 UNION ALL
SELECT 23, N'Egzotyczne', 16 UNION ALL
SELECT 24, N'Owoce', 15 UNION ALL
SELECT 25, N'Warzywa', 15 UNION ALL
SELECT 26, N'Drzewa', 15 UNION ALL
SELECT 27, N'Osoby', 1 UNION ALL
SELECT 28, N'Profesje', 27 UNION ALL
SELECT 29, N'Narodowości', 27 UNION ALL
SELECT 30, N'Rodzina', 27 UNION ALL
SELECT 31, N'Przedmioty', 1 UNION ALL
SELECT 32, N'Domowe', 31 UNION ALL
SELECT 33, N'Kuchenne', 31 UNION ALL
SELECT 41, N'Kontynenty', 2 UNION ALL
SELECT 42, N'Wyspy', 2
COMMIT;
SET IDENTITY_INSERT [dbo].[Categories] OFF

GO



-- WORDS DEFINITIONS

-- Word types
CREATE TABLE [dbo].[WordTypes] (
      [Id]				INT				NOT NULL
    , [Name]			NVARCHAR (255)	NOT NULL UNIQUE
    , [DisplayForWord]	BIT				NOT NULL
	, CONSTRAINT [PK_WordTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

BEGIN TRANSACTION;
	INSERT INTO [dbo].[WordTypes] ([Id], [Name], [DisplayForWord]) 
	SELECT 1, N'N', 1 UNION ALL
	SELECT 2, N'V', 1 UNION ALL
	SELECT 3, N'A', 1 UNION ALL
	SELECT 4, N'O', 1 UNION ALL
	SELECT 5, N'P', 0
COMMIT;

GO


-- Typy definiowanych wartości (np. radio, multilist, itp.)
CREATE TABLE [dbo].[ValueTypes] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [Type]			NVARCHAR(255)	NOT NULL
    , CONSTRAINT [PK_ValueTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
)

SET IDENTITY_INSERT [dbo].[ValueTypes] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[ValueTypes] ([Id], [Type]) 
	SELECT 1, N'boolean' UNION ALL
	SELECT 2, N'radio' UNION ALL
	SELECT 3, N'multilist'
COMMIT;
SET IDENTITY_INSERT [dbo].[ValueTypes] OFF

GO


-- Definicje właściwości gramatycznych (np. rodzaj, liczba, itd.)
CREATE TABLE [dbo].[GrammarPropertyDefinitions] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [LanguageId]		INT				NOT NULL
    , [Name]			NVARCHAR (255)	NOT NULL
    , [Type]			INT				NOT NULL
    , [Default]			BIT				NOT NULL
    , CONSTRAINT [PK_GrammarPropertyDefinitions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_GrammarPropertyDefinitions_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_GrammarPropertyDefinitions_ValueTypes] FOREIGN KEY ([Type]) REFERENCES [dbo].[ValueTypes] ([Id])
    , CONSTRAINT [U_LanguageName] UNIQUE NONCLUSTERED ([LanguageId] ASC, [Name] ASC)
);

SET IDENTITY_INSERT [dbo].[GrammarPropertyDefinitions] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[GrammarPropertyDefinitions] ([Id], [LanguageId], [Name], [Type], [Default]) 
	SELECT 1, 1, N'Rodzaj', 2, 0 UNION ALL
	SELECT 2, 1, N'Liczba', 2, 0 UNION ALL
	SELECT 3, 1, N'Czy osobowy', 1, 0 UNION ALL
	SELECT 4, 2, N'Gender', 2, 0 UNION ALL
	SELECT 5, 2, N'Number', 2, 0 UNION ALL
	SELECT 6, 2, N'Is person', 1, 0 UNION ALL
	SELECT 7, 1, N'Czy miejsce', 1, 0 UNION ALL
	SELECT 8, 2, N'Is place', 1, 0
COMMIT;
SET IDENTITY_INSERT [dbo].[GrammarPropertyDefinitions] OFF

GO


-- Dostępne opcje dla właściwości gramatycznych.
CREATE TABLE [dbo].[GrammarPropertyOptions] (
      [Id]				INT            IDENTITY (1, 1) NOT NULL
    , [PropertyId]		INT            NOT NULL
    , [Name]			NVARCHAR (255) NOT NULL
    , [Value]			INT            NOT NULL
    , [Default]			BIT            DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_GrammarPropertyOptions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_GrammarPropertyOptions_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
	, CONSTRAINT [U_PropertyName] UNIQUE NONCLUSTERED ([PropertyId] ASC, [Name] ASC)
	, CONSTRAINT [U_PropertyValue] UNIQUE NONCLUSTERED ([PropertyId] ASC, [Value] ASC)
);

SET IDENTITY_INSERT [dbo].[GrammarPropertyOptions] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[GrammarPropertyOptions] ([Id], [PropertyId], [Name], [Value])
	SELECT 1, 1, N'męski', 1 UNION ALL
	SELECT 2, 1, N'żeński', 2 UNION ALL
	SELECT 3, 1, N'nijaki', 3 UNION ALL
	SELECT 4, 2, N'pojedyncza', 1 UNION ALL
	SELECT 5, 2, N'mnoga', 2 UNION ALL
	SELECT 6, 2, N'obie liczby', 3 UNION ALL
	SELECT 7, 4, N'masculinum', 1 UNION ALL
	SELECT 8, 4, N'femininum', 2 UNION ALL
	SELECT 9, 4, N'neuter', 3 UNION ALL
	SELECT 10, 5, N'only singular', 1 UNION ALL
	SELECT 11, 5, N'only plural', 2 UNION ALL
	SELECT 12, 5, N'both', 3 UNION ALL
	SELECT 13, 3, N'osobowy', 1 UNION ALL
	SELECT 14, 3, N'nieosobowy', 0 UNION ALL
	SELECT 15, 7, N'miejsce', 1 UNION ALL
	SELECT 16, 7, N'nie-miejsce', 0 UNION ALL
	SELECT 17, 6, N'person', 1 UNION ALL
	SELECT 18, 6, N'non-person', 0 UNION ALL
	SELECT 19, 8, N'place', 1 UNION ALL
	SELECT 20, 8, N'non-place', 0
COMMIT;
SET IDENTITY_INSERT [dbo].[GrammarPropertyOptions] OFF


GO

-- Funkcja zwracająca właściwość przypisany do danej opcji
CREATE FUNCTION [dbo].[checkGrammarOptionProperty] (@Option INT) 
RETURNS INT 
AS BEGIN
	DECLARE @Property INT

	SET @Property = (SELECT [gpo].[PropertyId] FROM [dbo].[GrammarPropertyOptions] AS [gpo] WHERE [gpo].[Id] = @Option)

	RETURN @Property

END

GO






-- Tabela definiująca podział definicji gramatycznych na grupy
CREATE TABLE [dbo].[GrammarFormsGroups] (
      [Id]				INT            IDENTITY (1, 1) NOT NULL
    , [LanguageId]		INT            NOT NULL
    , [WordtypeId]		INT            NOT NULL
    , [Name]			NVARCHAR (255) NOT NULL
    , [IsHeader]		BIT            NOT NULL
    , [Index]			INT            NOT NULL
    , CONSTRAINT [PK_GrammarFormsGroups] PRIMARY KEY CLUSTERED ([Id] ASC)
	, CONSTRAINT [U_GrammarFormsGroups_UniqueName] UNIQUE NONCLUSTERED ([WordtypeId] ASC, [LanguageId] ASC, [Name] ASC)
    , CONSTRAINT [FK_GrammarFormsGroups_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_GrammarFormsGroups_Wordtype] FOREIGN KEY ([WordtypeId]) REFERENCES [dbo].[WordTypes] ([Id])
);

SET IDENTITY_INSERT [dbo].[GrammarFormsGroups] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[GrammarFormsGroups] ([Id], [LanguageId], [WordtypeId], [Name], [IsHeader], [Index])
	SELECT 1, 1, 1, 'Header', 1, 0 UNION ALL
	SELECT 2, 1, 1, 'Liczba pojedyncza', 0, 1 UNION ALL
	SELECT 3, 1, 1, 'Liczba mnoga', 0, 2 UNION ALL
	SELECT 4, 2, 1, 'Header', 1, 0 UNION ALL
	SELECT 5, 2, 1, 'Forms', 0, 1
COMMIT;
SET IDENTITY_INSERT [dbo].[GrammarFormsGroups] OFF





-- Tabela definiująca wszystkie formy gramatyczne przy odmianie wyrazów, np. rzeczownik liczby pojedynczej
CREATE TABLE [dbo].[GrammarFormsDefinitions] (
      [Id]				INT            IDENTITY (1, 1) NOT NULL
    , [GroupId]			INT			   NOT NULL
	, [Displayed]		NVARCHAR (255) NOT NULL
    --, [InactiveRules]	VARCHAR (255)  NULL
    , [Index]			INT            NOT NULL
    , CONSTRAINT [PK_GrammarFormsDefinitions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_GrammarFormsDefinitions_Groups] FOREIGN KEY ([GroupId]) REFERENCES [dbo].[GrammarFormsGroups] ([Id])
);

SET IDENTITY_INSERT [dbo].[GrammarFormsDefinitions] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[GrammarFormsDefinitions] ([Id], [GroupId], [Displayed], [Index])
	SELECT 1, 1, 'To jest ...', 0 UNION ALL
	SELECT 2, 1, 'Nie ma ...', 1 UNION ALL
	SELECT 3, 1, 'Przyglądam się ...', 2 UNION ALL
	SELECT 4, 1, 'Widzę ...', 3 UNION ALL
	SELECT 5, 1, 'Porozmawiaj z ...', 4 UNION ALL
	SELECT 6, 1, 'Porozmawiaj o ...', 5 UNION ALL
	SELECT 7, 1, '!...', 6 UNION ALL
	SELECT 8, 2, 'Mianownik pojedynczy', 0 UNION ALL
	SELECT 9, 2, 'Dopełniacz pojedynczy', 1 UNION ALL
	SELECT 10, 2, 'Celownik pojedynczy', 2 UNION ALL
	SELECT 11, 2, 'Biernik pojedynczy', 3 UNION ALL
	SELECT 12, 2, 'Narzędnik pojedynczy', 4 UNION ALL
	SELECT 13, 2, 'Miejscownik pojedynczy', 5 UNION ALL
	SELECT 14, 2, 'Wołacz pojedynczy', 6 UNION ALL
	SELECT 15, 3, 'Mianownik mnogi', 0 UNION ALL
	SELECT 16, 3, 'Dopełniacz mnogi', 1 UNION ALL
	SELECT 17, 3, 'Celownik mnogi', 2 UNION ALL
	SELECT 18, 3, 'Biernik mnogi', 3 UNION ALL
	SELECT 19, 3, 'Narzędnik mnogi', 4 UNION ALL
	SELECT 20, 3, 'Miejscownik mnogi', 5 UNION ALL
	SELECT 21, 3, 'Wołacz mnogi', 6 UNION ALL
	SELECT 22, 1, 'Jadę ...', 7 UNION ALL
	SELECT 23, 1, 'Jestem ...', 8 UNION ALL
	SELECT 24, 1, 'Do', 7 UNION ALL
	SELECT 25, 1, 'W', 8 UNION ALL
	SELECT 27, 4, 'article', 0 UNION ALL
	SELECT 28, 4, 'singular', 1 UNION ALL
	SELECT 29, 4, 'plural', 2 UNION ALL
	SELECT 30, 4, 'to ...', 3 UNION ALL
	SELECT 31, 4, 'in ...', 4 UNION ALL
	SELECT 32, 5, 'article', 0 UNION ALL
	SELECT 33, 5, 'singular', 1 UNION ALL
	SELECT 34, 5, 'plural', 2 UNION ALL
	SELECT 35, 5, 'to ...', 3 UNION ALL
	SELECT 36, 5, 'in ...', 4
COMMIT;

SET IDENTITY_INSERT [dbo].[GrammarFormsDefinitions] OFF


GO

-- Funkcja zwracająca wordtype przypisany do danej definicji gramatycznej
CREATE FUNCTION [dbo].[checkGrammarDefinitionWordtype] (@Definition INT) 
RETURNS INT 
AS BEGIN
	DECLARE @Wordtype INT

	SET @Wordtype = (
		SELECT 
			[gfg].[WordtypeId] 
		FROM 
			[dbo].[GrammarFormsDefinitions] AS [gfd] 
			LEFT JOIN [dbo].[GrammarFormsGroups] AS [gfg] ON [gfd].[GroupId] = [gfg].[Id]
		WHERE 
			[gfd].[Id] = @Definition
	)

	RETURN @Wordtype

END

GO

-- Funkcja sprawdzająca poprawność matchowania Language-GrammarPropertyDefinition
CREATE FUNCTION [dbo].[checkLanguageForGrammarPropertyDefinition] (@Id INT) 
RETURNS INT 
AS BEGIN

	DECLARE @Language INT

	SET @Language = (SELECT [gdp].[LanguageId] FROM [dbo].[GrammarPropertyDefinitions] AS [gdp] WHERE [gdp].[Id] = @Id)

	RETURN @Language

END

GO





-- Tabela maczująca definicje form gramatycznych (z tabeli GrammarFormDefinitions) z odpowiednimi opcjami z tabeli GrammarPropertyOptions,
-- np. Rzeczownik liczby pojedynczej będzie zmaczowane z opcją Przypadek - rzeczownik oraz z opcją Liczba - pojedyncza
CREATE TABLE [dbo].[GrammarFormsDefinitionsProperties]
(
      [Id]				INT		IDENTITY (1, 1) NOT NULL
	, [DefinitionId]	INT		NOT NULL
	, [PropertyId]		INT		NOT NULL
	, [Value]			INT		NOT NULL
    , CONSTRAINT [PK_GrammarFormsDefinitionsProperties] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_GrammarFormsDefinitionsProperties_Definition] FOREIGN KEY ([DefinitionId]) REFERENCES [dbo].[GrammarFormsDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsDefinitionsProperties_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsDefinitionsProperties_Value] FOREIGN KEY ([Value]) REFERENCES [dbo].[GrammarPropertyOptions] ([Id])
	, CONSTRAINT [CH_GrammarFormsDefinitionsProperties_MatchedValueProperty] CHECK ([dbo].[checkGrammarOptionProperty](Value) = [PropertyId])
	, CONSTRAINT [U_GrammarFormsDefinitionsProperties_UniquePropertyDefinition] UNIQUE NONCLUSTERED ([DefinitionId] ASC, [PropertyId] ASC)
);

SET IDENTITY_INSERT [dbo].[GrammarFormsDefinitionsProperties] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[GrammarFormsDefinitionsProperties] ([Id], [DefinitionId], [PropertyId], [Value]) 
	SELECT 1, 1, 1, 1
COMMIT;
SET IDENTITY_INSERT [dbo].[GrammarFormsDefinitionsProperties] OFF


GO


-- Tabela przechowująca warunki jakie muszą być spełnione, żeby dany rekord z [GrammarFormsDefinitions]
-- był nieaktywny, np. Rzeczownik pojedynczy będzie nieaktywny, jeżeli pole Liczba będzie ustawione na
-- Tylko mnoga.
CREATE TABLE [dbo].[GrammarFormsInactiveRules](
	  [Id]					INT		IDENTITY (1, 1) NOT NULL
	, [DefinitionId]		INT		NOT NULL
	, [PropertyId]			INT		NOT NULL
	, [Value]				INT		NOT NULL
	, CONSTRAINT [PK_GrammarFormsInactiveRules] PRIMARY KEY CLUSTERED ([Id] ASC)
	, CONSTRAINT [FK_GrammarFormsInactiveRules_Definition] FOREIGN KEY ([DefinitionId]) REFERENCES [dbo].[GrammarFormsDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsInactiveRules_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsInactiveRules_Value] FOREIGN KEY ([Value]) REFERENCES [dbo].[GrammarPropertyOptions] ([Id])
	, CONSTRAINT [CH_GrammarFormsInactiveRules_MatchedValueProperty] CHECK ([dbo].[checkGrammarOptionProperty](Value) = [PropertyId])
	, CONSTRAINT [U_GrammarFormsInactiveRules_UniqueDefinitionPropertyValue] UNIQUE NONCLUSTERED ([DefinitionId] ASC, [PropertyId] ASC, [Value] ASC)
);

SET IDENTITY_INSERT [dbo].[GrammarFormsInactiveRules] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[GrammarFormsInactiveRules] ([Id], [DefinitionId], [PropertyId], [Value]) 
	SELECT 1, 8, 2, 5 UNION ALL
	SELECT 2, 9, 2, 5 UNION ALL
	SELECT 3, 10, 2, 5 UNION ALL
	SELECT 4, 11, 2, 5 UNION ALL
	SELECT 5, 12, 2, 5 UNION ALL
	SELECT 6, 13, 2, 5 UNION ALL
	SELECT 7, 14, 2, 5 UNION ALL
	SELECT 8, 15, 2, 4 UNION ALL
	SELECT 9, 16, 2, 4 UNION ALL
	SELECT 10, 17, 2, 4 UNION ALL
	SELECT 11, 18, 2, 4 UNION ALL
	SELECT 12, 19, 2, 4 UNION ALL
	SELECT 13, 20, 2, 4 UNION ALL
	SELECT 14, 21, 2, 4 UNION ALL
	SELECT 15, 22, 7, 16 UNION ALL
	SELECT 16, 23, 7, 16 UNION ALL
	SELECT 17, 24, 7, 16 UNION ALL
	SELECT 18, 25, 7, 16 UNION ALL
	SELECT 19, 32, 5, 11 UNION ALL
	SELECT 20, 33, 5, 11 UNION ALL
	SELECT 21, 34, 5, 10 UNION ALL
	SELECT 22, 30, 8, 20 UNION ALL
	SELECT 23, 31, 8, 20 UNION ALL
	SELECT 24, 35, 8, 20 UNION ALL
	SELECT 25, 36, 8, 20
COMMIT;
SET IDENTITY_INSERT [dbo].[GrammarFormsInactiveRules] OFF


GO


-- Właściwości wymagane dla danego typu wyrazów (np. określa, że rzeczowniki mają mieć zdefiniowany rodzaj i dostępne liczby).
CREATE TABLE [dbo].[WordtypeRequiredProperties] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [LanguageId]		INT				NOT NULL
    , [WordtypeId]		INT             NOT NULL
    , [PropertyId]		INT				NOT NULL
    , CONSTRAINT [PK_WordtypeRequiredProperties] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_WordtypeRequired_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_WordtypeRequired_Wordtype] FOREIGN KEY ([WordtypeId]) REFERENCES [dbo].[WordTypes] ([Id])
    , CONSTRAINT [FK_WordtypeRequired_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
    , CONSTRAINT [U_WordtypeRequired_LanguageWordtypeProperty] UNIQUE NONCLUSTERED ([LanguageId] ASC, [WordtypeId] ASC, [PropertyId] ASC)
    , CONSTRAINT [CH_WordtypeRequired_LanguageMatched] CHECK ([LanguageId] = [dbo].[checkLanguageForGrammarPropertyDefinition]([PropertyId]))
);

GO

SET IDENTITY_INSERT [dbo].[WordtypeRequiredProperties] ON
INSERT INTO [dbo].[WordtypeRequiredProperties] ([Id], [LanguageId], [WordtypeId], [PropertyId]) VALUES (1, 1, 1, 1)
INSERT INTO [dbo].[WordtypeRequiredProperties] ([Id], [LanguageId], [WordtypeId], [PropertyId]) VALUES (2, 1, 1, 2)
INSERT INTO [dbo].[WordtypeRequiredProperties] ([Id], [LanguageId], [WordtypeId], [PropertyId]) VALUES (3, 1, 1, 3)
INSERT INTO [dbo].[WordtypeRequiredProperties] ([Id], [LanguageId], [WordtypeId], [PropertyId]) VALUES (4, 2, 1, 4)
INSERT INTO [dbo].[WordtypeRequiredProperties] ([Id], [LanguageId], [WordtypeId], [PropertyId]) VALUES (5, 2, 1, 5)
INSERT INTO [dbo].[WordtypeRequiredProperties] ([Id], [LanguageId], [WordtypeId], [PropertyId]) VALUES (6, 2, 1, 6)
SET IDENTITY_INSERT [dbo].[WordtypeRequiredProperties] OFF

GO









-- WORDS

-- Metawyrazy
CREATE TABLE [dbo].[Metawords] (
      [Id]         INT            IDENTITY (1, 1) NOT NULL
    , [Name]       NVARCHAR (255) NOT NULL UNIQUE
    , [Type]       INT            NOT NULL
    , [Weight]     INT            DEFAULT ((1)) NOT NULL
    , [IsActive]   BIT            DEFAULT ((1)) NOT NULL
    , [CreatorId]  INT            DEFAULT ((1)) NOT NULL
    , [CreateDate] DATETIME       DEFAULT (GETDATE()) NOT NULL
    , [IsApproved] BIT            DEFAULT ((0)) NOT NULL
    , [Positive]   INT            DEFAULT ((0)) NOT NULL
    , [Negative]   INT            DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_Metawords] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_WordType] FOREIGN KEY ([Type]) REFERENCES [dbo].[WordTypes] ([Id])
    , CONSTRAINT [FK_MetawordUser] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [CH_Weight] CHECK ([Weight] > (0) AND [Weight] <= (10))
);


-- Matchowanie wyrazów i kategorii
CREATE TABLE [dbo].[MatchWordCategory] (
      [Id]         INT			IDENTITY (1, 1) NOT NULL
    , [MetawordId] INT			NOT NULL
    , [CategoryId] INT			NOT NULL
    , [IsActive]   BIT			DEFAULT ((1)) NOT NULL
    , [CreatorId]  INT			DEFAULT ((1)) NOT NULL
    , [CreateDate] DATETIME		DEFAULT (GETDATE()) NOT NULL
    , [IsApproved] BIT			DEFAULT ((0)) NOT NULL
    , [Positive]   INT			DEFAULT ((0)) NOT NULL
    , [Negative]   INT			DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_MatchWordCategory] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_MatchWordCategory_MetawordId] FOREIGN KEY ([MetawordId]) REFERENCES [dbo].[Metawords] ([Id])
    , CONSTRAINT [FK_MatchWordCategory_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id])
    , CONSTRAINT [FK_MatchWordCategory_User] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
);


-- Wyrazy
CREATE TABLE [dbo].[Words] (
      [Id]         INT            IDENTITY (1, 1) NOT NULL
    , [MetawordId] INT            NOT NULL
    , [LanguageId] INT            NOT NULL
    , [Name]       NVARCHAR (255) NOT NULL
    , [Weight]     INT            DEFAULT ((1)) NOT NULL
    , [IsActive]   BIT            DEFAULT ((1)) NOT NULL
    , [CreatorId]  INT            DEFAULT ((1)) NOT NULL
    , [CreateDate] DATETIME       DEFAULT (GETDATE()) NOT NULL
    , [IsApproved] BIT            DEFAULT ((0)) NOT NULL
    , [Positive]   INT            DEFAULT ((0)) NOT NULL
    , [Negative]   INT            DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_Words] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_Words_WordContentForMetaword] UNIQUE NONCLUSTERED ([MetawordId] ASC, [LanguageId] ASC, [Name] ASC)
    , CONSTRAINT [FK_WordMetaword] FOREIGN KEY ([MetawordId]) REFERENCES [dbo].[Metawords] ([Id])
    , CONSTRAINT [FK_WordLanguage] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_WordCreator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [CH_WordWeight] CHECK ([Weight] > (0) AND [Weight] <= (10))
);


-- Właściwości wyrazów
CREATE TABLE [dbo].[WordsProperties] (
      [Id]			INT            IDENTITY (1, 1) NOT NULL
    , [WordId]		INT            NOT NULL
    , [PropertyId]	INT            NOT NULL
    , [Value]		NVARCHAR (255) NOT NULL
    , CONSTRAINT [PK_WordsProperties] PRIMARY KEY CLUSTERED ([Id] ASC)
	, CONSTRAINT [U_WordsProperties_WordProperty] UNIQUE NONCLUSTERED ([WordId] ASC, [PropertyId] ASC)
    , CONSTRAINT [FK_WordsProperties_Word] FOREIGN KEY ([WordId]) REFERENCES [dbo].[Words] ([Id])
    , CONSTRAINT [FK_WordsProperties_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
);


-- Odmiana gramatyczna wyrazu
CREATE TABLE [dbo].[GrammarForms] (
	  [Id]			INT				IDENTITY (1, 1) NOT NULL
	, [FormId]		INT				NOT NULL
    , [WordId]		INT				NOT NULL
    , [Content]		NVARCHAR (255)	NOT NULL
    , [IsActive]	BIT				DEFAULT ((1)) NOT NULL
    , [CreatorId]	INT				DEFAULT ((1)) NOT NULL
    , [CreateDate]	DATETIME		DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]	BIT				DEFAULT ((0)) NOT NULL
    , [Positive]	INT				DEFAULT ((0)) NOT NULL
    , [Negative]	INT				DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_GrammarForms] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_GrammarForms_Form] FOREIGN KEY ([FormId]) REFERENCES [dbo].[GrammarFormsDefinitions] ([Id])
    , CONSTRAINT [FK_GrammarForms_Word] FOREIGN KEY ([WordId]) REFERENCES [dbo].[Words] ([Id])
    , CONSTRAINT [U_GrammarForms_WordForm] UNIQUE NONCLUSTERED ([WordId] ASC, [FormId] ASC)
);




-- QUESTIONS

-- Metadefinicje

-- Tabela określająca które części mowy w poszczególnych językach mogą być połączone ze sobą na zasadzie zależności jednej od drugiej
-- np. przymiotnik zależny od rzeczownika w języku polskim - jeżeli rzeczownik jest rodzaju męskiego mówimy [ładny], a do rodzaju żeńskiego [ładna]
CREATE TABLE [dbo].[VariantDependenciesDefinitions]
(
      [Id]					INT		IDENTITY (1, 1) NOT NULL
    , [LanguageId]			INT		NOT NULL
	, [MasterWordtypeId]	INT		NOT NULL
	, [SlaveWordtypeId]		INT		NOT NULL
    , CONSTRAINT [PK_VariantDependenciesDefinitions] PRIMARY KEY CLUSTERED ([Id] ASC)
	, CONSTRAINT [CH_DifferentWordtypes] CHECK ([MasterWordtypeId] <> [SlaveWordtypeId])
    , CONSTRAINT [U_VariantDependenciesDefinitions_Wordtypes] UNIQUE NONCLUSTERED ([MasterWordtypeId] ASC, [SlaveWordtypeId] ASC)
    , CONSTRAINT [FK_VariantDependenciesDefinitions_Languages] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
	, CONSTRAINT [FK_VariantDependenciesDefinitions_MasterWordtype] FOREIGN KEY ([MasterWordtypeId]) REFERENCES [dbo].[WordTypes] ([Id])
	, CONSTRAINT [FK_VariantDependenciesDefinitions_SlaveWordtype] FOREIGN KEY ([SlaveWordtypeId]) REFERENCES [dbo].[WordTypes] ([Id])
)


GO

SET IDENTITY_INSERT [dbo].[VariantDependenciesDefinitions] ON
INSERT INTO [dbo].[VariantDependenciesDefinitions] ([Id], [LanguageId], [MasterWordtypeId], [SlaveWordtypeId]) VALUES (1, 1, 1, 2)
INSERT INTO [dbo].[VariantDependenciesDefinitions] ([Id], [LanguageId], [MasterWordtypeId], [SlaveWordtypeId]) VALUES (2, 1, 1, 3)
INSERT INTO [dbo].[VariantDependenciesDefinitions] ([Id], [LanguageId], [MasterWordtypeId], [SlaveWordtypeId]) VALUES (3, 1, 5, 2)
SET IDENTITY_INSERT [dbo].[VariantDependenciesDefinitions] OFF

GO


-- Tabela określająca właściwości wymagane do opisania poszczególnych wariant setów (w zależności od ich wordtype).
CREATE TABLE [dbo].[VariantSetRequiredProperties] (
      [Id]              INT		IDENTITY (1, 1) NOT NULL
    , [LanguageId]      INT		NOT NULL
    , [WordtypeId]		INT		NOT NULL
    , [PropertyId]		INT		NOT NULL
    , CONSTRAINT [PK_VariantSetRequiredProperties] PRIMARY KEY CLUSTERED ([Id] ASC) 
    , CONSTRAINT [FK_VariantSetRequiredProperties_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_VariantSetRequiredProperties_Wordtype] FOREIGN KEY ([WordtypeId]) REFERENCES [dbo].[WordTypes] ([Id])
    , CONSTRAINT [FK_VariantSetRequiredProperties_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
);


GO


-- Funkcja sprawdzająca poprawność matchowania Language-GrammarPropertyDefinition
CREATE FUNCTION [dbo].[checkQuestionForVariantSet] (@VariantSet INT) 
RETURNS INT 
AS BEGIN

	DECLARE @Question INT

	SET @Question = (SELECT [vs].[QuestionId] FROM [dbo].[VariantSets] AS [vs] WHERE [vs].[Id] = @VariantSet)

	RETURN @Question

END

GO



CREATE FUNCTION [dbo].[checkSetForVariant] (@Variant INT) 
RETURNS INT 
AS BEGIN

	DECLARE @VariantSet INT

	SET @VariantSet = (SELECT [v].[VariantSetId] FROM [dbo].[Variants] AS [v] WHERE [v].[Id] = @Variant)

	RETURN @VariantSet

END

GO




-- Pytania
CREATE TABLE [dbo].[Questions] (
      [Id]				INT           IDENTITY (1, 1) NOT NULL
    , [Name]			VARCHAR (255) NOT NULL UNIQUE
    , [Weight]			INT           DEFAULT ((0)) NOT NULL
    , [IsActive]		BIT           DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT           DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME      DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT           DEFAULT ((0)) NOT NULL
    , [Positive]		INT           DEFAULT ((0)) NOT NULL
    , [Negative]		INT           DEFAULT ((0)) NOT NULL
    , [IsComplex]		BIT           DEFAULT ((1)) NOT NULL
    , CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_QuestionCreator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [Check_Weight] CHECK ([Weight] > (0) AND [Weight] <= (10))
);



-- Maczowanie pytań z kategoriami
CREATE TABLE [dbo].[MatchQuestionCategory] (
      [Id]				INT			IDENTITY (1, 1) NOT NULL
    , [QuestionId]		INT			NOT NULL
    , [CategoryId]		INT			NOT NULL
    , [IsActive]		BIT			DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT			DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME	DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT			DEFAULT ((0)) NOT NULL
    , [Positive]		INT			DEFAULT ((0)) NOT NULL
    , [Negative]		INT			DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_MatchQuestionCategory] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_MatchQuestionCategory_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id])
    , CONSTRAINT [FK_MatchQuestionCategory_Category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([Id])
    , CONSTRAINT [FK_MatchQuestionCategory_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
);


-- Opcje zapytań
CREATE TABLE [dbo].[QuestionsOptions] (
      [Id]				INT            IDENTITY (1, 1) NOT NULL
    , [QuestionId]		INT            NOT NULL
    , [LanguageId]		INT            NOT NULL
    , [Content]			NVARCHAR (255) NOT NULL
    , [Weight]			INT            DEFAULT ((1)) NOT NULL
    , [IsActive]		BIT            DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT            DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME       DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT            DEFAULT ((0)) NOT NULL
    , [Positive]		INT            DEFAULT ((0)) NOT NULL
    , [Negative]		INT            DEFAULT ((0)) NOT NULL
    , [IsComplex]		BIT            DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_QuestionsOptions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_QuestionsOptions_QuestionLanguageContent] UNIQUE NONCLUSTERED ([QuestionId] ASC, [LanguageId] ASC, [Content] ASC)
    , CONSTRAINT [FK_QuestionsOptions_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id])
    , CONSTRAINT [FK_QuestionsOptions_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [FK_QuestionsOptions_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [CH_QuestionsOptionsWeight] CHECK ([Weight] > (0) AND [Weight] <= (10))
);



-- Warianty dla zapytań.
CREATE TABLE [dbo].[VariantSets] (
      [Id]				INT            IDENTITY (1, 1) NOT NULL
    , [QuestionId]		INT            NOT NULL
    , [LanguageId]		INT            NOT NULL
    , [VariantTag]		NVARCHAR (255) NOT NULL
    , [WordType]		INT            NOT NULL
    --, [Params]			NVARCHAR (255) NOT NULL
    , [IsActive]		BIT            DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT            DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME       DEFAULT (GETDATE()) NOT NULL
    , CONSTRAINT [PK_VariantSets] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_VariantSets_QuestionLanguageTag] UNIQUE NONCLUSTERED ([QuestionId] ASC, [LanguageId] ASC, [VariantTag] ASC)
    , CONSTRAINT [FK_VariantSets_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id])
    , CONSTRAINT [FK_VariantSets_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_VariantSets_Wordtype] FOREIGN KEY ([WordType]) REFERENCES [dbo].[WordTypes] ([Id])
    , CONSTRAINT [FK_VariantSets_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
);


-- Właściwości poszczególnych wariant setów.
CREATE TABLE [dbo].[VariantSetProperties] (
      [Id]				INT			IDENTITY (1, 1) NOT NULL
	, [VariantSetId]	INT			NOT NULL
	, [PropertyId]		INT			NOT NULL
	, [Value]			INT			NOT NULL
    , CONSTRAINT [PK_VariantSetProperties] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_VariantSetProperties_VariantSet] FOREIGN KEY ([VariantSetId]) REFERENCES [dbo].[VariantSets] ([Id])
    , CONSTRAINT [FK_VariantSetProperties_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[VariantSetRequiredProperties] ([Id])
);

-- Tabela przechowująca Varianty znajdujące się w VariantSetach
CREATE TABLE [dbo].[Variants] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [VariantSetId]	INT				NOT NULL
    , [Key]				NVARCHAR (255)	NOT NULL
    , [Content]			NVARCHAR (255)	NOT NULL
    , [WordId]			INT				NULL
    , [IsAnchored]		BIT				DEFAULT ((0)) NOT NULL
    , [IsActive]		BIT				DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT				DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME		DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT				DEFAULT ((0)) NOT NULL
    , [Positive]		INT				DEFAULT ((0)) NOT NULL
    , [Negative]		INT				DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_Variants] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_Variants_SetKey] UNIQUE NONCLUSTERED ([VariantSetId] ASC, [Key] ASC)
    , CONSTRAINT [FK_Variants_Words] FOREIGN KEY ([WordId]) REFERENCES [dbo].[Words] ([Id])
    , CONSTRAINT [FK_Variants_Set] FOREIGN KEY ([VariantSetId]) REFERENCES [dbo].[VariantSets] ([Id])
    , CONSTRAINT [FK_Variants_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
);



-- Tabela określająca, które wariant sety są ze sobą powiązane.
CREATE TABLE [dbo].[VariantConnections] (
      [Id]				INT			IDENTITY (1, 1) NOT NULL
    , [VariantSetId]	INT			NOT NULL
    , [ConnectedSetId]	INT			NOT NULL
    , [IsActive]		BIT			DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT			DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME	DEFAULT (GETDATE()) NOT NULL
    , CONSTRAINT [PK_VariantConnections] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_VariantConnections_DifferentSets] UNIQUE NONCLUSTERED ([VariantSetId] ASC, [ConnectedSetId] ASC)
    , CONSTRAINT [FK_VariantConnections_VariantSet] FOREIGN KEY ([VariantSetId]) REFERENCES [dbo].[VariantSets] ([Id])
    , CONSTRAINT [FK_VariantConnections_ConnectedSet] FOREIGN KEY ([ConnectedSetId]) REFERENCES [dbo].[VariantSets] ([Id])
    , CONSTRAINT [FK_VariantConnections_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [CH_VariantConnections_DifferentVariants] CHECK ([VariantSetId] <> [ConnectedSetId])
    , CONSTRAINT [CH_VariantConnections_VariantsOfTheSameQuestion] CHECK ([dbo].[checkQuestionForVariantSet]([VariantSetId]) = [dbo].[checkQuestionForVariantSet]([ConnectedSetId]))
);


-- Tabela przechowująca listę wariantów uzależnionych od siebie
CREATE TABLE [dbo].[VariantDependencies] (
      [Id]				INT			IDENTITY (1, 1) NOT NULL
    , [MainSetId]		INT			NOT NULL
    , [DependantSetId]	INT			NOT NULL
    , [IsActive]		BIT			DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT			DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME	DEFAULT (GETDATE()) NOT NULL
    , CONSTRAINT [PK_VariantDependencies] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_VariantDependencies_UniqueSets] UNIQUE NONCLUSTERED ([MainSetId] ASC, [DependantSetId] ASC)
    , CONSTRAINT [FK_VariantDependencies_MainSet] FOREIGN KEY ([MainSetId]) REFERENCES [dbo].[VariantSets] ([Id])
    , CONSTRAINT [FK_VariantDependencies_DependantSet] FOREIGN KEY ([DependantSetId]) REFERENCES [dbo].[VariantSets] ([Id])
    , CONSTRAINT [CH_VariantDependencies_DifferentVariants] CHECK ([MainSetId] <> [DependantSetId])
    , CONSTRAINT [CH_VariantDependencies_VariantsOfTheSameQuestion] CHECK ([dbo].[checkQuestionForVariantSet]([MainSetId]) = [dbo].[checkQuestionForVariantSet]([DependantSetId]))
);


-- Tabela przechowująca listę wykluczających się wariantów
CREATE TABLE [dbo].[VariantLimits] (
      [Id]					INT     IDENTITY (1, 1) NOT NULL
    , [QuestionId]			INT		NOT NULL
    , [VariantId]			INT     NOT NULL
    , [ConnectedVariantId]	INT     NOT NULL
    , [IsActive]			BIT     DEFAULT ((1)) NOT NULL
    , [CreatorId]			INT     DEFAULT ((1)) NOT NULL
    , [CreateDate]			DATETIME DEFAULT (GETDATE()) NOT NULL
    , CONSTRAINT [PK_VariantLimits] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_VariantLimits_UniqueVariants] UNIQUE NONCLUSTERED ([VariantId] ASC, [ConnectedVariantId] ASC)
    , CONSTRAINT [FK_VariantLimits_Variant] FOREIGN KEY ([VariantId]) REFERENCES [dbo].[Variants] ([Id])
    , CONSTRAINT [FK_VariantLimits_ConnectedVariant] FOREIGN KEY ([ConnectedVariantId]) REFERENCES [dbo].[Variants] ([Id])
    , CONSTRAINT [CH_VariantLimits_DifferentVariants] CHECK ([VariantId] <> [ConnectedVariantId])
    , CONSTRAINT [CH_VariantLimits_VariantsOfDifferentSets] CHECK ([dbo].[checkSetForVariant]([VariantId]) <> [dbo].[checkSetForVariant]([ConnectedVariantId]))
);