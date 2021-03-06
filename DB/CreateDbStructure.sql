USE [ling];
--GO

begin transaction;

-- Czyszczenie bazy --

-- Usuwanie tabel
-- Zapytania --
IF OBJECT_ID('dbo.TestResults', N'U') IS NOT NULL DROP TABLE [dbo].[TestResults]
IF OBJECT_ID('dbo.LearningExcludedQuestions', N'U') IS NOT NULL DROP TABLE [dbo].[LearningExcludedQuestions]
IF OBJECT_ID('dbo.LearningExcludedWords', N'U') IS NOT NULL DROP TABLE [dbo].[LearningExcludedWords]

-- Dane --
IF OBJECT_ID('dbo.VariantLimits', N'U') IS NOT NULL DROP TABLE [dbo].[VariantLimits]
IF OBJECT_ID('dbo.VariantDependencies', N'U') IS NOT NULL DROP TABLE [dbo].[VariantDependencies]
IF OBJECT_ID('dbo.VariantConnections', N'U') IS NOT NULL DROP TABLE [dbo].[VariantConnections]
IF OBJECT_ID('dbo.MatchVariantWord', N'U') IS NOT NULL DROP TABLE [dbo].[MatchVariantWord]
IF OBJECT_ID('dbo.Variants', N'U') IS NOT NULL DROP TABLE [dbo].[Variants]
IF OBJECT_ID('dbo.VariantSets', N'U') IS NOT NULL DROP TABLE [dbo].[VariantSets]

IF OBJECT_ID('dbo.QuestionsOptions', N'U') IS NOT NULL DROP TABLE [dbo].[QuestionsOptions]
IF OBJECT_ID('dbo.MatchQuestionCategory', N'U') IS NOT NULL DROP TABLE [dbo].[MatchQuestionCategory]
IF OBJECT_ID('dbo.Questions', N'U') IS NOT NULL DROP TABLE [dbo].[Questions]

IF OBJECT_ID('dbo.GrammarForms', N'U') IS NOT NULL DROP TABLE [dbo].[GrammarForms]
IF OBJECT_ID('dbo.WordsProperties', N'U') IS NOT NULL DROP TABLE [dbo].[WordsProperties]
IF OBJECT_ID('dbo.Words', N'U') IS NOT NULL DROP TABLE [dbo].[Words]
IF OBJECT_ID('dbo.MatchWordCategory', N'U') IS NOT NULL DROP TABLE [dbo].[MatchWordCategory]
IF OBJECT_ID('dbo.Metawords', N'U') IS NOT NULL DROP TABLE [dbo].[Metawords]
IF OBJECT_ID('dbo.Categories', N'U') IS NOT NULL DROP TABLE [dbo].[Categories]

-- Systemowe --
IF OBJECT_ID('dbo.VariantDependenciesDefinitions', N'U') IS NOT NULL DROP TABLE [dbo].[VariantDependenciesDefinitions]

IF OBJECT_ID('dbo.WordRequiredProperties', N'U') IS NOT NULL DROP TABLE [dbo].[WordRequiredProperties]
IF OBJECT_ID('dbo.GrammarFormsInactiveRules', N'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsInactiveRules]
IF OBJECT_ID('dbo.GrammarFormsDefinitionsProperties', N'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsDefinitionsProperties]
IF OBJECT_ID('dbo.GrammarFormsDefinitions', N'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsDefinitions]
IF OBJECT_ID('dbo.GrammarFormsGroups', N'U') IS NOT NULL DROP TABLE [dbo].[GrammarFormsGroups]

IF OBJECT_ID('dbo.GrammarPropertyOptions', N'U') IS NOT NULL DROP TABLE [dbo].[GrammarPropertyOptions]
IF OBJECT_ID('dbo.GrammarPropertyDefinitions', N'U') IS NOT NULL DROP TABLE [dbo].[GrammarPropertyDefinitions]
IF OBJECT_ID('dbo.ValueTypes', N'U') IS NOT NULL DROP TABLE [dbo].[ValueTypes]
IF OBJECT_ID('dbo.WordTypes', N'U') IS NOT NULL DROP TABLE [dbo].[WordTypes]

IF OBJECT_ID('dbo.UsersLanguages', N'U') IS NOT NULL DROP TABLE [dbo].[UsersLanguages]
IF OBJECT_ID('dbo.Users', N'U') IS NOT NULL DROP TABLE [dbo].[Users]
IF OBJECT_ID('dbo.Languages', N'U') IS NOT NULL DROP TABLE [dbo].[Languages]
IF OBJECT_ID('dbo.Countries', N'U') IS NOT NULL DROP TABLE [dbo].[Countries]


-- Usuwanie funkcji
IF OBJECT_ID('dbo.checkWordtypeForWord', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkWordtypeForWord]
IF OBJECT_ID('dbo.checkWordtypeForVariant', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkWordtypeForVariant]
IF OBJECT_ID('dbo.checkGrammarDefinitionLanguage', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkGrammarDefinitionLanguage]
IF OBJECT_ID('dbo.checkQuestionForVariantSet', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkQuestionForVariantSet]
IF OBJECT_ID('dbo.checkSetForVariant', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkSetForVariant]
IF OBJECT_ID('dbo.checkGrammarDefinitionWordtype', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkGrammarDefinitionWordtype]
IF OBJECT_ID('dbo.checkGrammarOptionProperty', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkGrammarOptionProperty]
IF OBJECT_ID('dbo.checkWordLanguage', N'FN') IS NOT NULL DROP FUNCTION [dbo].[checkWordLanguage]


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
SELECT 1,  N'POL',  N'Polska'  UNION ALL 
SELECT 2,  N'ESP',  N'Hiszpania' 

COMMIT;
SET IDENTITY_INSERT [dbo].[Countries] OFF


GO


-- Języki
CREATE TABLE [dbo].[Languages] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [Name]			NVARCHAR (255)	NOT NULL UNIQUE
    , [Flag]			NVARCHAR (2)	NULL
    , [IsActive]		BIT				DEFAULT ((1)) NOT NULL
    , [OriginalName]	NVARCHAR (255)	NULL
    , CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED ([Id] ASC)
);

SET IDENTITY_INSERT [dbo].[Languages] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[Languages] ([Id], [Name], [Flag], [IsActive], [OriginalName])
SELECT 1,  N'polski',  N'pl', 1, N'Polski'  UNION ALL 
SELECT 2,  N'angielski',  N'uk', 1, N'English'  UNION ALL 
SELECT 3,  N'hiszpański',  N'es', 1, N'Español'  UNION ALL 
SELECT 4,  N'włoski',  N'it', 1, N'Italiano' 

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
    , CONSTRAINT [FK_Users_Country] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Countries] ([Id])
);

SET IDENTITY_INSERT [dbo].[Users] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[Users] ([Id], [Username], [Password], [FirstName], [LastName], [CountryId], [Email])
SELECT 1,  N'Mielnik',  N'haslo',  N'Tomasz',  N'Mielniczek', 1,  N'mielk@o2.pl' 

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
SELECT 1, N'boolean'  UNION ALL 
SELECT 2, N'radio'  UNION ALL 
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
SELECT 8, 2, N'Is place', 1, 0 UNION ALL 
SELECT 9, 1, N'Przypadek', 2, 0

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
INSERT INTO [dbo].[GrammarPropertyOptions] ([Id], [PropertyId], [Name], [Value], [Default])
SELECT 1, 1, N'męski', 1, 1 UNION ALL 
SELECT 2, 1, N'żeński', 2, 0 UNION ALL 
SELECT 3, 1, N'nijaki', 3, 0 UNION ALL 
SELECT 4, 2, N'pojedyncza', 1, 0 UNION ALL 
SELECT 5, 2, N'mnoga', 2, 0 UNION ALL 
SELECT 6, 2, N'obie liczby', 3, 1 UNION ALL 
SELECT 7, 3, N'osobowy', 1, 0 UNION ALL 
SELECT 8, 3, N'nieosobowy', 0, 1 UNION ALL 
SELECT 9, 7, N'miejsce', 1, 0 UNION ALL 
SELECT 10, 7, N'nie-miejsce', 0, 1 UNION ALL 
SELECT 11, 9, N'Mianownik', 0, 1 UNION ALL 
SELECT 12, 9, N'Dopełniacz', 1, 0 UNION ALL 
SELECT 13, 9, N'Celownik', 2, 0 UNION ALL 
SELECT 14, 9, N'Biernik', 3, 0 UNION ALL 
SELECT 15, 9, N'Narzędnik', 4, 0 UNION ALL 
SELECT 16, 9, N'Miejscownik', 5, 0 UNION ALL 
SELECT 17, 9, N'Wołacz', 6, 0 UNION ALL 
SELECT 18, 4, N'masculinum', 1, 0 UNION ALL 
SELECT 19, 4, N'femininum', 2, 0 UNION ALL 
SELECT 20, 4, N'neuter', 3, 1 UNION ALL 
SELECT 21, 5, N'only singular', 1, 0 UNION ALL 
SELECT 22, 5, N'only plural', 2, 0 UNION ALL 
SELECT 23, 5, N'both', 3, 1 UNION ALL 
SELECT 24, 6, N'person', 1, 0 UNION ALL 
SELECT 25, 6, N'non-person', 0, 1 UNION ALL 
SELECT 26, 8, N'place', 1, 0 UNION ALL 
SELECT 27, 8, N'non-place', 0, 1

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
SELECT 1, 1, 1, N'Header', 1, 0 UNION ALL 
SELECT 2, 1, 1, N'Liczba pojedyncza', 0, 1 UNION ALL 
SELECT 3, 1, 1, N'Liczba mnoga', 0, 2 UNION ALL 
SELECT 4, 2, 1, N'Header', 1, 0 UNION ALL 
SELECT 5, 2, 1, N'Forms', 0, 1 
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
SELECT 1, 1, N'To jest ...', 0 UNION ALL 
SELECT 2, 1, N'Nie ma ...', 1 UNION ALL 
SELECT 3, 1, N'Przyglądam się ...', 2 UNION ALL 
SELECT 4, 1, N'Widzę ...', 3 UNION ALL 
SELECT 5, 1, N'Porozmawiaj z  ...', 4 UNION ALL 
SELECT 6, 1, N'Porozmawiaj o ...', 5 UNION ALL 
SELECT 7, 1, N'!...', 6 UNION ALL 
SELECT 8, 1, N'Jadę ... (do)', 7 UNION ALL 
SELECT 9, 1, N'Jestem ...  (w)', 8 UNION ALL 
SELECT 10, 2, N'Mianownik pojedynczy', 0 UNION ALL 
SELECT 11, 2, N'Dopełniacz pojedynczy', 1 UNION ALL 
SELECT 12, 2, N'Celownik pojedynczy', 2 UNION ALL 
SELECT 13, 2, N'Biernik pojedynczy', 3 UNION ALL 
SELECT 14, 2, N'Narzędnik pojedynczy', 4 UNION ALL 
SELECT 15, 2, N'Miejscownik pojedynczy', 5 UNION ALL 
SELECT 16, 2, N'Wołacz pojedynczy', 6 UNION ALL 
SELECT 17, 2, N'Do', 7 UNION ALL 
SELECT 18, 2, N'W', 8 UNION ALL 
SELECT 19, 3, N'Mianownik mnogi', 0 UNION ALL 
SELECT 20, 3, N'Dopełniacz mnogi', 1 UNION ALL 
SELECT 21, 3, N'Celownik mnogi', 2 UNION ALL 
SELECT 22, 3, N'Biernik mnogi', 3 UNION ALL 
SELECT 23, 3, N'Narzędnik mnogi', 4 UNION ALL 
SELECT 24, 3, N'Miejscownik mnogi', 5 UNION ALL 
SELECT 25, 3, N'Wołacz mnogi', 6 UNION ALL 
SELECT 26, 4, N'article', 0 UNION ALL 
SELECT 27, 4, N'singular', 1 UNION ALL 
SELECT 28, 4, N'plural', 2 UNION ALL 
SELECT 29, 4, N'to ...', 3 UNION ALL 
SELECT 30, 4, N'in ...', 4 UNION ALL 
SELECT 31, 5, N'article', 0 UNION ALL 
SELECT 32, 5, N'singular', 1 UNION ALL 
SELECT 33, 5, N'plural', 2 UNION ALL 
SELECT 34, 5, N'to ...', 3 UNION ALL 
SELECT 35, 5, N'in ...', 4 
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
CREATE FUNCTION [dbo].[checkGrammarDefinitionLanguage] (@Id INT) 
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
	, [ValueId]			INT		NOT NULL
    , CONSTRAINT [PK_GrammarFormsDefinitionsProperties] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_GrammarFormsDefinitionsProperties_Definition] FOREIGN KEY ([DefinitionId]) REFERENCES [dbo].[GrammarFormsDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsDefinitionsProperties_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsDefinitionsProperties_Value] FOREIGN KEY ([ValueId]) REFERENCES [dbo].[GrammarPropertyOptions] ([Id])
	, CONSTRAINT [CH_GrammarFormsDefinitionsProperties_MatchedValueProperty] CHECK ([dbo].[checkGrammarOptionProperty]([ValueId]) = [PropertyId])
	, CONSTRAINT [U_GrammarFormsDefinitionsProperties_UniquePropertyDefinition] UNIQUE NONCLUSTERED ([DefinitionId] ASC, [PropertyId] ASC)
);

SET IDENTITY_INSERT [dbo].[GrammarFormsDefinitionsProperties] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[GrammarFormsDefinitionsProperties] ([Id], [DefinitionId], [PropertyId], [ValueId]) 
SELECT 1, 1, 9, 11 UNION ALL 
SELECT 2, 2, 9, 12 UNION ALL 
SELECT 3, 3, 9, 13 UNION ALL 
SELECT 4, 4, 9, 14 UNION ALL 
SELECT 5, 5, 9, 15 UNION ALL 
SELECT 6, 6, 9, 16 UNION ALL 
SELECT 7, 7, 9, 17 UNION ALL 
SELECT 8, 8, 7, 9 UNION ALL 
SELECT 9, 9, 7, 9 UNION ALL 
SELECT 10, 10, 2, 4 UNION ALL 
SELECT 11, 10, 9, 11 UNION ALL 
SELECT 12, 11, 2, 4 UNION ALL 
SELECT 13, 11, 9, 12 UNION ALL 
SELECT 14, 12, 2, 4 UNION ALL 
SELECT 15, 12, 9, 13 UNION ALL 
SELECT 16, 13, 2, 4 UNION ALL 
SELECT 17, 13, 9, 14 UNION ALL 
SELECT 18, 14, 2, 4 UNION ALL 
SELECT 19, 14, 9, 15 UNION ALL 
SELECT 20, 15, 2, 4 UNION ALL 
SELECT 21, 15, 9, 16 UNION ALL 
SELECT 22, 16, 2, 4 UNION ALL 
SELECT 23, 16, 9, 17 UNION ALL 
SELECT 24, 17, 7, 9 UNION ALL 
SELECT 25, 18, 7, 9 UNION ALL 
SELECT 26, 19, 2, 5 UNION ALL 
SELECT 27, 19, 9, 11 UNION ALL 
SELECT 28, 20, 2, 5 UNION ALL 
SELECT 29, 20, 9, 12 UNION ALL 
SELECT 30, 21, 2, 5 UNION ALL 
SELECT 31, 21, 9, 13 UNION ALL 
SELECT 32, 22, 2, 5 UNION ALL 
SELECT 33, 22, 9, 14 UNION ALL 
SELECT 34, 23, 2, 5 UNION ALL 
SELECT 35, 23, 9, 15 UNION ALL 
SELECT 36, 24, 2, 5 UNION ALL 
SELECT 37, 24, 9, 16 UNION ALL 
SELECT 38, 25, 2, 5 UNION ALL 
SELECT 39, 25, 9, 17 UNION ALL 
SELECT 40, 26, 5, 21 UNION ALL 
SELECT 41, 27, 5, 21 UNION ALL 
SELECT 42, 28, 5, 22 UNION ALL 
SELECT 43, 29, 8, 26 UNION ALL 
SELECT 44, 30, 8, 26 UNION ALL 
SELECT 45, 31, 5, 21 UNION ALL 
SELECT 46, 32, 5, 21 UNION ALL 
SELECT 47, 33, 5, 22 UNION ALL 
SELECT 48, 34, 8, 26 UNION ALL 
SELECT 49, 35, 8, 26 
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
	, [ValueId]				INT		NOT NULL
	, CONSTRAINT [PK_GrammarFormsInactiveRules] PRIMARY KEY CLUSTERED ([Id] ASC)
	, CONSTRAINT [FK_GrammarFormsInactiveRules_Definition] FOREIGN KEY ([DefinitionId]) REFERENCES [dbo].[GrammarFormsDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsInactiveRules_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
	, CONSTRAINT [FK_GrammarFormsInactiveRules_Value] FOREIGN KEY ([ValueId]) REFERENCES [dbo].[GrammarPropertyOptions] ([Id])
	, CONSTRAINT [CH_GrammarFormsInactiveRules_MatchedValueProperty] CHECK ([dbo].[checkGrammarOptionProperty]([ValueId]) = [PropertyId])
	, CONSTRAINT [U_GrammarFormsInactiveRules_UniqueDefinitionPropertyValue] UNIQUE NONCLUSTERED ([DefinitionId] ASC, [PropertyId] ASC, [ValueId] ASC)
);

SET IDENTITY_INSERT [dbo].[GrammarFormsInactiveRules] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[GrammarFormsInactiveRules] ([Id], [DefinitionId], [PropertyId], [ValueId])
SELECT 1, 10, 2, 5 UNION ALL 
SELECT 2, 11, 2, 5 UNION ALL 
SELECT 3, 12, 2, 5 UNION ALL 
SELECT 4, 13, 2, 5 UNION ALL 
SELECT 5, 14, 2, 5 UNION ALL 
SELECT 6, 15, 2, 5 UNION ALL 
SELECT 7, 16, 2, 5 UNION ALL 
SELECT 8, 17, 7, 10 UNION ALL 
SELECT 9, 18, 7, 10 UNION ALL 
SELECT 10, 19, 2, 4 UNION ALL 
SELECT 11, 20, 2, 4 UNION ALL 
SELECT 12, 21, 2, 4 UNION ALL 
SELECT 13, 22, 2, 4 UNION ALL 
SELECT 14, 23, 2, 4 UNION ALL 
SELECT 15, 24, 2, 4 UNION ALL 
SELECT 16, 25, 2, 4 UNION ALL 
SELECT 17, 31, 5, 22 UNION ALL 
SELECT 18, 32, 5, 22 UNION ALL 
SELECT 19, 33, 5, 21 UNION ALL 
SELECT 20, 34, 8, 27 UNION ALL 
SELECT 21, 35, 8, 27 
COMMIT;
SET IDENTITY_INSERT [dbo].[GrammarFormsInactiveRules] OFF


GO


-- Właściwości wymagane dla danego typu wyrazów (np. określa, że rzeczowniki mają mieć zdefiniowany rodzaj i dostępne liczby).
CREATE TABLE [dbo].[WordRequiredProperties] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [LanguageId]		INT				NOT NULL
    , [WordtypeId]		INT             NOT NULL
    , [PropertyId]		INT				NOT NULL
    , CONSTRAINT [PK_WordRequiredProperties] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_WordtypeRequired_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_WordtypeRequired_Wordtype] FOREIGN KEY ([WordtypeId]) REFERENCES [dbo].[WordTypes] ([Id])
    , CONSTRAINT [FK_WordtypeRequired_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
    , CONSTRAINT [U_WordtypeRequired_LanguageWordtypeProperty] UNIQUE NONCLUSTERED ([LanguageId] ASC, [WordtypeId] ASC, [PropertyId] ASC)
    , CONSTRAINT [CH_WordtypeRequired_LanguageMatched] CHECK ([LanguageId] = [dbo].[checkGrammarDefinitionLanguage]([PropertyId]))
);
SET IDENTITY_INSERT [dbo].[WordRequiredProperties] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[WordRequiredProperties] ([Id], [LanguageId], [WordtypeId], [PropertyId])
SELECT 1, 1, 1, 1 UNION ALL 
SELECT 2, 1, 1, 2 UNION ALL 
SELECT 3, 1, 1, 3 UNION ALL 
SELECT 4, 1, 1, 7 UNION ALL 
SELECT 5, 2, 1, 4 UNION ALL 
SELECT 6, 2, 1, 5 UNION ALL 
SELECT 7, 2, 1, 6 UNION ALL 
SELECT 8, 2, 1, 8

COMMIT;
SET IDENTITY_INSERT [dbo].[WordRequiredProperties] OFF

GO



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
SET IDENTITY_INSERT [dbo].[VariantDependenciesDefinitions] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[VariantDependenciesDefinitions] ([Id], [LanguageId], [MasterWordtypeId], [SlaveWordtypeId])
SELECT 1, 1, 1, 2 UNION ALL 
SELECT 2, 1, 1, 3 UNION ALL 
SELECT 3, 1, 1, 5 
COMMIT;
SET IDENTITY_INSERT [dbo].[VariantDependenciesDefinitions] OFF




GO




-- Kategorie
CREATE TABLE [dbo].[Categories] (
      [Id]         INT            IDENTITY (1, 1) NOT NULL
    , [Name]       NVARCHAR (255) NOT NULL UNIQUE
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
SELECT 4, N'Państwa - Europa', 3 UNION ALL 
SELECT 5, N'Państwa - Ameryka Północna', 3 UNION ALL 
SELECT 6, N'Państwa - Ameryka Południowa', 3 UNION ALL 
SELECT 7, N'Państwa - Afryka', 3 UNION ALL 
SELECT 8, N'Państwa - Azja', 3 UNION ALL 
SELECT 9, N'Państwa - Oceania', 3 UNION ALL 
SELECT 10, N'Miasta', 2 UNION ALL 
SELECT 11, N'Akweny', 2 UNION ALL 
SELECT 12, N'Góry', 2 UNION ALL 
SELECT 13, N'Morza', 11 UNION ALL 
SELECT 14, N'Przyroda', 1 UNION ALL 
SELECT 15, N'Rośliny', 14 UNION ALL 
SELECT 16, N'Zwierzęta', 14 UNION ALL 
SELECT 17, N'Zwierzęta - Ptaki', 16 UNION ALL 
SELECT 18, N'Zwierzęta - Domowe', 16 UNION ALL 
SELECT 19, N'Zwierzęta - Gospodarcze', 16 UNION ALL 
SELECT 20, N'Zwierzęta - Ryby', 16 UNION ALL 
SELECT 21, N'Zwierzęta - Owady', 16 UNION ALL 
SELECT 22, N'Zwierzęta - Płazy i gady', 16 UNION ALL 
SELECT 23, N'Zwierzęta - Egzotyczne', 16 UNION ALL 
SELECT 24, N'Rośliny - Owoce', 15 UNION ALL 
SELECT 25, N'Rośliny - Warzywa', 15 UNION ALL 
SELECT 26, N'Rośliny - Drzewa', 15 UNION ALL 
SELECT 27, N'Osoby', 1 UNION ALL 
SELECT 28, N'Profesje', 27 UNION ALL 
SELECT 29, N'Narodowości', 27 UNION ALL 
SELECT 30, N'Rodzina', 27 UNION ALL 
SELECT 41, N'Kontynenty', 2 UNION ALL 
SELECT 42, N'Wyspy', 2 UNION ALL 
SELECT 43, N'Krainy', 2 UNION ALL 
SELECT 44, N'Krainy - Europa', 43 UNION ALL 
SELECT 45, N'Krainy - Ameryka', 43 UNION ALL 
SELECT 46, N'Krainy - Azja', 43 UNION ALL 
SELECT 47, N'Krainy - Afryka', 43 UNION ALL 
SELECT 48, N'Kolory', 1 UNION ALL 
SELECT 49, N'Czas', 1 UNION ALL 
SELECT 50, N'Dni tygodnia i miesiące', 49 UNION ALL 
SELECT 51, N'Jednostki czasu', 49 UNION ALL 
SELECT 52, N'Społeczeństwo', 1 UNION ALL 
SELECT 53, N'Środowisko', 1 UNION ALL 
SELECT 54, N'Komunikacja', 1 UNION ALL 
SELECT 55, N'Dom', 1 UNION ALL 
SELECT 56, N'Dom - kuchnia', 57 UNION ALL 
SELECT 57, N'Dom - łazienka', 57 UNION ALL 
SELECT 58, N'Dom - pokój', 57 UNION ALL 
SELECT 59, N'Komunikacja - Media', 54 UNION ALL 
SELECT 60, N'Komunikacja - Transport', 54 UNION ALL 
SELECT 61, N'Człowiek', 1 UNION ALL 
SELECT 62, N'Instytucje', 52 UNION ALL 
SELECT 63, N'Obiekty topograficzne', 54 UNION ALL 
SELECT 64, N'Budynki', 54 UNION ALL 
SELECT 65, N'Rozrywka', 1 UNION ALL 
SELECT 66, N'Sport', 66 UNION ALL 
SELECT 67, N'Sztuka', 66 UNION ALL 
SELECT 68, N'Zabawa', 66 UNION ALL 
SELECT 69, N'Rzeki', 11 UNION ALL 
SELECT 70, N'Jeziora', 11 UNION ALL 
SELECT 71, N'Jedzenie', 1 UNION ALL 
SELECT 72, N'Przedmioty', 1 UNION ALL 
SELECT 73, N'Przedmioty - warsztat', 72 UNION ALL 
SELECT 74, N'Przedmioty - szkoła', 72 UNION ALL 
SELECT 75, N'Człowiek - części ciała', 61 UNION ALL 
SELECT 76, N'Człowiek - uczucia', 61 UNION ALL 
SELECT 77, N'Komunikacja - Informacje', 54 UNION ALL 
SELECT 78, N'Nagrody', 65 UNION ALL 
SELECT 79, N'Prawo', 65 UNION ALL 
SELECT 80, N'Prawo - przestępstwa', 65 UNION ALL 
SELECT 81, N'Zwierzęta - gryzonie', 16 
COMMIT;
SET IDENTITY_INSERT [dbo].[Categories] OFF

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

SET IDENTITY_INSERT [dbo].[Metawords] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[Metawords] ([Id], [Name], [Type], [Weight])
SELECT 1, N'Polska', 1, 10 UNION ALL 
SELECT 2, N'pies', 1, 10 UNION ALL 
SELECT 3, N'Włochy', 1, 10 UNION ALL 
SELECT 4, N'Hiszpania', 1, 10 UNION ALL 
SELECT 5, N'Francja', 1, 10 UNION ALL 
SELECT 6, N'Niemcy', 1, 10 UNION ALL 
SELECT 7, N'Anglia', 1, 10 UNION ALL 
SELECT 8, N'Rosja', 1, 10 UNION ALL 
SELECT 9, N'Albania', 1, 6 UNION ALL 
SELECT 10, N'Andora', 1, 2 UNION ALL 
SELECT 11, N'Armenia', 1, 5 UNION ALL 
SELECT 12, N'Austria', 1, 8 UNION ALL 
SELECT 13, N'Azerbejdżan', 1, 5 UNION ALL 
SELECT 14, N'Białoruś', 1, 5 UNION ALL 
SELECT 15, N'Belgia', 1, 8 UNION ALL 
SELECT 16, N'Bośnia i Hercegowina', 1, 5 UNION ALL 
SELECT 17, N'Bułgaria', 1, 7 UNION ALL 
SELECT 18, N'Chorwacja', 1, 7 UNION ALL 
SELECT 19, N'Cypr', 1, 6 UNION ALL 
SELECT 20, N'Czechy', 1, 9 UNION ALL 
SELECT 21, N'Dania', 1, 9 UNION ALL 
SELECT 22, N'Estonia', 1, 6 UNION ALL 
SELECT 23, N'Finlandia', 1, 8 UNION ALL 
SELECT 24, N'Gruzja', 1, 5 UNION ALL 
SELECT 25, N'Grecja', 1, 9 UNION ALL 
SELECT 26, N'Węgry', 1, 8 UNION ALL 
SELECT 27, N'Islandia', 1, 6 UNION ALL 
SELECT 28, N'Irlandia', 1, 7 UNION ALL 
SELECT 29, N'Kazachstan', 1, 5 UNION ALL 
SELECT 30, N'Łotwa', 1, 5 UNION ALL 
SELECT 31, N'Liechtenstein', 1, 2 UNION ALL 
SELECT 32, N'Litwa', 1, 6 UNION ALL 
SELECT 33, N'Luksemburg', 1, 6 UNION ALL 
SELECT 34, N'Macedonia', 1, 5 UNION ALL 
SELECT 35, N'Malta', 1, 6 UNION ALL 
SELECT 36, N'Mołdawia', 1, 4 UNION ALL 
SELECT 37, N'Monako', 1, 3 UNION ALL 
SELECT 38, N'Czarnogóra', 1, 6 UNION ALL 
SELECT 39, N'Holandia', 1, 10 UNION ALL 
SELECT 40, N'Norwegia', 1, 9 UNION ALL 
SELECT 41, N'Portugalia', 1, 9 UNION ALL 
SELECT 42, N'Rumunia', 1, 8 UNION ALL 
SELECT 43, N'San Marino', 1, 2 UNION ALL 
SELECT 44, N'Serbia', 1, 7 UNION ALL 
SELECT 45, N'Słowacja', 1, 7 UNION ALL 
SELECT 46, N'Słowenia', 1, 6 UNION ALL 
SELECT 47, N'Szwecja', 1, 9 UNION ALL 
SELECT 48, N'Szwajcaria', 1, 10 UNION ALL 
SELECT 49, N'Turcja', 1, 9 UNION ALL 
SELECT 50, N'Ukraina', 1, 9 UNION ALL 
SELECT 51, N'Wielka Brytania', 1, 9 UNION ALL 
SELECT 52, N'Watykan', 1, 2 UNION ALL 
SELECT 53, N'Szkocja', 1, 6 UNION ALL 
SELECT 54, N'Brazylia', 1, 10 UNION ALL 
SELECT 55, N'Argentyna', 1, 9 UNION ALL 
SELECT 56, N'Peru', 1, 6 UNION ALL 
SELECT 57, N'Boliwia', 1, 5 UNION ALL 
SELECT 58, N'Chile', 1, 6 UNION ALL 
SELECT 59, N'Kolumbia', 1, 8 UNION ALL 
SELECT 60, N'Wenezuela', 1, 7 UNION ALL 
SELECT 61, N'Urugwaj', 1, 6 UNION ALL 
SELECT 62, N'Paragwaj', 1, 6 UNION ALL 
SELECT 63, N'Ekwador', 1, 6 UNION ALL 
SELECT 64, N'Chiny', 1, 10 UNION ALL 
SELECT 65, N'Japonia', 1, 10 UNION ALL 
SELECT 66, N'Indie', 1, 10 UNION ALL 
SELECT 67, N'Tajlandia', 1, 9 UNION ALL 
SELECT 68, N'Izrael', 1, 8 UNION ALL 
SELECT 69, N'Liban', 1, 6 UNION ALL 
SELECT 70, N'Jordania', 1, 5 UNION ALL 
SELECT 71, N'Syria', 1, 6 UNION ALL 
SELECT 72, N'Arabia Saudyjska', 1, 8 UNION ALL 
SELECT 73, N'Jemen', 1, 5 UNION ALL 
SELECT 74, N'Oman', 1, 5 UNION ALL 
SELECT 75, N'Zjednoczone Emiraty Arabskie', 1, 8 UNION ALL 
SELECT 76, N'Kuwejt', 1, 8 UNION ALL 
SELECT 77, N'Bahrajn', 1, 5 UNION ALL 
SELECT 78, N'Katar', 1, 7 UNION ALL 
SELECT 79, N'Irak', 1, 9 UNION ALL 
SELECT 80, N'Iran', 1, 9 UNION ALL 
SELECT 81, N'Afganistan', 1, 8 UNION ALL 
SELECT 82, N'Pakistan', 1, 8 UNION ALL 
SELECT 83, N'Uzbekistan', 1, 6 UNION ALL 
SELECT 84, N'Turkmenistan', 1, 3 UNION ALL 
SELECT 85, N'Tadżykistan', 1, 2 UNION ALL 
SELECT 86, N'Kirgistan', 1, 2 UNION ALL 
SELECT 87, N'Nepal', 1, 5 UNION ALL 
SELECT 88, N'Bhutan', 1, 2 UNION ALL 
SELECT 89, N'Bangladesz', 1, 4 UNION ALL 
SELECT 90, N'Sri Lanka', 1, 4 UNION ALL 
SELECT 91, N'Mongolia', 1, 5 UNION ALL 
SELECT 92, N'Laos', 1, 3 UNION ALL 
SELECT 93, N'Kambodża', 1, 4 UNION ALL 
SELECT 94, N'Wietnam', 1, 6 UNION ALL 
SELECT 95, N'Myanmar', 1, 2 UNION ALL 
SELECT 96, N'Korea Południowa', 1, 10 UNION ALL 
SELECT 97, N'Korea Północna', 1, 9 UNION ALL 
SELECT 98, N'Malezja', 1, 7 UNION ALL 
SELECT 99, N'Indonezja', 1, 7 UNION ALL 
SELECT 100, N'Filipiny', 1, 7 UNION ALL 
SELECT 101, N'Tajwan', 1, 8 UNION ALL 
SELECT 102, N'Hongkong', 1, 8 UNION ALL 
SELECT 103, N'Singapur', 1, 7 UNION ALL 
SELECT 104, N'Australia', 1, 10 UNION ALL 
SELECT 105, N'Nowa Zelandia', 1, 10 UNION ALL 
SELECT 106, N'Fidżi', 1, 6 UNION ALL 
SELECT 107, N'Egipt', 1, 10 UNION ALL 
SELECT 108, N'Libia', 1, 8 UNION ALL 
SELECT 109, N'Tunezja', 1, 9 UNION ALL 
SELECT 110, N'Maroko', 1, 10 UNION ALL 
SELECT 111, N'Algieria', 1, 8 UNION ALL 
SELECT 112, N'Sudan', 1, 7 UNION ALL 
SELECT 113, N'Etiopia', 1, 8 UNION ALL 
SELECT 114, N'Erytrea', 1, 2 UNION ALL 
SELECT 115, N'Dżibuti', 1, 2 UNION ALL 
SELECT 116, N'Czad', 1, 2 UNION ALL 
SELECT 117, N'Mauretania', 1, 2 UNION ALL 
SELECT 118, N'Burkina Faso', 1, 3 UNION ALL 
SELECT 119, N'Mali', 1, 4 UNION ALL 
SELECT 120, N'Senegal', 1, 8 UNION ALL 
SELECT 121, N'Gambia', 1, 2 UNION ALL 
SELECT 122, N'Gwinea', 1, 3 UNION ALL 
SELECT 123, N'Ghana', 1, 5 UNION ALL 
SELECT 124, N'Somalia', 1, 7 UNION ALL 
SELECT 125, N'Wybrzeże Kości Słoniowej', 1, 6 UNION ALL 
SELECT 126, N'Togo', 1, 3 UNION ALL 
SELECT 127, N'Liberia', 1, 4 UNION ALL 
SELECT 128, N'Sierra Leone', 1, 3 UNION ALL 
SELECT 129, N'Niger', 1, 3 UNION ALL 
SELECT 130, N'Nigeria', 1, 9 UNION ALL 
SELECT 131, N'Kamerun', 1, 8 UNION ALL 
SELECT 132, N'Gabon', 1, 7 UNION ALL 
SELECT 133, N'Kongo', 1, 8 UNION ALL 
SELECT 134, N'Demokratyczna Republika Konga', 1, 3 UNION ALL 
SELECT 135, N'Uganda', 1, 4 UNION ALL 
SELECT 136, N'Burundi', 1, 1 UNION ALL 
SELECT 137, N'Kenia', 1, 8 UNION ALL 
SELECT 138, N'Tanzania', 1, 6 UNION ALL 
SELECT 139, N'Mozambik', 1, 5 UNION ALL 
SELECT 140, N'Ruanda', 1, 3 UNION ALL 
SELECT 141, N'Madagaskar', 1, 7 UNION ALL 
SELECT 142, N'Angola', 1, 5 UNION ALL 
SELECT 143, N'Namibia', 1, 3 UNION ALL 
SELECT 144, N'RPA', 1, 9 UNION ALL 
SELECT 145, N'Zambia', 1, 7 UNION ALL 
SELECT 146, N'Zimbabwe', 1, 7 UNION ALL 
SELECT 147, N'Botswana', 1, 2 UNION ALL 
SELECT 148, N'Seszele', 1, 7 UNION ALL 
SELECT 149, N'Mauritius', 1, 8 UNION ALL 
SELECT 150, N'USA', 1, 10 UNION ALL 
SELECT 151, N'Kanada', 1, 10 UNION ALL 
SELECT 152, N'Meksyk', 1, 10 UNION ALL 
SELECT 153, N'Grenlandia', 1, 8 UNION ALL 
SELECT 154, N'Jamajka', 1, 9 UNION ALL 
SELECT 155, N'Kuba', 1, 10 UNION ALL 
SELECT 156, N'Honduras', 1, 6 UNION ALL 
SELECT 157, N'Salwador', 1, 6 UNION ALL 
SELECT 158, N'Gwatemala', 1, 6 UNION ALL 
SELECT 159, N'Nikaragua', 1, 6 UNION ALL 
SELECT 160, N'Panama', 1, 7 UNION ALL 
SELECT 161, N'Dominikana', 1, 8 UNION ALL 
SELECT 162, N'Haiti', 1, 7 UNION ALL 
SELECT 163, N'Portoryko', 1, 7 UNION ALL 
SELECT 164, N'Kostaryka', 1, 7 UNION ALL 
SELECT 165, N'Belize', 1, 3 UNION ALL 
SELECT 166, N'Bahamy', 1, 5 UNION ALL 
SELECT 167, N'Europa', 1, 10 UNION ALL 
SELECT 168, N'Ameryka Południowa', 1, 10 UNION ALL 
SELECT 169, N'Ameryka Północna', 1, 10 UNION ALL 
SELECT 170, N'Afryka', 1, 10 UNION ALL 
SELECT 171, N'Azja', 1, 10 UNION ALL 
SELECT 172, N'Oceania', 1, 10 UNION ALL 
SELECT 173, N'Skandynawia', 1, 9 UNION ALL 
SELECT 174, N'Kaukaz', 1, 9 UNION ALL 
SELECT 175, N'Karaiby', 1, 9 UNION ALL 
SELECT 176, N'kot', 1, 10 UNION ALL 
SELECT 177, N'chomik', 1, 8 UNION ALL 
SELECT 178, N'krowa', 1, 9 UNION ALL 
SELECT 179, N'koń', 1, 10 UNION ALL 
SELECT 180, N'mucha', 1, 9 UNION ALL 
SELECT 181, N'pszczoła', 1, 9 UNION ALL 
SELECT 182, N'osa', 1, 7 UNION ALL 
SELECT 183, N'komar', 1, 8 UNION ALL 
SELECT 184, N'żaba', 1, 8 UNION ALL 
SELECT 185, N'ptak', 1, 10 UNION ALL 
SELECT 186, N'ryba', 1, 10 UNION ALL 
SELECT 187, N'bocian', 1, 7 UNION ALL 
SELECT 188, N'wróbel', 1, 6 UNION ALL 
SELECT 189, N'motyl', 1, 10 UNION ALL 
SELECT 190, N'małpa', 1, 10 UNION ALL 
SELECT 191, N'słoń', 1, 10 UNION ALL 
SELECT 192, N'lew', 1, 10 UNION ALL 
SELECT 193, N'żyrafa', 1, 10 UNION ALL 
SELECT 194, N'wielbłąd', 1, 10 UNION ALL 
SELECT 195, N'tygrys', 1, 10 UNION ALL 
SELECT 196, N'wąż', 1, 10 UNION ALL 
SELECT 197, N'rekin', 1, 9 UNION ALL 
SELECT 198, N'wieloryb', 1, 7 UNION ALL 
SELECT 199, N'osioł', 1, 8 UNION ALL 
SELECT 200, N'owca', 1, 9 UNION ALL 
SELECT 201, N'gołąb', 1, 7 UNION ALL 
SELECT 202, N'sokół', 1, 8 UNION ALL 
SELECT 203, N'orzeł', 1, 10 UNION ALL 
SELECT 204, N'jastrząb', 1, 8 UNION ALL 
SELECT 205, N'Andy', 1, 10 UNION ALL 
SELECT 206, N'Himalaje', 1, 10 UNION ALL 
SELECT 207, N'Alpy', 1, 10 UNION ALL 
SELECT 208, N'Morze Śródziemne', 1, 10 UNION ALL 
SELECT 209, N'Ocean Atlantycki', 1, 10 UNION ALL 
SELECT 210, N'Ocean Spokojny', 1, 10 UNION ALL 
SELECT 211, N'Ocean Indyjski', 1, 10 UNION ALL 
SELECT 212, N'Zatoka Perska', 1, 8 UNION ALL 
SELECT 213, N'Morze Bałtyckie', 1, 10 UNION ALL 
SELECT 214, N'Sardynia', 1, 10 UNION ALL 
SELECT 215, N'Sycylia', 1, 10 UNION ALL 
SELECT 216, N'czarny', 3, 10 UNION ALL 
SELECT 217, N'biały', 3, 10 UNION ALL 
SELECT 218, N'zielony', 3, 10 UNION ALL 
SELECT 219, N'czerwony', 3, 10 UNION ALL 
SELECT 220, N'żółty', 3, 10 UNION ALL 
SELECT 221, N'brązowy', 3, 10 UNION ALL 
SELECT 222, N'niebieski', 3, 10 UNION ALL 
SELECT 223, N'różowy', 3, 10 UNION ALL 
SELECT 224, N'pomarańczowy', 3, 10 UNION ALL 
SELECT 225, N'szary', 3, 10 UNION ALL 
SELECT 226, N'poniedziałek', 1, 10 UNION ALL 
SELECT 227, N'wtorek', 1, 10 UNION ALL 
SELECT 228, N'środa', 1, 10 UNION ALL 
SELECT 229, N'czwartek', 1, 10 UNION ALL 
SELECT 230, N'piątek', 1, 10 UNION ALL 
SELECT 231, N'sobota', 1, 10 UNION ALL 
SELECT 232, N'niedziela', 1, 10 UNION ALL 
SELECT 233, N'styczeń', 1, 10 UNION ALL 
SELECT 234, N'luty', 1, 10 UNION ALL 
SELECT 235, N'marzec', 1, 10 UNION ALL 
SELECT 236, N'kwiecień', 1, 10 UNION ALL 
SELECT 237, N'maj', 1, 10 UNION ALL 
SELECT 238, N'czerwiec', 1, 10 UNION ALL 
SELECT 239, N'lipiec', 1, 10 UNION ALL 
SELECT 240, N'sierpień', 1, 10 UNION ALL 
SELECT 241, N'wrzesień', 1, 10 UNION ALL 
SELECT 242, N'październik', 1, 10 UNION ALL 
SELECT 243, N'listopad', 1, 10 UNION ALL 
SELECT 244, N'grudzień', 1, 10 UNION ALL 
SELECT 245, N'rok', 1, 10 UNION ALL 
SELECT 246, N'miesiąc', 1, 10 UNION ALL 
SELECT 247, N'dzień', 1, 10 UNION ALL 
SELECT 248, N'tydzień', 1, 10 UNION ALL 
SELECT 249, N'godzina', 1, 10 UNION ALL 
SELECT 250, N'minuta', 1, 10 UNION ALL 
SELECT 251, N'sekunda', 1, 10 UNION ALL 
SELECT 252, N'weekend', 1, 8 UNION ALL 
SELECT 253, N'jutro', 1, 10 UNION ALL 
SELECT 254, N'dzisiaj', 1, 10 UNION ALL 
SELECT 255, N'wczoraj', 1, 10 UNION ALL 
SELECT 256, N'żółw', 1, 10 UNION ALL 
SELECT 257, N'krokodyl', 1, 8 UNION ALL 
SELECT 258, N'kangur', 1, 8 UNION ALL 
SELECT 259, N'gad', 1, 9 UNION ALL 
SELECT 260, N'płaz', 1, 9 UNION ALL 
SELECT 261, N'ssak', 1, 9 UNION ALL 
SELECT 262, N'robak', 1, 10 UNION ALL 
SELECT 263, N'owad', 1, 10 UNION ALL 
SELECT 264, N'jabłko', 1, 10 UNION ALL 
SELECT 265, N'gruszka', 1, 10 UNION ALL 
SELECT 266, N'wiśnia', 1, 10 UNION ALL 
SELECT 267, N'truskawka', 1, 10 UNION ALL 
SELECT 268, N'ananas', 1, 9 UNION ALL 
SELECT 269, N'pomarańcza', 1, 10 UNION ALL 
SELECT 270, N'czereśnia', 1, 7 UNION ALL 
SELECT 271, N'porzeczka', 1, 7 UNION ALL 
SELECT 272, N'malina', 1, 9 UNION ALL 
SELECT 273, N'banan', 1, 10 UNION ALL 
SELECT 274, N'robić', 2, 10 UNION ALL 
SELECT 275, N'polski', 3, 10 UNION ALL 
SELECT 276, N'ręka', 1, 10 UNION ALL 
SELECT 277, N'płacić', 2, 10 UNION ALL 
SELECT 278, N'szybki', 3, 10 UNION ALL 
SELECT 279, N'mówić', 2, 10 UNION ALL 
SELECT 280, N'czytać', 2, 10 UNION ALL 
SELECT 281, N'być', 2, 10 UNION ALL 
SELECT 282, N'móc', 2, 10 UNION ALL 
SELECT 283, N'zdobywać', 2, 10 UNION ALL 
SELECT 284, N'próbować', 2, 10 UNION ALL 
SELECT 285, N'książka', 1, 10 UNION ALL 
SELECT 286, N'gra', 1, 10 UNION ALL 
SELECT 287, N'produkt', 1, 10 UNION ALL 
SELECT 288, N'samochód', 1, 10 UNION ALL 
SELECT 289, N'oprogramowanie', 1, 1 UNION ALL 
SELECT 290, N'gubić', 2, 10 UNION ALL 
SELECT 291, N'golić', 2, 8 UNION ALL 
SELECT 292, N'spóźnić', 2, 9 UNION ALL 
SELECT 293, N'poparzyć', 2, 9 UNION ALL 
SELECT 294, N'dowiadywać', 2, 9 UNION ALL 
SELECT 295, N'przeziębić', 2, 7 UNION ALL 
SELECT 296, N'odkręcać', 2, 8 UNION ALL 
SELECT 297, N'zawiązywać', 2, 8 UNION ALL 
SELECT 298, N'nazywać', 2, 8 UNION ALL 
SELECT 299, N'mieć', 2, 10 UNION ALL 
SELECT 300, N'musieć', 2, 10 UNION ALL 
SELECT 301, N'zauważyć', 2, 10 UNION ALL 
SELECT 302, N'popełniać', 2, 10 UNION ALL 
SELECT 303, N'rozmawiać', 2, 10 UNION ALL 
SELECT 304, N'odzyskiwać', 2, 10 UNION ALL 
SELECT 305, N'chcieć', 2, 10 UNION ALL 
SELECT 306, N'dotykać', 2, 10 UNION ALL 
SELECT 307, N'telewizja', 1, 10 UNION ALL 
SELECT 308, N'internet', 1, 10 UNION ALL 
SELECT 309, N'prasa', 1, 10 UNION ALL 
SELECT 310, N'szukać', 2, 10 UNION ALL 
SELECT 311, N'spać', 2, 10 UNION ALL 
SELECT 312, N'rozpoznawać', 2, 10 UNION ALL 
SELECT 313, N'hotel', 1, 10 UNION ALL 
SELECT 314, N'prąd', 1, 10 UNION ALL 
SELECT 315, N'telefon', 1, 10 UNION ALL 
SELECT 316, N'ogrzewanie', 1, 8 UNION ALL 
SELECT 317, N'woda', 1, 10 UNION ALL 
SELECT 318, N'gaz', 1, 10 UNION ALL 
SELECT 319, N'samolot', 1, 10 UNION ALL 
SELECT 320, N'pociąg', 1, 10 UNION ALL 
SELECT 321, N'autobus', 1, 10 UNION ALL 
SELECT 322, N'lekcja', 1, 10 UNION ALL 
SELECT 323, N'dochodzić', 2, 10 UNION ALL 
SELECT 324, N'dostawać', 2, 10 UNION ALL 
SELECT 325, N'pracować', 2, 10 UNION ALL 
SELECT 326, N'słuchać', 2, 10 UNION ALL 
SELECT 327, N'jeździć', 2, 10 UNION ALL 
SELECT 328, N'mieszkać', 2, 10 UNION ALL 
SELECT 329, N'parkować', 2, 8 UNION ALL 
SELECT 330, N'zarabiać', 2, 10 UNION ALL 
SELECT 331, N'biegać', 2, 10 UNION ALL 
SELECT 332, N'wychodzić', 2, 10 UNION ALL 
SELECT 333, N'dotrzeć', 2, 10 UNION ALL 
SELECT 334, N'wyławiać', 2, 8 UNION ALL 
SELECT 335, N'zajmować', 2, 10 UNION ALL 
SELECT 336, N'stawiać', 2, 10 UNION ALL 
SELECT 337, N'dawać', 2, 10 UNION ALL 
SELECT 338, N'wyglądać', 2, 10 UNION ALL 
SELECT 339, N'morze', 1, 10 UNION ALL 
SELECT 340, N'jezioro', 1, 10 UNION ALL 
SELECT 341, N'plaża', 1, 10 UNION ALL 
SELECT 342, N'sam', 3, 10 UNION ALL 
SELECT 343, N'zdążyć', 2, 10 UNION ALL 
SELECT 344, N'słyszeć', 2, 10 UNION ALL 
SELECT 345, N'czuć', 2, 10 UNION ALL 
SELECT 346, N'oczekiwać', 2, 10 UNION ALL 
SELECT 347, N'informować', 2, 10 UNION ALL 
SELECT 348, N'uczyć', 2, 10 UNION ALL 
SELECT 349, N'angielski', 3, 10 UNION ALL 
SELECT 350, N'hiszpański', 3, 10 UNION ALL 
SELECT 351, N'francuski', 3, 10 UNION ALL 
SELECT 352, N'rosyjski', 3, 10 UNION ALL 
SELECT 353, N'włoski', 3, 10 UNION ALL 
SELECT 354, N'portugalski', 3, 10 UNION ALL 
SELECT 355, N'arabski', 3, 10 UNION ALL 
SELECT 356, N'japoński', 3, 10 UNION ALL 
SELECT 357, N'chiński', 3, 10 UNION ALL 
SELECT 358, N'czeski', 3, 7 UNION ALL 
SELECT 359, N'reagować', 2, 10 UNION ALL 
SELECT 360, N'płakać', 2, 10 UNION ALL 
SELECT 361, N'myśleć', 2, 10 UNION ALL 
SELECT 362, N'zachowywać', 2, 10 UNION ALL 
SELECT 363, N'ładny', 3, 10 UNION ALL 
SELECT 364, N'gruziński', 3, 7 UNION ALL 
SELECT 365, N'koreański', 3, 8 UNION ALL 
SELECT 366, N'wietnamski', 3, 7 UNION ALL 
SELECT 367, N'grecki', 3, 8 UNION ALL 
SELECT 368, N'bułgarski', 3, 7 UNION ALL 
SELECT 369, N'albański', 3, 6 UNION ALL 
SELECT 370, N'chorwacki', 3, 8 UNION ALL 
SELECT 371, N'szwajcarski', 3, 10 UNION ALL 
SELECT 372, N'austriacki', 3, 8 UNION ALL 
SELECT 373, N'australijski', 3, 10 UNION ALL 
SELECT 374, N'meksykański', 3, 9 UNION ALL 
SELECT 375, N'brazylijski', 3, 10 UNION ALL 
SELECT 376, N'argentyński', 3, 8 UNION ALL 
SELECT 377, N'kolumbijski', 3, 6 UNION ALL 
SELECT 378, N'kanadyjski', 3, 10 UNION ALL 
SELECT 379, N'amerykański', 3, 10 UNION ALL 
SELECT 380, N'irlandzki', 3, 6 UNION ALL 
SELECT 381, N'szkocki', 3, 4 UNION ALL 
SELECT 382, N'walijski', 3, 4 UNION ALL 
SELECT 383, N'islandzki', 3, 5 UNION ALL 
SELECT 384, N'duński', 3, 8 UNION ALL 
SELECT 385, N'norweski', 3, 7 UNION ALL 
SELECT 386, N'szwedzki', 3, 9 UNION ALL 
SELECT 387, N'fiński', 3, 8 UNION ALL 
SELECT 388, N'estoński', 3, 4 UNION ALL 
SELECT 389, N'łotewski', 3, 4 UNION ALL 
SELECT 390, N'litewski', 3, 5 UNION ALL 
SELECT 391, N'holenderski', 3, 10 UNION ALL 
SELECT 392, N'belgijski', 3, 8 UNION ALL 
SELECT 393, N'słowacki', 3, 6 UNION ALL 
SELECT 394, N'węgierski', 3, 7 UNION ALL 
SELECT 395, N'rumuński', 3, 7 UNION ALL 
SELECT 396, N'serbski', 3, 7 UNION ALL 
SELECT 397, N'macedoński', 3, 4 UNION ALL 
SELECT 398, N'bośniacki', 3, 4 UNION ALL 
SELECT 399, N'słoweński', 3, 4 UNION ALL 
SELECT 400, N'czarnogórski', 3, 5 UNION ALL 
SELECT 401, N'białoruski', 3, 5 UNION ALL 
SELECT 402, N'ukraiński', 3, 8 UNION ALL 
SELECT 403, N'mołdawski', 3, 4 UNION ALL 
SELECT 404, N'peruwiański', 3, 7 UNION ALL 
SELECT 405, N'chilijski', 3, 7 UNION ALL 
SELECT 406, N'wenezuelski', 3, 7 UNION ALL 
SELECT 407, N'urugwajski', 3, 6 UNION ALL 
SELECT 408, N'paragwajski', 3, 7 UNION ALL 
SELECT 409, N'ekwadorski', 3, 5 UNION ALL 
SELECT 410, N'boliwijski', 3, 5 UNION ALL 
SELECT 411, N'surinamski', 3, 2 UNION ALL 
SELECT 412, N'gujański', 3, 2 UNION ALL 
SELECT 413, N'ormiański', 3, 6 UNION ALL 
SELECT 414, N'azerbejdżański', 3, 5 UNION ALL 
SELECT 415, N'turecki', 3, 8 UNION ALL 
SELECT 416, N'jamajski', 3, 5 UNION ALL 
SELECT 417, N'grenlandzki', 3, 5 UNION ALL 
SELECT 418, N'algierski', 3, 5 UNION ALL 
SELECT 419, N'marokański', 3, 6 UNION ALL 
SELECT 420, N'etiopski', 3, 5 UNION ALL 
SELECT 421, N'kenijski', 3, 5 UNION ALL 
SELECT 422, N'malgaski', 3, 4 UNION ALL 
SELECT 423, N'somalijski', 3, 4 UNION ALL 
SELECT 424, N'angolski', 3, 3 UNION ALL 
SELECT 425, N'kameruński', 3, 3 UNION ALL 
SELECT 426, N'gaboński', 3, 2 UNION ALL 
SELECT 427, N'egipski', 3, 6 UNION ALL 
SELECT 428, N'libijski', 3, 5 UNION ALL 
SELECT 429, N'sudański', 3, 3 UNION ALL 
SELECT 430, N'tunezyjski', 3, 5 UNION ALL 
SELECT 431, N'południowoafrykański', 3, 6 UNION ALL 
SELECT 432, N'senegalski', 3, 4 UNION ALL 
SELECT 433, N'nigeryjski', 3, 6 UNION ALL 
SELECT 434, N'nowozelandzki', 3, 7 UNION ALL 
SELECT 435, N'wstawać', 2, 10 UNION ALL 
SELECT 436, N'irański', 3, 6 UNION ALL 
SELECT 437, N'perski', 3, 6 UNION ALL 
SELECT 438, N'iracki', 3, 6 UNION ALL 
SELECT 439, N'pakistański', 3, 7 UNION ALL 
SELECT 440, N'syryjski', 3, 4 UNION ALL 
SELECT 441, N'hinduski', 3, 8 UNION ALL 
SELECT 442, N'libański', 3, 5 UNION ALL 
SELECT 443, N'tajski', 3, 7 UNION ALL 
SELECT 444, N'mongolski', 3, 5 UNION ALL 
SELECT 445, N'twierdzić', 2, 10 UNION ALL 
SELECT 446, N'zamierzać', 2, 10 UNION ALL 
SELECT 447, N'przeżyć', 2, 10 UNION ALL 
SELECT 448, N'rodzić', 2, 10 UNION ALL 
SELECT 449, N'jeden', 3, 10 UNION ALL 
SELECT 450, N'dwa (rzeczy)', 3, 10 UNION ALL 
SELECT 451, N'trzy (rzeczy)', 3, 10 UNION ALL 
SELECT 452, N'cztery (rzeczy)', 3, 10 UNION ALL 
SELECT 453, N'pięć (rzeczy)', 3, 10 UNION ALL 
SELECT 454, N'sześć (rzeczy)', 3, 10 UNION ALL 
SELECT 455, N'szpital', 1, 10 UNION ALL 
SELECT 456, N'szkoła', 1, 10 UNION ALL 
SELECT 457, N'poczta', 1, 10 UNION ALL 
SELECT 458, N'policja', 1, 8 UNION ALL 
SELECT 459, N'wygrywać', 2, 10 UNION ALL 
SELECT 460, N'Oscar', 1, 8 UNION ALL 
SELECT 461, N'Nagroda Nobla', 1, 9 UNION ALL 
SELECT 462, N'strażak', 1, 10 UNION ALL 
SELECT 463, N'lekarz', 1, 9 UNION ALL 
SELECT 464, N'policjant', 1, 9 UNION ALL 
SELECT 465, N'nauczyciel', 1, 9 UNION ALL 
SELECT 466, N'taksówkarz', 1, 9 UNION ALL 
SELECT 467, N'kierowca', 1, 9 UNION ALL 
SELECT 468, N'aplikować', 2, 7 UNION ALL 
SELECT 469, N'mieszkanie', 1, 10 UNION ALL 
SELECT 470, N'pokój', 1, 10 UNION ALL 
SELECT 471, N'przytrzasnąć', 2, 8 UNION ALL 
SELECT 472, N'drzwi', 1, 10 UNION ALL 
SELECT 473, N'okno', 1, 1 UNION ALL 
SELECT 474, N'jeść', 2, 10 UNION ALL 
SELECT 475, N'śniadanie', 1, 10 UNION ALL 
SELECT 476, N'obiad', 1, 10 UNION ALL 
SELECT 477, N'żyć', 2, 10 UNION ALL 
SELECT 478, N'zaczynać', 2, 10 UNION ALL 
SELECT 479, N'tracić', 2, 10 UNION ALL 
SELECT 480, N'wiedzieć', 2, 10 UNION ALL 
SELECT 481, N'stresować', 2, 7 UNION ALL 
SELECT 482, N'głosować', 2, 8 UNION ALL 
SELECT 483, N'ginąć', 2, 10 UNION ALL 
SELECT 484, N'ten', 3, 10 UNION ALL 
SELECT 485, N'dom', 1, 10 UNION ALL 
SELECT 486, N'chodzić', 2, 10 UNION ALL 
SELECT 487, N'brzeg', 1, 9 UNION ALL 
SELECT 488, N'pójść', 2, 10 UNION ALL 
SELECT 489, N'ukrywać', 2, 10 UNION ALL 
SELECT 490, N'iść', 2, 1 UNION ALL 
SELECT 491, N'zapewniać', 2, 10 UNION ALL 
SELECT 492, N'siedzieć', 2, 10 UNION ALL 
SELECT 493, N'powinien', 2, 10 UNION ALL 
SELECT 494, N'brać', 2, 10 UNION ALL 
SELECT 495, N'śmiać', 2, 10 UNION ALL 
SELECT 496, N'las', 1, 10 UNION ALL 
SELECT 497, N'lotnisko', 1, 10 UNION ALL 
SELECT 498, N'rzeka', 1, 10 UNION ALL 
SELECT 499, N'taksówka', 1, 10 UNION ALL 
SELECT 500, N'powstrzymywać', 2, 10 UNION ALL 
SELECT 501, N'prosić', 2, 10 UNION ALL 
SELECT 502, N'uznawać', 2, 9 UNION ALL 
SELECT 503, N'zostać', 2, 10 UNION ALL 
SELECT 504, N'budzić', 2, 10 UNION ALL 
SELECT 505, N'grozić', 2, 10 UNION ALL 
SELECT 506, N'wywiad', 1, 9 UNION ALL 
SELECT 507, N'spotkanie', 1, 9 UNION ALL 
SELECT 508, N'debata', 1, 9 UNION ALL 
SELECT 509, N'widzieć', 2, 10 UNION ALL 
SELECT 510, N'znajdować', 2, 10 UNION ALL 
SELECT 511, N'portfel', 1, 9 UNION ALL 
SELECT 512, N'klucz', 1, 10 UNION ALL 
SELECT 513, N'karta kredytowa', 1, 8 UNION ALL 
SELECT 514, N'lot', 1, 9 UNION ALL 
SELECT 515, N'prezent', 1, 10 UNION ALL 
SELECT 516, N'odpowiedź', 1, 10 UNION ALL 
SELECT 517, N'to', 1, 10 UNION ALL 
SELECT 518, N'komputer', 1, 10 UNION ALL 
SELECT 519, N'odzywać', 2, 10 UNION ALL 
SELECT 520, N'który', 3, 10 UNION ALL 
SELECT 521, N'przypuszczać', 2, 8 UNION ALL 
SELECT 522, N'gazeta', 1, 10 UNION ALL 
SELECT 523, N'dokument', 1, 9 UNION ALL 
SELECT 524, N'wiersz', 1, 8 UNION ALL 
SELECT 525, N'pisać', 2, 10 UNION ALL 
SELECT 526, N'stół', 1, 10 UNION ALL 
SELECT 527, N'krzesło', 1, 10 UNION ALL 
SELECT 528, N'podłoga', 1, 10 UNION ALL 
SELECT 529, N'łóżko', 1, 10 UNION ALL 
SELECT 530, N'kontaktować', 2, 8 UNION ALL 
SELECT 531, N'spotykać', 2, 10 UNION ALL 
SELECT 532, N'uderzać', 2, 10 UNION ALL 
SELECT 533, N'dzielić', 2, 9 UNION ALL 
SELECT 534, N'czekać', 2, 10 UNION ALL 
SELECT 535, N'znać', 2, 10 UNION ALL 
SELECT 536, N'wyjeżdżać', 2, 10 UNION ALL 
SELECT 537, N'gadać', 2, 8 UNION ALL 
SELECT 538, N'nosić', 2, 9 UNION ALL 
SELECT 539, N'brakować', 2, 9 UNION ALL 
SELECT 540, N'podobać', 2, 10 UNION ALL 
SELECT 541, N'porabiać', 2, 7 UNION ALL 
SELECT 542, N'jakiś', 3, 10 UNION ALL 
SELECT 543, N'zbrodnia', 1, 9 UNION ALL 
SELECT 544, N'przestępstwo', 1, 10 UNION ALL 
SELECT 545, N'groźba', 1, 10 UNION ALL 
SELECT 546, N'podpucha', 1, 8 UNION ALL 
SELECT 547, N'żart', 1, 10 UNION ALL 
SELECT 548, N'koncert', 1, 9 UNION ALL 
SELECT 549, N'Średniowiecze', 1, 9 UNION ALL 
SELECT 550, N'wojna domowa', 1, 8 UNION ALL 
SELECT 551, N'finał', 1, 9 UNION ALL 
SELECT 552, N'ten (osobowy)', 3, 10 UNION ALL 
SELECT 553, N'życie', 1, 10 UNION ALL 
SELECT 554, N'przybywać', 2, 8 UNION ALL 
SELECT 555, N'skorpion', 1, 8 UNION ALL 
SELECT 556, N'płaszczka', 1, 7 UNION ALL 
SELECT 557, N'meduza', 1, 8 UNION ALL 
SELECT 558, N'szerszeń', 1, 8 UNION ALL 
SELECT 559, N'kleszcz', 1, 8 UNION ALL 
SELECT 560, N'grzechotnik', 1, 6 UNION ALL 
SELECT 561, N'żmija', 1, 9 UNION ALL 
SELECT 562, N'dowód', 1, 10 UNION ALL 
SELECT 563, N'dane', 1, 9 UNION ALL 
SELECT 564, N'statystyka', 1, 9 UNION ALL 
SELECT 565, N'siedem', 3, 10 UNION ALL 
SELECT 566, N'osiem', 3, 10 UNION ALL 
SELECT 567, N'skóra', 1, 10 UNION ALL 
SELECT 568, N'miejsce', 1, 10 UNION ALL 
SELECT 569, N'wpadać', 2, 10 UNION ALL 
SELECT 570, N'wierzyć', 2, 10 UNION ALL 
SELECT 571, N'potrzebować', 2, 10 UNION ALL 
SELECT 572, N'lubić', 2, 10 UNION ALL 
SELECT 573, N'jedyny', 3, 10 UNION ALL 
SELECT 574, N'ujęcie (zdjęcia)', 1, 8 UNION ALL 
SELECT 575, N'wyjaśnienie', 1, 10 UNION ALL 
SELECT 576, N'powód', 1, 10 UNION ALL 
SELECT 577, N'szansa', 1, 10 UNION ALL 
SELECT 578, N'osoba', 1, 10 UNION ALL 
SELECT 579, N'pytanie', 1, 10 UNION ALL 
SELECT 580, N'wymóg', 1, 9 UNION ALL 
SELECT 581, N'różnica', 1, 10 UNION ALL 
SELECT 582, N'problem', 1, 10 UNION ALL 
SELECT 583, N'wybór', 1, 10 UNION ALL 
SELECT 584, N'mapa', 1, 10 UNION ALL 
SELECT 585, N'wykres', 1, 10 UNION ALL 
SELECT 586, N'założenie', 1, 9 UNION ALL 
SELECT 587, N'wynik (gry, meczu)', 1, 9 UNION ALL 
SELECT 588, N'wynik (badania, pomiaru)', 1, 10 UNION ALL 
SELECT 589, N'zdjęcie', 1, 10 UNION ALL 
SELECT 590, N'młotek', 1, 9 UNION ALL 
SELECT 591, N'lina', 1, 9 UNION ALL 
SELECT 592, N'odwaga', 1, 10 UNION ALL 
SELECT 593, N'przyjaciel', 1, 9 UNION ALL 
SELECT 594, N'zabierać', 2, 7 UNION ALL 
SELECT 595, N'region', 1, 9 UNION ALL 
SELECT 596, N'miasto', 1, 10 UNION ALL 
SELECT 597, N'głowa', 1, 10 UNION ALL 
SELECT 598, N'noga', 1, 10 UNION ALL 
SELECT 599, N'brzuch', 1, 10 UNION ALL 
SELECT 600, N'włos', 1, 10 UNION ALL 
SELECT 601, N'oko', 1, 10 UNION ALL 
SELECT 602, N'ucho', 1, 10 UNION ALL 
SELECT 603, N'nos', 1, 10 UNION ALL 
SELECT 604, N'paznokieć', 1, 7 UNION ALL 
SELECT 605, N'palec (od ręki)', 1, 9 UNION ALL 
SELECT 606, N'ramię', 1, 9 UNION ALL 
SELECT 607, N'szyja', 1, 9 UNION ALL 
SELECT 608, N'usta', 1, 10 UNION ALL 
SELECT 609, N'ząb', 1, 10 UNION ALL 
SELECT 610, N'język', 1, 10 UNION ALL 
SELECT 611, N'serce', 1, 10 UNION ALL 
SELECT 612, N'wątroba', 1, 8 UNION ALL 
SELECT 613, N'żołądek', 1, 7 UNION ALL 
SELECT 614, N'kolano', 1, 7 UNION ALL 
SELECT 615, N'łokieć', 1, 7 UNION ALL 
SELECT 616, N'stopa', 1, 8 UNION ALL 
SELECT 617, N'pięta', 1, 7 UNION ALL 
SELECT 618, N'policzek', 1, 8 UNION ALL 
SELECT 619, N'brew', 1, 6 UNION ALL 
SELECT 620, N'rzęsa', 1, 6 UNION ALL 
SELECT 621, N'powieka', 1, 6 UNION ALL 
SELECT 622, N'czoło', 1, 8 UNION ALL 
SELECT 623, N'kręgosłup', 1, 8 UNION ALL 
SELECT 624, N'płuco', 1, 8 UNION ALL 
SELECT 625, N'żyła', 1, 9 UNION ALL 
SELECT 626, N'krew', 1, 10 UNION ALL 
SELECT 627, N'gardło', 1, 9 UNION ALL 
SELECT 628, N'mózg', 1, 10 UNION ALL 
SELECT 629, N'mysz', 1, 10 UNION ALL 
SELECT 630, N'szczur', 1, 10 UNION ALL 
SELECT 631, N'Bałkany', 1, 10 UNION ALL 
SELECT 632, N'palec (od nogi)', 1, 9 
COMMIT;
SET IDENTITY_INSERT [dbo].[Metawords] OFF


GO


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



SET IDENTITY_INSERT [dbo].[MatchWordCategory] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[MatchWordCategory]([Id], [MetawordId], [CategoryId])
SELECT 1, 1, 4 UNION ALL 
SELECT 2, 2, 18 UNION ALL 
SELECT 3, 3, 4 UNION ALL 
SELECT 4, 4, 4 UNION ALL 
SELECT 5, 5, 4 UNION ALL 
SELECT 6, 6, 4 UNION ALL 
SELECT 7, 7, 4 UNION ALL 
SELECT 8, 8, 8 UNION ALL 
SELECT 9, 9, 4 UNION ALL 
SELECT 10, 10, 4 UNION ALL 
SELECT 11, 11, 4 UNION ALL 
SELECT 12, 11, 8 UNION ALL 
SELECT 13, 12, 4 UNION ALL 
SELECT 14, 13, 4 UNION ALL 
SELECT 15, 13, 8 UNION ALL 
SELECT 16, 14, 4 UNION ALL 
SELECT 17, 15, 4 UNION ALL 
SELECT 18, 16, 4 UNION ALL 
SELECT 19, 17, 4 UNION ALL 
SELECT 20, 18, 4 UNION ALL 
SELECT 21, 19, 4 UNION ALL 
SELECT 22, 19, 42 UNION ALL 
SELECT 23, 20, 4 UNION ALL 
SELECT 24, 21, 4 UNION ALL 
SELECT 25, 22, 4 UNION ALL 
SELECT 26, 23, 4 UNION ALL 
SELECT 27, 24, 4 UNION ALL 
SELECT 28, 25, 4 UNION ALL 
SELECT 29, 26, 4 UNION ALL 
SELECT 30, 27, 4 UNION ALL 
SELECT 31, 27, 42 UNION ALL 
SELECT 32, 28, 4 UNION ALL 
SELECT 33, 28, 42 UNION ALL 
SELECT 34, 29, 4 UNION ALL 
SELECT 35, 30, 4 UNION ALL 
SELECT 36, 31, 4 UNION ALL 
SELECT 37, 32, 4 UNION ALL 
SELECT 38, 33, 4 UNION ALL 
SELECT 39, 34, 4 UNION ALL 
SELECT 40, 35, 4 UNION ALL 
SELECT 41, 35, 42 UNION ALL 
SELECT 42, 36, 4 UNION ALL 
SELECT 43, 37, 4 UNION ALL 
SELECT 44, 38, 4 UNION ALL 
SELECT 45, 39, 4 UNION ALL 
SELECT 46, 40, 4 UNION ALL 
SELECT 47, 41, 4 UNION ALL 
SELECT 48, 42, 4 UNION ALL 
SELECT 49, 43, 4 UNION ALL 
SELECT 50, 44, 4 UNION ALL 
SELECT 51, 45, 4 UNION ALL 
SELECT 52, 46, 4 UNION ALL 
SELECT 53, 47, 4 UNION ALL 
SELECT 54, 48, 4 UNION ALL 
SELECT 55, 49, 4 UNION ALL 
SELECT 56, 49, 8 UNION ALL 
SELECT 57, 50, 4 UNION ALL 
SELECT 58, 51, 4 UNION ALL 
SELECT 59, 52, 4 UNION ALL 
SELECT 60, 53, 4 UNION ALL 
SELECT 61, 54, 6 UNION ALL 
SELECT 62, 55, 6 UNION ALL 
SELECT 63, 56, 6 UNION ALL 
SELECT 64, 57, 6 UNION ALL 
SELECT 65, 58, 6 UNION ALL 
SELECT 66, 59, 6 UNION ALL 
SELECT 67, 60, 6 UNION ALL 
SELECT 68, 61, 6 UNION ALL 
SELECT 69, 62, 6 UNION ALL 
SELECT 70, 63, 6 UNION ALL 
SELECT 71, 64, 8 UNION ALL 
SELECT 72, 65, 8 UNION ALL 
SELECT 73, 66, 8 UNION ALL 
SELECT 74, 67, 8 UNION ALL 
SELECT 75, 68, 8 UNION ALL 
SELECT 76, 69, 8 UNION ALL 
SELECT 77, 70, 8 UNION ALL 
SELECT 78, 71, 8 UNION ALL 
SELECT 79, 72, 8 UNION ALL 
SELECT 80, 73, 8 UNION ALL 
SELECT 81, 74, 8 UNION ALL 
SELECT 82, 75, 8 UNION ALL 
SELECT 83, 76, 8 UNION ALL 
SELECT 84, 77, 8 UNION ALL 
SELECT 85, 78, 8 UNION ALL 
SELECT 86, 79, 8 UNION ALL 
SELECT 87, 80, 8 UNION ALL 
SELECT 88, 81, 8 UNION ALL 
SELECT 89, 82, 8 UNION ALL 
SELECT 90, 83, 8 UNION ALL 
SELECT 91, 84, 8 UNION ALL 
SELECT 92, 85, 8 UNION ALL 
SELECT 93, 86, 8 UNION ALL 
SELECT 94, 87, 8 UNION ALL 
SELECT 95, 88, 8 UNION ALL 
SELECT 96, 89, 8 UNION ALL 
SELECT 97, 90, 8 UNION ALL 
SELECT 98, 90, 42 UNION ALL 
SELECT 99, 91, 8 UNION ALL 
SELECT 100, 92, 8 UNION ALL 
SELECT 101, 93, 8 UNION ALL 
SELECT 102, 94, 8 UNION ALL 
SELECT 103, 95, 8 UNION ALL 
SELECT 104, 96, 8 UNION ALL 
SELECT 105, 97, 8 UNION ALL 
SELECT 106, 98, 8 UNION ALL 
SELECT 107, 99, 8 UNION ALL 
SELECT 108, 100, 8 UNION ALL 
SELECT 109, 101, 8 UNION ALL 
SELECT 110, 101, 42 UNION ALL 
SELECT 111, 102, 8 UNION ALL 
SELECT 112, 103, 8 UNION ALL 
SELECT 113, 104, 9 UNION ALL 
SELECT 114, 104, 42 UNION ALL 
SELECT 115, 105, 9 UNION ALL 
SELECT 116, 105, 42 UNION ALL 
SELECT 117, 106, 9 UNION ALL 
SELECT 118, 106, 42 UNION ALL 
SELECT 119, 107, 7 UNION ALL 
SELECT 120, 108, 7 UNION ALL 
SELECT 121, 109, 7 UNION ALL 
SELECT 122, 110, 7 UNION ALL 
SELECT 123, 111, 7 UNION ALL 
SELECT 124, 112, 7 UNION ALL 
SELECT 125, 113, 7 UNION ALL 
SELECT 126, 114, 7 UNION ALL 
SELECT 127, 115, 7 UNION ALL 
SELECT 128, 116, 7 UNION ALL 
SELECT 129, 117, 7 UNION ALL 
SELECT 130, 118, 7 UNION ALL 
SELECT 131, 119, 7 UNION ALL 
SELECT 132, 120, 7 UNION ALL 
SELECT 133, 121, 7 UNION ALL 
SELECT 134, 122, 7 UNION ALL 
SELECT 135, 123, 7 UNION ALL 
SELECT 136, 124, 7 UNION ALL 
SELECT 137, 125, 7 UNION ALL 
SELECT 138, 126, 7 UNION ALL 
SELECT 139, 127, 7 UNION ALL 
SELECT 140, 128, 7 UNION ALL 
SELECT 141, 129, 7 UNION ALL 
SELECT 142, 130, 7 UNION ALL 
SELECT 143, 131, 7 UNION ALL 
SELECT 144, 132, 7 UNION ALL 
SELECT 145, 133, 7 UNION ALL 
SELECT 146, 134, 7 UNION ALL 
SELECT 147, 135, 7 UNION ALL 
SELECT 148, 136, 7 UNION ALL 
SELECT 149, 137, 7 UNION ALL 
SELECT 150, 138, 7 UNION ALL 
SELECT 151, 139, 7 UNION ALL 
SELECT 152, 140, 7 UNION ALL 
SELECT 153, 141, 7 UNION ALL 
SELECT 154, 141, 42 UNION ALL 
SELECT 155, 142, 7 UNION ALL 
SELECT 156, 143, 7 UNION ALL 
SELECT 157, 144, 7 UNION ALL 
SELECT 158, 145, 7 UNION ALL 
SELECT 159, 146, 7 UNION ALL 
SELECT 160, 147, 7 UNION ALL 
SELECT 161, 148, 7 UNION ALL 
SELECT 162, 148, 42 UNION ALL 
SELECT 163, 149, 7 UNION ALL 
SELECT 164, 149, 42 UNION ALL 
SELECT 165, 150, 5 UNION ALL 
SELECT 166, 151, 5 UNION ALL 
SELECT 167, 152, 5 UNION ALL 
SELECT 168, 153, 5 UNION ALL 
SELECT 169, 153, 42 UNION ALL 
SELECT 170, 154, 5 UNION ALL 
SELECT 171, 154, 42 UNION ALL 
SELECT 172, 155, 5 UNION ALL 
SELECT 173, 155, 42 UNION ALL 
SELECT 174, 156, 5 UNION ALL 
SELECT 175, 157, 5 UNION ALL 
SELECT 176, 158, 5 UNION ALL 
SELECT 177, 159, 5 UNION ALL 
SELECT 178, 160, 5 UNION ALL 
SELECT 179, 161, 5 UNION ALL 
SELECT 180, 161, 42 UNION ALL 
SELECT 181, 162, 5 UNION ALL 
SELECT 182, 163, 5 UNION ALL 
SELECT 183, 164, 5 UNION ALL 
SELECT 184, 165, 5 UNION ALL 
SELECT 185, 166, 5 UNION ALL 
SELECT 186, 166, 42 UNION ALL 
SELECT 187, 167, 41 UNION ALL 
SELECT 188, 168, 41 UNION ALL 
SELECT 189, 169, 41 UNION ALL 
SELECT 190, 170, 41 UNION ALL 
SELECT 191, 171, 41 UNION ALL 
SELECT 192, 172, 41 UNION ALL 
SELECT 193, 173, 44 UNION ALL 
SELECT 194, 174, 46 UNION ALL 
SELECT 195, 175, 45 UNION ALL 
SELECT 196, 176, 18 UNION ALL 
SELECT 197, 177, 18 UNION ALL 
SELECT 198, 178, 19 UNION ALL 
SELECT 199, 179, 19 UNION ALL 
SELECT 200, 180, 21 UNION ALL 
SELECT 201, 181, 21 UNION ALL 
SELECT 202, 182, 21 UNION ALL 
SELECT 203, 183, 21 UNION ALL 
SELECT 204, 184, 22 UNION ALL 
SELECT 205, 185, 17 UNION ALL 
SELECT 206, 186, 20 UNION ALL 
SELECT 207, 187, 17 UNION ALL 
SELECT 208, 188, 17 UNION ALL 
SELECT 209, 189, 21 UNION ALL 
SELECT 210, 190, 23 UNION ALL 
SELECT 211, 191, 23 UNION ALL 
SELECT 212, 192, 23 UNION ALL 
SELECT 213, 193, 23 UNION ALL 
SELECT 214, 194, 23 UNION ALL 
SELECT 215, 195, 23 UNION ALL 
SELECT 216, 196, 22 UNION ALL 
SELECT 217, 197, 20 UNION ALL 
SELECT 218, 198, 20 UNION ALL 
SELECT 219, 199, 19 UNION ALL 
SELECT 220, 200, 19 UNION ALL 
SELECT 221, 201, 17 UNION ALL 
SELECT 222, 202, 17 UNION ALL 
SELECT 223, 203, 17 UNION ALL 
SELECT 224, 204, 17 UNION ALL 
SELECT 225, 205, 12 UNION ALL 
SELECT 226, 206, 12 UNION ALL 
SELECT 227, 207, 12 UNION ALL 
SELECT 228, 208, 13 UNION ALL 
SELECT 229, 209, 13 UNION ALL 
SELECT 230, 210, 13 UNION ALL 
SELECT 231, 211, 13 UNION ALL 
SELECT 232, 212, 13 UNION ALL 
SELECT 233, 213, 13 UNION ALL 
SELECT 234, 214, 42 UNION ALL 
SELECT 235, 215, 42 UNION ALL 
SELECT 236, 216, 48 UNION ALL 
SELECT 237, 217, 48 UNION ALL 
SELECT 238, 218, 48 UNION ALL 
SELECT 239, 219, 48 UNION ALL 
SELECT 240, 220, 48 UNION ALL 
SELECT 241, 221, 48 UNION ALL 
SELECT 242, 222, 48 UNION ALL 
SELECT 243, 223, 48 UNION ALL 
SELECT 244, 224, 48 UNION ALL 
SELECT 245, 225, 48 UNION ALL 
SELECT 246, 226, 50 UNION ALL 
SELECT 247, 227, 50 UNION ALL 
SELECT 248, 228, 50 UNION ALL 
SELECT 249, 229, 50 UNION ALL 
SELECT 250, 230, 50 UNION ALL 
SELECT 251, 231, 50 UNION ALL 
SELECT 252, 232, 50 UNION ALL 
SELECT 253, 233, 50 UNION ALL 
SELECT 254, 234, 50 UNION ALL 
SELECT 255, 235, 50 UNION ALL 
SELECT 256, 236, 50 UNION ALL 
SELECT 257, 237, 50 UNION ALL 
SELECT 258, 238, 50 UNION ALL 
SELECT 259, 239, 50 UNION ALL 
SELECT 260, 240, 50 UNION ALL 
SELECT 261, 241, 50 UNION ALL 
SELECT 262, 242, 50 UNION ALL 
SELECT 263, 243, 50 UNION ALL 
SELECT 264, 244, 50 UNION ALL 
SELECT 265, 245, 51 UNION ALL 
SELECT 266, 246, 51 UNION ALL 
SELECT 267, 247, 51 UNION ALL 
SELECT 268, 248, 51 UNION ALL 
SELECT 269, 249, 51 UNION ALL 
SELECT 270, 250, 51 UNION ALL 
SELECT 271, 251, 51 UNION ALL 
SELECT 272, 252, 51 UNION ALL 
SELECT 273, 253, 51 UNION ALL 
SELECT 274, 254, 51 UNION ALL 
SELECT 275, 255, 51 UNION ALL 
SELECT 276, 256, 22 UNION ALL 
SELECT 277, 256, 23 UNION ALL 
SELECT 278, 257, 23 UNION ALL 
SELECT 279, 258, 23 UNION ALL 
SELECT 280, 259, 22 UNION ALL 
SELECT 281, 260, 22 UNION ALL 
SELECT 282, 261, 16 UNION ALL 
SELECT 283, 262, 21 UNION ALL 
SELECT 284, 263, 21 UNION ALL 
SELECT 285, 264, 24 UNION ALL 
SELECT 286, 265, 24 UNION ALL 
SELECT 287, 266, 24 UNION ALL 
SELECT 288, 267, 24 UNION ALL 
SELECT 289, 268, 24 UNION ALL 
SELECT 290, 269, 24 UNION ALL 
SELECT 291, 270, 24 UNION ALL 
SELECT 292, 271, 24 UNION ALL 
SELECT 293, 272, 24 UNION ALL 
SELECT 294, 273, 24 UNION ALL 
SELECT 295, 275, 4 UNION ALL 
SELECT 296, 276, 75 UNION ALL 
SELECT 297, 285, 59 UNION ALL 
SELECT 298, 288, 60 UNION ALL 
SELECT 299, 288, 72 UNION ALL 
SELECT 300, 307, 59 UNION ALL 
SELECT 301, 308, 59 UNION ALL 
SELECT 302, 309, 59 UNION ALL 
SELECT 303, 313, 62 UNION ALL 
SELECT 304, 313, 64 UNION ALL 
SELECT 305, 315, 54 UNION ALL 
SELECT 306, 319, 60 UNION ALL 
SELECT 307, 320, 60 UNION ALL 
SELECT 308, 321, 60 UNION ALL 
SELECT 309, 339, 11 UNION ALL 
SELECT 310, 340, 11 UNION ALL 
SELECT 311, 341, 63 UNION ALL 
SELECT 312, 349, 4 UNION ALL 
SELECT 313, 350, 4 UNION ALL 
SELECT 314, 351, 4 UNION ALL 
SELECT 315, 352, 4 UNION ALL 
SELECT 316, 353, 4 UNION ALL 
SELECT 317, 354, 4 UNION ALL 
SELECT 318, 355, 4 UNION ALL 
SELECT 319, 356, 4 UNION ALL 
SELECT 320, 357, 4 UNION ALL 
SELECT 321, 358, 4 UNION ALL 
SELECT 322, 364, 8 UNION ALL 
SELECT 323, 365, 8 UNION ALL 
SELECT 324, 366, 8 UNION ALL 
SELECT 325, 367, 4 UNION ALL 
SELECT 326, 368, 4 UNION ALL 
SELECT 327, 369, 4 UNION ALL 
SELECT 328, 370, 4 UNION ALL 
SELECT 329, 371, 4 UNION ALL 
SELECT 330, 372, 4 UNION ALL 
SELECT 331, 373, 9 UNION ALL 
SELECT 332, 374, 5 UNION ALL 
SELECT 333, 375, 6 UNION ALL 
SELECT 334, 376, 6 UNION ALL 
SELECT 335, 377, 6 UNION ALL 
SELECT 336, 378, 5 UNION ALL 
SELECT 337, 379, 5 UNION ALL 
SELECT 338, 380, 4 UNION ALL 
SELECT 339, 381, 4 UNION ALL 
SELECT 340, 382, 4 UNION ALL 
SELECT 341, 383, 4 UNION ALL 
SELECT 342, 384, 4 UNION ALL 
SELECT 343, 385, 4 UNION ALL 
SELECT 344, 386, 4 UNION ALL 
SELECT 345, 387, 4 UNION ALL 
SELECT 346, 388, 4 UNION ALL 
SELECT 347, 389, 4 UNION ALL 
SELECT 348, 390, 4 UNION ALL 
SELECT 349, 391, 4 UNION ALL 
SELECT 350, 392, 4 UNION ALL 
SELECT 351, 393, 4 UNION ALL 
SELECT 352, 394, 4 UNION ALL 
SELECT 353, 395, 4 UNION ALL 
SELECT 354, 396, 4 UNION ALL 
SELECT 355, 397, 4 UNION ALL 
SELECT 356, 398, 4 UNION ALL 
SELECT 357, 399, 4 UNION ALL 
SELECT 358, 400, 4 UNION ALL 
SELECT 359, 401, 4 UNION ALL 
SELECT 360, 402, 4 UNION ALL 
SELECT 361, 403, 4 UNION ALL 
SELECT 362, 404, 6 UNION ALL 
SELECT 363, 405, 6 UNION ALL 
SELECT 364, 406, 6 UNION ALL 
SELECT 365, 407, 6 UNION ALL 
SELECT 366, 408, 6 UNION ALL 
SELECT 367, 409, 6 UNION ALL 
SELECT 368, 410, 6 UNION ALL 
SELECT 369, 411, 6 UNION ALL 
SELECT 370, 412, 6 UNION ALL 
SELECT 371, 413, 8 UNION ALL 
SELECT 372, 414, 8 UNION ALL 
SELECT 373, 415, 4 UNION ALL 
SELECT 374, 416, 5 UNION ALL 
SELECT 375, 417, 5 UNION ALL 
SELECT 376, 418, 7 UNION ALL 
SELECT 377, 419, 7 UNION ALL 
SELECT 378, 420, 7 UNION ALL 
SELECT 379, 421, 7 UNION ALL 
SELECT 380, 422, 7 UNION ALL 
SELECT 381, 423, 7 UNION ALL 
SELECT 382, 424, 7 UNION ALL 
SELECT 383, 425, 7 UNION ALL 
SELECT 384, 426, 7 UNION ALL 
SELECT 385, 427, 7 UNION ALL 
SELECT 386, 428, 7 UNION ALL 
SELECT 387, 429, 7 UNION ALL 
SELECT 388, 430, 7 UNION ALL 
SELECT 389, 431, 7 UNION ALL 
SELECT 390, 432, 7 UNION ALL 
SELECT 391, 433, 7 UNION ALL 
SELECT 392, 434, 9 UNION ALL 
SELECT 393, 436, 8 UNION ALL 
SELECT 394, 437, 8 UNION ALL 
SELECT 395, 438, 8 UNION ALL 
SELECT 396, 439, 8 UNION ALL 
SELECT 397, 440, 8 UNION ALL 
SELECT 398, 441, 8 UNION ALL 
SELECT 399, 442, 8 UNION ALL 
SELECT 400, 443, 8 UNION ALL 
SELECT 401, 444, 8 UNION ALL 
SELECT 402, 455, 62 UNION ALL 
SELECT 403, 455, 64 UNION ALL 
SELECT 404, 456, 62 UNION ALL 
SELECT 405, 456, 64 UNION ALL 
SELECT 406, 457, 62 UNION ALL 
SELECT 407, 457, 64 UNION ALL 
SELECT 408, 458, 62 UNION ALL 
SELECT 409, 460, 78 UNION ALL 
SELECT 410, 461, 78 UNION ALL 
SELECT 411, 462, 28 UNION ALL 
SELECT 412, 463, 28 UNION ALL 
SELECT 413, 464, 28 UNION ALL 
SELECT 414, 465, 28 UNION ALL 
SELECT 415, 466, 28 UNION ALL 
SELECT 416, 467, 28 UNION ALL 
SELECT 417, 472, 72 UNION ALL 
SELECT 418, 473, 72 UNION ALL 
SELECT 419, 475, 71 UNION ALL 
SELECT 420, 476, 71 UNION ALL 
SELECT 421, 487, 63 UNION ALL 
SELECT 422, 487, 63 UNION ALL 
SELECT 423, 496, 63 UNION ALL 
SELECT 424, 497, 62 UNION ALL 
SELECT 425, 497, 64 UNION ALL 
SELECT 426, 498, 63 UNION ALL 
SELECT 427, 499, 60 UNION ALL 
SELECT 428, 506, 77 UNION ALL 
SELECT 429, 507, 77 UNION ALL 
SELECT 430, 508, 77 UNION ALL 
SELECT 431, 511, 72 UNION ALL 
SELECT 432, 512, 72 UNION ALL 
SELECT 433, 513, 72 UNION ALL 
SELECT 434, 515, 72 UNION ALL 
SELECT 435, 518, 72 UNION ALL 
SELECT 436, 522, 72 UNION ALL 
SELECT 437, 523, 77 UNION ALL 
SELECT 438, 524, 67 UNION ALL 
SELECT 439, 526, 72 UNION ALL 
SELECT 440, 526, 56 UNION ALL 
SELECT 441, 527, 72 UNION ALL 
SELECT 442, 527, 58 UNION ALL 
SELECT 443, 528, 72 UNION ALL 
SELECT 444, 528, 58 UNION ALL 
SELECT 445, 529, 72 UNION ALL 
SELECT 446, 529, 58 UNION ALL 
SELECT 447, 544, 80 UNION ALL 
SELECT 448, 545, 80 UNION ALL 
SELECT 449, 547, 65 UNION ALL 
SELECT 450, 548, 67 UNION ALL 
SELECT 451, 555, 21 UNION ALL 
SELECT 452, 556, 20 UNION ALL 
SELECT 453, 557, 21 UNION ALL 
SELECT 454, 558, 21 UNION ALL 
SELECT 455, 559, 21 UNION ALL 
SELECT 456, 560, 22 UNION ALL 
SELECT 457, 561, 22 UNION ALL 
SELECT 458, 562, 77 UNION ALL 
SELECT 459, 563, 77 UNION ALL 
SELECT 460, 564, 77 UNION ALL 
SELECT 461, 567, 75 UNION ALL 
SELECT 462, 584, 74 UNION ALL 
SELECT 463, 585, 77 UNION ALL 
SELECT 464, 587, 77 UNION ALL 
SELECT 465, 588, 77 UNION ALL 
SELECT 466, 589, 72 UNION ALL 
SELECT 467, 590, 73 UNION ALL 
SELECT 468, 591, 73 UNION ALL 
SELECT 469, 595, 63 UNION ALL 
SELECT 470, 596, 63 UNION ALL 
SELECT 471, 597, 75 UNION ALL 
SELECT 472, 598, 75 UNION ALL 
SELECT 473, 599, 75 UNION ALL 
SELECT 474, 600, 75 UNION ALL 
SELECT 475, 601, 75 UNION ALL 
SELECT 476, 602, 75 UNION ALL 
SELECT 477, 603, 75 UNION ALL 
SELECT 478, 604, 75 UNION ALL 
SELECT 479, 605, 75 UNION ALL 
SELECT 480, 606, 75 UNION ALL 
SELECT 481, 607, 75 UNION ALL 
SELECT 482, 608, 75 UNION ALL 
SELECT 483, 609, 75 UNION ALL 
SELECT 484, 610, 75 UNION ALL 
SELECT 485, 611, 75 UNION ALL 
SELECT 486, 612, 75 UNION ALL 
SELECT 487, 613, 75 UNION ALL 
SELECT 488, 614, 75 UNION ALL 
SELECT 489, 615, 75 UNION ALL 
SELECT 490, 616, 75 UNION ALL 
SELECT 491, 617, 75 UNION ALL 
SELECT 492, 618, 75 UNION ALL 
SELECT 493, 619, 75 UNION ALL 
SELECT 494, 620, 75 UNION ALL 
SELECT 495, 621, 75 UNION ALL 
SELECT 496, 622, 75 UNION ALL 
SELECT 497, 623, 75 UNION ALL 
SELECT 498, 624, 75 UNION ALL 
SELECT 499, 625, 75 UNION ALL 
SELECT 500, 626, 75 UNION ALL 
SELECT 501, 627, 75 UNION ALL 
SELECT 502, 628, 75 UNION ALL 
SELECT 503, 629, 81 UNION ALL 
SELECT 504, 630, 81 UNION ALL 
SELECT 505, 631, 44 UNION ALL 
SELECT 506, 632, 75 
COMMIT;
SET IDENTITY_INSERT [dbo].[MatchWordCategory] OFF


GO


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
	, [IsCompleted] BIT			  DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_Words] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_Words_WordContentForMetaword] UNIQUE NONCLUSTERED ([MetawordId] ASC, [LanguageId] ASC, [Name] ASC)
    , CONSTRAINT [FK_Words_Metaword] FOREIGN KEY ([MetawordId]) REFERENCES [dbo].[Metawords] ([Id])
    , CONSTRAINT [FK_WordLanguage] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_WordCreator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [CH_WordWeight] CHECK ([Weight] > (0) AND [Weight] <= (10))
);

SET IDENTITY_INSERT [dbo].[Words] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[Words]([Id], [MetawordId], [LanguageId], [Name], [Weight], [IsCompleted])
SELECT 1, 1, 1, N'Polska', 10, 1 UNION ALL 
SELECT 2, 2, 1, N'pies', 10, 1 UNION ALL 
SELECT 3, 3, 1, N'Włochy', 10, 1 UNION ALL 
SELECT 4, 4, 1, N'Hiszpania', 10, 1 UNION ALL 
SELECT 5, 5, 1, N'Francja', 10, 1 UNION ALL 
SELECT 6, 6, 1, N'Niemcy', 10, 1 UNION ALL 
SELECT 7, 7, 1, N'Anglia', 10, 1 UNION ALL 
SELECT 8, 8, 1, N'Rosja', 10, 1 UNION ALL 
SELECT 9, 9, 1, N'Albania', 10, 1 UNION ALL 
SELECT 10, 10, 1, N'Andora', 10, 1 UNION ALL 
SELECT 11, 11, 1, N'Armenia', 10, 1 UNION ALL 
SELECT 12, 12, 1, N'Austria', 10, 1 UNION ALL 
SELECT 13, 13, 1, N'Azerbejdżan', 10, 1 UNION ALL 
SELECT 14, 14, 1, N'Białoruś', 10, 1 UNION ALL 
SELECT 15, 15, 1, N'Belgia', 10, 1 UNION ALL 
SELECT 16, 16, 1, N'Bośnia i Hercegowina', 10, 1 UNION ALL 
SELECT 17, 17, 1, N'Bułgaria', 10, 1 UNION ALL 
SELECT 18, 18, 1, N'Chorwacja', 10, 1 UNION ALL 
SELECT 19, 19, 1, N'Cypr', 10, 1 UNION ALL 
SELECT 20, 20, 1, N'Czechy', 10, 1 UNION ALL 
SELECT 21, 21, 1, N'Dania', 10, 1 UNION ALL 
SELECT 22, 22, 1, N'Estonia', 10, 1 UNION ALL 
SELECT 23, 23, 1, N'Finlandia', 10, 1 UNION ALL 
SELECT 24, 24, 1, N'Gruzja', 10, 1 UNION ALL 
SELECT 25, 25, 1, N'Grecja', 10, 1 UNION ALL 
SELECT 26, 26, 1, N'Węgry', 10, 1 UNION ALL 
SELECT 27, 27, 1, N'Islandia', 10, 1 UNION ALL 
SELECT 28, 28, 1, N'Irlandia', 10, 1 UNION ALL 
SELECT 29, 29, 1, N'Kazachstan', 10, 1 UNION ALL 
SELECT 30, 30, 1, N'Łotwa', 10, 1 UNION ALL 
SELECT 31, 31, 1, N'Liechtenstein', 10, 1 UNION ALL 
SELECT 32, 32, 1, N'Litwa', 10, 1 UNION ALL 
SELECT 33, 33, 1, N'Luksemburg', 10, 1 UNION ALL 
SELECT 34, 34, 1, N'Macedonia', 10, 1 UNION ALL 
SELECT 35, 35, 1, N'Malta', 10, 1 UNION ALL 
SELECT 36, 36, 1, N'Mołdawia', 10, 1 UNION ALL 
SELECT 37, 37, 1, N'Monako', 10, 1 UNION ALL 
SELECT 38, 38, 1, N'Czarnogóra', 10, 1 UNION ALL 
SELECT 39, 39, 1, N'Holandia', 10, 1 UNION ALL 
SELECT 40, 40, 1, N'Norwegia', 10, 1 UNION ALL 
SELECT 41, 41, 1, N'Portugalia', 10, 1 UNION ALL 
SELECT 42, 42, 1, N'Rumunia', 10, 1 UNION ALL 
SELECT 43, 43, 1, N'San Marino', 10, 1 UNION ALL 
SELECT 44, 44, 1, N'Serbia', 10, 1 UNION ALL 
SELECT 45, 45, 1, N'Słowacja', 10, 1 UNION ALL 
SELECT 46, 46, 1, N'Słowenia', 10, 1 UNION ALL 
SELECT 47, 47, 1, N'Szwecja', 10, 1 UNION ALL 
SELECT 48, 48, 1, N'Szwajcaria', 10, 1 UNION ALL 
SELECT 49, 49, 1, N'Turcja', 10, 1 UNION ALL 
SELECT 50, 50, 1, N'Ukraina', 10, 1 UNION ALL 
SELECT 51, 51, 1, N'Wielka Brytania', 10, 1 UNION ALL 
SELECT 52, 52, 1, N'Watykan', 10, 1 UNION ALL 
SELECT 53, 53, 1, N'Szkocja', 10, 1 UNION ALL 
SELECT 54, 54, 1, N'Brazylia', 10, 1 UNION ALL 
SELECT 55, 55, 1, N'Argentyna', 10, 1 UNION ALL 
SELECT 56, 63, 1, N'Ekwador', 10, 1 UNION ALL 
SELECT 57, 62, 1, N'Paragwaj', 10, 1 UNION ALL 
SELECT 58, 61, 1, N'Urugwaj', 10, 1 UNION ALL 
SELECT 59, 60, 1, N'Wenezuela', 10, 1 UNION ALL 
SELECT 60, 59, 1, N'Kolumbia', 10, 1 UNION ALL 
SELECT 61, 58, 1, N'Chile', 10, 1 UNION ALL 
SELECT 62, 57, 1, N'Boliwia', 10, 1 UNION ALL 
SELECT 63, 56, 1, N'Peru', 10, 1 UNION ALL 
SELECT 64, 64, 1, N'Chiny', 10, 1 UNION ALL 
SELECT 65, 65, 1, N'Japonia', 10, 1 UNION ALL 
SELECT 66, 66, 1, N'Indie', 10, 1 UNION ALL 
SELECT 67, 151, 1, N'Kanada', 10, 1 UNION ALL 
SELECT 68, 166, 1, N'Bahamy', 10, 1 UNION ALL 
SELECT 69, 165, 1, N'Belize', 10, 1 UNION ALL 
SELECT 70, 67, 1, N'Tajlandia', 10, 1 UNION ALL 
SELECT 71, 68, 1, N'Izrael', 10, 1 UNION ALL 
SELECT 72, 69, 1, N'Liban', 10, 1 UNION ALL 
SELECT 73, 70, 1, N'Jordania', 10, 1 UNION ALL 
SELECT 74, 71, 1, N'Syria', 10, 1 UNION ALL 
SELECT 75, 72, 1, N'Arabia Saudyjska', 10, 1 UNION ALL 
SELECT 76, 73, 1, N'Jemen', 10, 1 UNION ALL 
SELECT 77, 74, 1, N'Oman', 10, 1 UNION ALL 
SELECT 78, 75, 1, N'Zjednoczone Emiraty Arabskie', 5, 1 UNION ALL 
SELECT 79, 76, 1, N'Kuwejt', 10, 1 UNION ALL 
SELECT 80, 161, 1, N'Dominikana', 10, 1 UNION ALL 
SELECT 81, 144, 1, N'RPA', 10, 1 UNION ALL 
SELECT 82, 144, 1, N'Republika Południowej Afryki', 7, 1 UNION ALL 
SELECT 83, 144, 1, N'Południowa Afryka', 4, 1 UNION ALL 
SELECT 84, 137, 1, N'Kenia', 10, 1 UNION ALL 
SELECT 85, 131, 1, N'Kamerun', 10, 1 UNION ALL 
SELECT 86, 130, 1, N'Nigeria', 10, 1 UNION ALL 
SELECT 87, 111, 1, N'Algieria', 10, 1 UNION ALL 
SELECT 88, 153, 1, N'Grenlandia', 10, 1 UNION ALL 
SELECT 89, 138, 1, N'Tanzania', 10, 1 UNION ALL 
SELECT 90, 124, 1, N'Somalia', 10, 1 UNION ALL 
SELECT 91, 121, 1, N'Gambia', 10, 1 UNION ALL 
SELECT 92, 104, 1, N'Australia', 10, 1 UNION ALL 
SELECT 93, 162, 1, N'Haiti', 10, 1 UNION ALL 
SELECT 94, 163, 1, N'Portoryko', 10, 1 UNION ALL 
SELECT 95, 163, 1, N'Puerto Rico', 5, 1 UNION ALL 
SELECT 96, 164, 1, N'Kostaryka', 10, 1 UNION ALL 
SELECT 97, 143, 1, N'Namibia', 10, 1 UNION ALL 
SELECT 98, 160, 1, N'Panama', 10, 1 UNION ALL 
SELECT 99, 159, 1, N'Nikaragua', 10, 1 UNION ALL 
SELECT 100, 145, 1, N'Zambia', 10, 1 UNION ALL 
SELECT 101, 147, 1, N'Botswana', 10, 1 UNION ALL 
SELECT 102, 77, 1, N'Bahrajn', 10, 1 UNION ALL 
SELECT 103, 78, 1, N'Katar', 10, 1 UNION ALL 
SELECT 104, 79, 1, N'Irak', 10, 1 UNION ALL 
SELECT 105, 80, 1, N'Iran', 10, 1 UNION ALL 
SELECT 106, 81, 1, N'Afganistan', 10, 1 UNION ALL 
SELECT 107, 82, 1, N'Pakistan', 10, 1 UNION ALL 
SELECT 108, 83, 1, N'Uzbekistan', 10, 1 UNION ALL 
SELECT 109, 84, 1, N'Turkmenistan', 10, 1 UNION ALL 
SELECT 110, 85, 1, N'Tadżykistan', 10, 1 UNION ALL 
SELECT 111, 86, 1, N'Kirgistan', 10, 1 UNION ALL 
SELECT 112, 87, 1, N'Nepal', 10, 1 UNION ALL 
SELECT 113, 91, 1, N'Mongolia', 10, 1 UNION ALL 
SELECT 114, 88, 1, N'Bhutan', 10, 1 UNION ALL 
SELECT 115, 89, 1, N'Bangladesz', 10, 1 UNION ALL 
SELECT 116, 90, 1, N'Sri Lanka', 10, 1 UNION ALL 
SELECT 117, 92, 1, N'Laos', 10, 1 UNION ALL 
SELECT 118, 93, 1, N'Kambodża', 10, 1 UNION ALL 
SELECT 119, 94, 1, N'Wietnam', 10, 1 UNION ALL 
SELECT 120, 95, 1, N'Myanmar', 10, 1 UNION ALL 
SELECT 121, 95, 1, N'Birma', 6, 1 UNION ALL 
SELECT 122, 96, 1, N'Korea Południowa', 10, 1 UNION ALL 
SELECT 123, 103, 1, N'Singapur', 10, 1 UNION ALL 
SELECT 124, 102, 1, N'Hongkong', 10, 1 UNION ALL 
SELECT 125, 101, 1, N'Tajwan', 10, 1 UNION ALL 
SELECT 126, 100, 1, N'Filipiny', 10, 1 UNION ALL 
SELECT 127, 99, 1, N'Indonezja', 10, 1 UNION ALL 
SELECT 128, 98, 1, N'Malezja', 10, 1 UNION ALL 
SELECT 129, 97, 1, N'Korea Północna', 10, 1 UNION ALL 
SELECT 130, 105, 1, N'Nowa Zelandia', 10, 1 UNION ALL 
SELECT 131, 106, 1, N'Fidżi', 10, 1 UNION ALL 
SELECT 132, 152, 1, N'Meksyk', 10, 1 UNION ALL 
SELECT 133, 154, 1, N'Jamajka', 10, 1 UNION ALL 
SELECT 134, 155, 1, N'Kuba', 10, 1 UNION ALL 
SELECT 135, 156, 1, N'Honduras', 10, 1 UNION ALL 
SELECT 136, 157, 1, N'Salwador', 10, 1 UNION ALL 
SELECT 137, 158, 1, N'Gwatemala', 10, 1 UNION ALL 
SELECT 138, 142, 1, N'Angola', 10, 1 UNION ALL 
SELECT 139, 127, 1, N'Liberia', 10, 1 UNION ALL 
SELECT 140, 141, 1, N'Madagaskar', 10, 1 UNION ALL 
SELECT 141, 146, 1, N'Zimbabwe', 10, 1 UNION ALL 
SELECT 142, 148, 1, N'Seszele', 10, 1 UNION ALL 
SELECT 143, 149, 1, N'Mauritius', 10, 1 UNION ALL 
SELECT 144, 150, 1, N'USA', 10, 1 UNION ALL 
SELECT 145, 150, 1, N'Stany Zjednoczone', 5, 1 UNION ALL 
SELECT 146, 139, 1, N'Mozambik', 10, 1 UNION ALL 
SELECT 147, 140, 1, N'Ruanda', 10, 1 UNION ALL 
SELECT 148, 140, 1, N'Rwanda', 10, 1 UNION ALL 
SELECT 149, 136, 1, N'Burundi', 10, 1 UNION ALL 
SELECT 150, 135, 1, N'Uganda', 10, 1 UNION ALL 
SELECT 151, 133, 1, N'Kongo', 10, 1 UNION ALL 
SELECT 152, 132, 1, N'Gabon', 10, 1 UNION ALL 
SELECT 153, 134, 1, N'Demokratyczna Republika Konga', 10, 1 UNION ALL 
SELECT 154, 72, 1, N'Arabia', 5, 1 UNION ALL 
SELECT 155, 75, 1, N'Emiraty Arabskie', 10, 1 UNION ALL 
SELECT 156, 75, 1, N'Emiraty', 4, 1 UNION ALL 
SELECT 157, 107, 1, N'Egipt', 10, 1 UNION ALL 
SELECT 158, 108, 1, N'Libia', 10, 1 UNION ALL 
SELECT 159, 109, 1, N'Tunezja', 10, 1 UNION ALL 
SELECT 160, 110, 1, N'Maroko', 10, 1 UNION ALL 
SELECT 161, 112, 1, N'Sudan', 10, 1 UNION ALL 
SELECT 162, 113, 1, N'Etiopia', 10, 1 UNION ALL 
SELECT 163, 114, 1, N'Erytrea', 10, 1 UNION ALL 
SELECT 164, 115, 1, N'Dżibuti', 10, 1 UNION ALL 
SELECT 165, 116, 1, N'Czad', 10, 1 UNION ALL 
SELECT 166, 117, 1, N'Mauretania', 10, 1 UNION ALL 
SELECT 167, 118, 1, N'Burkina Faso', 10, 1 UNION ALL 
SELECT 168, 119, 1, N'Mali', 10, 1 UNION ALL 
SELECT 169, 120, 1, N'Senegal', 10, 1 UNION ALL 
SELECT 170, 122, 1, N'Gwinea', 10, 1 UNION ALL 
SELECT 171, 123, 1, N'Ghana', 10, 1 UNION ALL 
SELECT 172, 125, 1, N'Wybrzeże Kości Słoniowej', 10, 1 UNION ALL 
SELECT 173, 126, 1, N'Togo', 10, 1 UNION ALL 
SELECT 174, 128, 1, N'Sierra Leone', 10, 1 UNION ALL 
SELECT 175, 129, 1, N'Niger', 10, 1 UNION ALL 
SELECT 176, 167, 1, N'Europa', 10, 1 UNION ALL 
SELECT 177, 168, 1, N'Ameryka Południowa', 10, 1 UNION ALL 
SELECT 178, 169, 1, N'Ameryka Północna', 10, 1 UNION ALL 
SELECT 179, 170, 1, N'Afryka', 10, 1 UNION ALL 
SELECT 180, 171, 1, N'Azja', 10, 1 UNION ALL 
SELECT 181, 172, 1, N'Oceania', 10, 1 UNION ALL 
SELECT 182, 173, 1, N'Skandynawia', 10, 1 UNION ALL 
SELECT 183, 174, 1, N'Kaukaz', 10, 1 UNION ALL 
SELECT 184, 175, 1, N'Karaiby', 10, 1 UNION ALL 
SELECT 185, 125, 1, N'WKS', 5, 1 UNION ALL 
SELECT 186, 176, 1, N'kot', 10, 1 UNION ALL 
SELECT 187, 177, 1, N'chomik', 10, 1 UNION ALL 
SELECT 188, 178, 1, N'krowa', 10, 1 UNION ALL 
SELECT 189, 179, 1, N'koń', 10, 1 UNION ALL 
SELECT 190, 180, 1, N'mucha', 10, 1 UNION ALL 
SELECT 191, 181, 1, N'pszczoła', 10, 1 UNION ALL 
SELECT 192, 182, 1, N'osa', 10, 1 UNION ALL 
SELECT 193, 183, 1, N'komar', 10, 1 UNION ALL 
SELECT 194, 184, 1, N'żaba', 10, 1 UNION ALL 
SELECT 195, 185, 1, N'ptak', 10, 1 UNION ALL 
SELECT 196, 186, 1, N'ryba', 10, 1 UNION ALL 
SELECT 197, 187, 1, N'bocian', 10, 1 UNION ALL 
SELECT 198, 188, 1, N'wróbel', 10, 1 UNION ALL 
SELECT 199, 189, 1, N'motyl', 10, 1 UNION ALL 
SELECT 200, 190, 1, N'małpa', 10, 1 UNION ALL 
SELECT 201, 191, 1, N'słoń', 10, 1 UNION ALL 
SELECT 202, 192, 1, N'lew', 10, 1 UNION ALL 
SELECT 203, 193, 1, N'żyrafa', 10, 1 UNION ALL 
SELECT 204, 194, 1, N'wielbłąd', 10, 1 UNION ALL 
SELECT 205, 195, 1, N'tygrys', 10, 1 UNION ALL 
SELECT 206, 196, 1, N'wąż', 10, 1 UNION ALL 
SELECT 207, 197, 1, N'rekin', 10, 1 UNION ALL 
SELECT 208, 198, 1, N'wieloryb', 10, 1 UNION ALL 
SELECT 209, 199, 1, N'osioł', 10, 1 UNION ALL 
SELECT 210, 200, 1, N'owca', 10, 1 UNION ALL 
SELECT 211, 201, 1, N'gołąb', 10, 1 UNION ALL 
SELECT 212, 202, 1, N'sokół', 10, 1 UNION ALL 
SELECT 213, 203, 1, N'orzeł', 10, 1 UNION ALL 
SELECT 214, 204, 1, N'jastrząb', 10, 1 UNION ALL 
SELECT 215, 205, 1, N'Andy', 10, 1 UNION ALL 
SELECT 216, 206, 1, N'Himalaje', 10, 1 UNION ALL 
SELECT 217, 207, 1, N'Alpy', 10, 1 UNION ALL 
SELECT 218, 208, 1, N'Morze Śródziemne', 10, 1 UNION ALL 
SELECT 219, 209, 1, N'Ocean Atlantycki', 5, 1 UNION ALL 
SELECT 220, 210, 1, N'Ocean Spokojny', 10, 1 UNION ALL 
SELECT 221, 211, 1, N'Ocean Indyjski', 10, 1 UNION ALL 
SELECT 222, 212, 1, N'Zatoka Perska', 10, 1 UNION ALL 
SELECT 223, 213, 1, N'Morze Bałtyckie', 10, 1 UNION ALL 
SELECT 224, 214, 1, N'Sardynia', 10, 1 UNION ALL 
SELECT 225, 215, 1, N'Sycylia', 10, 1 UNION ALL 
SELECT 226, 226, 1, N'poniedziałek', 10, 1 UNION ALL 
SELECT 227, 227, 1, N'wtorek', 10, 1 UNION ALL 
SELECT 228, 228, 1, N'środa', 10, 1 UNION ALL 
SELECT 229, 229, 1, N'czwartek', 10, 1 UNION ALL 
SELECT 230, 230, 1, N'piątek', 10, 1 UNION ALL 
SELECT 231, 231, 1, N'sobota', 10, 1 UNION ALL 
SELECT 232, 232, 1, N'niedziela', 10, 1 UNION ALL 
SELECT 233, 233, 1, N'styczeń', 10, 1 UNION ALL 
SELECT 234, 234, 1, N'luty', 10, 1 UNION ALL 
SELECT 235, 235, 1, N'marzec', 10, 1 UNION ALL 
SELECT 236, 236, 1, N'kwiecień', 10, 1 UNION ALL 
SELECT 237, 237, 1, N'maj', 10, 1 UNION ALL 
SELECT 238, 238, 1, N'czerwiec', 10, 1 UNION ALL 
SELECT 239, 239, 1, N'lipiec', 10, 1 UNION ALL 
SELECT 240, 240, 1, N'sierpień', 10, 1 UNION ALL 
SELECT 241, 241, 1, N'wrzesień', 10, 1 UNION ALL 
SELECT 242, 242, 1, N'październik', 10, 1 UNION ALL 
SELECT 243, 243, 1, N'listopad', 10, 1 UNION ALL 
SELECT 244, 244, 1, N'grudzień', 10, 1 UNION ALL 
SELECT 245, 245, 1, N'rok', 10, 1 UNION ALL 
SELECT 246, 246, 1, N'miesiąc', 10, 1 UNION ALL 
SELECT 247, 247, 1, N'dzień', 10, 1 UNION ALL 
SELECT 248, 248, 1, N'tydzień', 10, 1 UNION ALL 
SELECT 249, 249, 1, N'godzina', 10, 1 UNION ALL 
SELECT 250, 250, 1, N'minuta', 10, 1 UNION ALL 
SELECT 251, 251, 1, N'sekunda', 10, 1 UNION ALL 
SELECT 252, 252, 1, N'weekend', 10, 1 UNION ALL 
SELECT 253, 253, 1, N'jutro', 10, 1 UNION ALL 
SELECT 254, 254, 1, N'dzisiaj', 10, 1 UNION ALL 
SELECT 255, 255, 1, N'wczoraj', 10, 1 UNION ALL 
SELECT 256, 256, 1, N'żółw', 10, 1 UNION ALL 
SELECT 257, 257, 1, N'krokodyl', 10, 1 UNION ALL 
SELECT 258, 258, 1, N'kangur', 10, 1 UNION ALL 
SELECT 259, 259, 1, N'gad', 10, 1 UNION ALL 
SELECT 260, 260, 1, N'płaz', 10, 1 UNION ALL 
SELECT 261, 261, 1, N'ssak', 10, 1 UNION ALL 
SELECT 262, 262, 1, N'robak', 10, 1 UNION ALL 
SELECT 263, 263, 1, N'owad', 10, 1 UNION ALL 
SELECT 264, 264, 1, N'jabłko', 10, 1 UNION ALL 
SELECT 265, 265, 1, N'gruszka', 10, 1 UNION ALL 
SELECT 266, 266, 1, N'wiśnia', 10, 1 UNION ALL 
SELECT 267, 267, 1, N'truskawka', 10, 1 UNION ALL 
SELECT 268, 268, 1, N'ananas', 10, 1 UNION ALL 
SELECT 269, 269, 1, N'pomarańcza', 10, 1 UNION ALL 
SELECT 270, 270, 1, N'czereśnia', 10, 1 UNION ALL 
SELECT 271, 271, 1, N'porzeczka', 10, 1 UNION ALL 
SELECT 272, 272, 1, N'malina', 10, 1 UNION ALL 
SELECT 273, 273, 1, N'banan', 10, 1 UNION ALL 
SELECT 274, 276, 1, N'ręka', 10, 1 UNION ALL 
SELECT 275, 285, 1, N'książka', 10, 1 UNION ALL 
SELECT 276, 286, 1, N'gra', 10, 1 UNION ALL 
SELECT 277, 287, 1, N'produkt', 10, 1 UNION ALL 
SELECT 278, 288, 1, N'samochód', 10, 1 UNION ALL 
SELECT 279, 289, 1, N'oprogramowanie', 10, 1 UNION ALL 
SELECT 280, 307, 1, N'telewizja', 10, 1 UNION ALL 
SELECT 281, 308, 1, N'internet', 10, 1 UNION ALL 
SELECT 282, 309, 1, N'prasa', 10, 1 UNION ALL 
SELECT 283, 313, 1, N'hotel', 10, 1 UNION ALL 
SELECT 284, 314, 1, N'prąd', 10, 1 UNION ALL 
SELECT 285, 315, 1, N'telefon', 10, 1 UNION ALL 
SELECT 286, 316, 1, N'ogrzewanie', 10, 1 UNION ALL 
SELECT 287, 317, 1, N'woda', 10, 1 UNION ALL 
SELECT 288, 318, 1, N'gaz', 10, 1 UNION ALL 
SELECT 289, 319, 1, N'samolot', 10, 1 UNION ALL 
SELECT 290, 320, 1, N'pociąg', 10, 1 UNION ALL 
SELECT 291, 321, 1, N'autobus', 10, 1 UNION ALL 
SELECT 292, 322, 1, N'lekcja', 10, 1 UNION ALL 
SELECT 293, 339, 1, N'morze', 10, 1 UNION ALL 
SELECT 294, 340, 1, N'jezioro', 10, 1 UNION ALL 
SELECT 295, 341, 1, N'plaża', 10, 1 UNION ALL 
SELECT 296, 455, 1, N'szpital', 10, 1 UNION ALL 
SELECT 297, 456, 1, N'szkoła', 10, 1 UNION ALL 
SELECT 298, 457, 1, N'poczta', 10, 1 UNION ALL 
SELECT 299, 458, 1, N'policja', 10, 1 UNION ALL 
SELECT 300, 460, 1, N'Oscar', 10, 1 UNION ALL 
SELECT 301, 461, 1, N'Nagroda Nobla', 10, 1 UNION ALL 
SELECT 302, 462, 1, N'strażak', 10, 1 UNION ALL 
SELECT 303, 463, 1, N'lekarz', 10, 1 UNION ALL 
SELECT 304, 464, 1, N'policjant', 10, 1 UNION ALL 
SELECT 305, 465, 1, N'nauczyciel', 10, 1 UNION ALL 
SELECT 306, 466, 1, N'taksówkarz', 10, 1 UNION ALL 
SELECT 307, 467, 1, N'kierowca', 10, 1 UNION ALL 
SELECT 308, 469, 1, N'mieszkanie', 10, 1 UNION ALL 
SELECT 309, 470, 1, N'pokój', 10, 1 UNION ALL 
SELECT 310, 472, 1, N'drzwi', 10, 1 UNION ALL 
SELECT 311, 473, 1, N'okno', 10, 1 UNION ALL 
SELECT 312, 475, 1, N'śniadanie', 10, 1 UNION ALL 
SELECT 313, 476, 1, N'obiad', 10, 1 UNION ALL 
SELECT 314, 485, 1, N'dom', 10, 1 UNION ALL 
SELECT 315, 487, 1, N'brzeg', 10, 1 UNION ALL 
SELECT 316, 496, 1, N'las', 10, 1 UNION ALL 
SELECT 317, 497, 1, N'lotnisko', 10, 1 UNION ALL 
SELECT 318, 498, 1, N'rzeka', 10, 1 UNION ALL 
SELECT 319, 499, 1, N'taksówka', 10, 1 UNION ALL 
SELECT 320, 506, 1, N'wywiad', 10, 1 UNION ALL 
SELECT 321, 507, 1, N'spotkanie', 10, 1 UNION ALL 
SELECT 322, 508, 1, N'debata', 10, 1 UNION ALL 
SELECT 323, 511, 1, N'portfel', 10, 1 UNION ALL 
SELECT 324, 512, 1, N'klucz', 10, 1 UNION ALL 
SELECT 325, 513, 1, N'karta kredytowa', 10, 1 UNION ALL 
SELECT 326, 514, 1, N'lot', 10, 1 UNION ALL 
SELECT 327, 515, 1, N'prezent', 10, 1 UNION ALL 
SELECT 328, 516, 1, N'odpowiedź', 10, 1 UNION ALL 
SELECT 329, 517, 1, N'to', 10, 1 UNION ALL 
SELECT 330, 518, 1, N'komputer', 10, 1 UNION ALL 
SELECT 331, 522, 1, N'gazeta', 10, 1 UNION ALL 
SELECT 332, 523, 1, N'dokument', 10, 1 UNION ALL 
SELECT 333, 524, 1, N'wiersz', 10, 1 UNION ALL 
SELECT 334, 526, 1, N'stół', 10, 1 UNION ALL 
SELECT 335, 527, 1, N'krzesło', 10, 1 UNION ALL 
SELECT 336, 528, 1, N'podłoga', 10, 1 UNION ALL 
SELECT 337, 529, 1, N'łóżko', 10, 1 UNION ALL 
SELECT 338, 543, 1, N'zbrodnia', 10, 1 UNION ALL 
SELECT 339, 544, 1, N'przestępstwo', 10, 1 UNION ALL 
SELECT 340, 545, 1, N'groźba', 10, 1 UNION ALL 
SELECT 341, 546, 1, N'podpucha', 10, 1 UNION ALL 
SELECT 342, 547, 1, N'żart', 10, 1 UNION ALL 
SELECT 343, 548, 1, N'koncert', 10, 1 UNION ALL 
SELECT 344, 549, 1, N'Średniowiecze', 10, 1 UNION ALL 
SELECT 345, 550, 1, N'wojna domowa', 10, 1 UNION ALL 
SELECT 346, 551, 1, N'finał', 10, 1 UNION ALL 
SELECT 347, 553, 1, N'życie', 10, 1 UNION ALL 
SELECT 348, 555, 1, N'skorpion', 10, 1 UNION ALL 
SELECT 349, 556, 1, N'płaszczka', 10, 1 UNION ALL 
SELECT 350, 557, 1, N'meduza', 10, 1 UNION ALL 
SELECT 351, 558, 1, N'szerszeń', 10, 1 UNION ALL 
SELECT 352, 559, 1, N'kleszcz', 10, 1 UNION ALL 
SELECT 353, 560, 1, N'grzechotnik', 10, 1 UNION ALL 
SELECT 354, 561, 1, N'żmija', 10, 1 UNION ALL 
SELECT 355, 562, 1, N'dowód', 10, 1 UNION ALL 
SELECT 356, 563, 1, N'dane', 10, 1 UNION ALL 
SELECT 357, 564, 1, N'statystyka', 10, 1 UNION ALL 
SELECT 358, 567, 1, N'skóra', 10, 1 UNION ALL 
SELECT 359, 568, 1, N'miejsce', 10, 1 UNION ALL 
SELECT 360, 574, 1, N'ujęcie (zdjęcia)', 10, 1 UNION ALL 
SELECT 361, 575, 1, N'wyjaśnienie', 10, 1 UNION ALL 
SELECT 362, 576, 1, N'powód', 10, 1 UNION ALL 
SELECT 363, 577, 1, N'szansa', 10, 1 UNION ALL 
SELECT 364, 578, 1, N'osoba', 10, 1 UNION ALL 
SELECT 365, 579, 1, N'pytanie', 10, 1 UNION ALL 
SELECT 366, 580, 1, N'wymóg', 10, 1 UNION ALL 
SELECT 367, 581, 1, N'różnica', 10, 1 UNION ALL 
SELECT 368, 582, 1, N'problem', 10, 1 UNION ALL 
SELECT 369, 583, 1, N'wybór', 10, 1 UNION ALL 
SELECT 370, 584, 1, N'mapa', 10, 1 UNION ALL 
SELECT 371, 585, 1, N'wykres', 10, 1 UNION ALL 
SELECT 372, 586, 1, N'założenie', 10, 1 UNION ALL 
SELECT 373, 587, 1, N'wynik', 10, 1 UNION ALL 
SELECT 374, 588, 1, N'wynik', 10, 1 UNION ALL 
SELECT 375, 589, 1, N'zdjęcie', 10, 1 UNION ALL 
SELECT 376, 590, 1, N'młotek', 10, 1 UNION ALL 
SELECT 377, 591, 1, N'lina', 10, 1 UNION ALL 
SELECT 378, 592, 1, N'odwaga', 10, 1 UNION ALL 
SELECT 379, 593, 1, N'przyjaciel', 10, 1 UNION ALL 
SELECT 380, 595, 1, N'region', 10, 1 UNION ALL 
SELECT 381, 596, 1, N'miasto', 10, 1 UNION ALL 
SELECT 382, 597, 1, N'głowa', 10, 1 UNION ALL 
SELECT 383, 598, 1, N'noga', 10, 1 UNION ALL 
SELECT 384, 599, 1, N'brzuch', 10, 1 UNION ALL 
SELECT 385, 600, 1, N'włos', 10, 1 UNION ALL 
SELECT 386, 601, 1, N'oko', 10, 1 UNION ALL 
SELECT 387, 602, 1, N'ucho', 10, 1 UNION ALL 
SELECT 388, 603, 1, N'nos', 10, 1 UNION ALL 
SELECT 389, 604, 1, N'paznokieć', 10, 1 UNION ALL 
SELECT 390, 605, 1, N'palec', 10, 1 UNION ALL 
SELECT 391, 606, 1, N'ramię', 10, 1 UNION ALL 
SELECT 392, 607, 1, N'szyja', 10, 1 UNION ALL 
SELECT 393, 608, 1, N'usta', 10, 1 UNION ALL 
SELECT 394, 609, 1, N'ząb', 10, 1 UNION ALL 
SELECT 395, 610, 1, N'język', 10, 1 UNION ALL 
SELECT 396, 611, 1, N'serce', 10, 1 UNION ALL 
SELECT 397, 612, 1, N'wątroba', 10, 1 UNION ALL 
SELECT 398, 613, 1, N'żołądek', 10, 1 UNION ALL 
SELECT 399, 614, 1, N'kolano', 10, 1 UNION ALL 
SELECT 400, 615, 1, N'łokieć', 10, 1 UNION ALL 
SELECT 401, 616, 1, N'stopa', 10, 1 UNION ALL 
SELECT 402, 617, 1, N'pięta', 10, 1 UNION ALL 
SELECT 403, 618, 1, N'policzek', 10, 1 UNION ALL 
SELECT 404, 619, 1, N'brew', 10, 1 UNION ALL 
SELECT 405, 620, 1, N'rzęsa', 10, 1 UNION ALL 
SELECT 406, 621, 1, N'powieka', 10, 1 UNION ALL 
SELECT 407, 622, 1, N'czoło', 10, 1 UNION ALL 
SELECT 408, 623, 1, N'kręgosłup', 10, 1 UNION ALL 
SELECT 409, 624, 1, N'płuco', 10, 1 UNION ALL 
SELECT 410, 625, 1, N'żyła', 10, 1 UNION ALL 
SELECT 411, 626, 1, N'krew', 10, 1 UNION ALL 
SELECT 412, 627, 1, N'gardło', 10, 1 UNION ALL 
SELECT 413, 628, 1, N'mózg', 10, 1 UNION ALL 
SELECT 414, 168, 1, N'Ameryka', 10, 1 UNION ALL 
SELECT 415, 169, 1, N'Ameryka', 10, 1 UNION ALL 
SELECT 416, 213, 1, N'Bałtyk', 10, 1 UNION ALL 
SELECT 417, 209, 1, N'Atlantyk', 10, 1 UNION ALL 
SELECT 418, 210, 1, N'Pacyfik', 10, 1 UNION ALL 
SELECT 419, 629, 1, N'mysz', 10, 1 UNION ALL 
SELECT 420, 630, 1, N'szczur', 10, 1 UNION ALL 
SELECT 421, 631, 1, N'Bałkany', 10, 1 UNION ALL 
SELECT 422, 632, 1, N'palec', 10, 1 UNION ALL 
SELECT 423, 1, 2, N'Poland', 10, 1 UNION ALL 
SELECT 424, 2, 2, N'dog', 10, 1 UNION ALL 
SELECT 425, 3, 2, N'Italy', 10, 1 UNION ALL 
SELECT 426, 4, 2, N'Spain', 10, 1 UNION ALL 
SELECT 427, 5, 2, N'France', 10, 1 UNION ALL 
SELECT 428, 6, 2, N'Germany', 10, 1 UNION ALL 
SELECT 429, 7, 2, N'England', 10, 1 UNION ALL 
SELECT 430, 8, 2, N'Russia', 10, 1 UNION ALL 
SELECT 431, 9, 2, N'Albania', 10, 1 UNION ALL 
SELECT 432, 10, 2, N'Andorra', 10, 1 UNION ALL 
SELECT 433, 11, 2, N'Armenia', 10, 1 UNION ALL 
SELECT 434, 12, 2, N'Austria', 10, 1 UNION ALL 
SELECT 435, 13, 2, N'Azerbaijan', 10, 1 UNION ALL 
SELECT 436, 14, 2, N'Belarus', 10, 1 UNION ALL 
SELECT 437, 15, 2, N'Belgium', 10, 1 UNION ALL 
SELECT 438, 16, 2, N'Bosnia & Herzegovina', 10, 1 UNION ALL 
SELECT 439, 17, 2, N'Bulgaria', 10, 1 UNION ALL 
SELECT 440, 18, 2, N'Croatia', 10, 1 UNION ALL 
SELECT 441, 19, 2, N'Cyprus', 10, 1 UNION ALL 
SELECT 442, 20, 2, N'the Czech Republic', 10, 1 UNION ALL 
SELECT 443, 21, 2, N'Denmark', 10, 1 UNION ALL 
SELECT 444, 22, 2, N'Estonia', 10, 1 UNION ALL 
SELECT 445, 23, 2, N'Finland', 10, 1 UNION ALL 
SELECT 446, 24, 2, N'Georgia', 10, 1 UNION ALL 
SELECT 447, 25, 2, N'Greece', 10, 1 UNION ALL 
SELECT 448, 26, 2, N'Hungary', 10, 1 UNION ALL 
SELECT 449, 27, 2, N'Iceland', 10, 1 UNION ALL 
SELECT 450, 28, 2, N'Ireland', 10, 1 UNION ALL 
SELECT 451, 29, 2, N'Kazakhstan', 10, 1 UNION ALL 
SELECT 452, 30, 2, N'Latvia', 10, 1 UNION ALL 
SELECT 453, 31, 2, N'Liechtenstein', 10, 1 UNION ALL 
SELECT 454, 32, 2, N'Lithuania', 10, 1 UNION ALL 
SELECT 455, 33, 2, N'Luxembourg', 10, 1 UNION ALL 
SELECT 456, 34, 2, N'Macedonia', 10, 1 UNION ALL 
SELECT 457, 35, 2, N'Malta', 10, 1 UNION ALL 
SELECT 458, 36, 2, N'Moldova', 10, 1 UNION ALL 
SELECT 459, 37, 2, N'Monaco', 10, 1 UNION ALL 
SELECT 460, 38, 2, N'Montenegro', 10, 1 UNION ALL 
SELECT 461, 39, 2, N'the Netherlands', 10, 1 UNION ALL 
SELECT 462, 40, 2, N'Norway', 10, 1 UNION ALL 
SELECT 463, 41, 2, N'Portugal', 10, 1 UNION ALL 
SELECT 464, 42, 2, N'Romania', 10, 1 UNION ALL 
SELECT 465, 43, 2, N'San Marino', 10, 1 UNION ALL 
SELECT 466, 44, 2, N'Serbia', 10, 1 UNION ALL 
SELECT 467, 45, 2, N'Slovakia', 10, 1 UNION ALL 
SELECT 468, 46, 2, N'Slovenia', 10, 1 UNION ALL 
SELECT 469, 47, 2, N'Sweden', 10, 1 UNION ALL 
SELECT 470, 48, 2, N'Switzerland', 10, 1 UNION ALL 
SELECT 471, 49, 2, N'Turkey', 10, 1 UNION ALL 
SELECT 472, 50, 2, N'Ukraine', 10, 1 UNION ALL 
SELECT 473, 52, 2, N'Vatican City', 10, 1 UNION ALL 
SELECT 474, 53, 2, N'Scotland', 10, 1 UNION ALL 
SELECT 475, 54, 2, N'Brazil', 10, 1 UNION ALL 
SELECT 476, 55, 2, N'Argentina', 10, 1 UNION ALL 
SELECT 477, 56, 2, N'Peru', 10, 1 UNION ALL 
SELECT 478, 57, 2, N'Bolivia', 10, 1 UNION ALL 
SELECT 479, 58, 2, N'Chile', 10, 1 UNION ALL 
SELECT 480, 59, 2, N'Colombia', 10, 1 UNION ALL 
SELECT 481, 60, 2, N'Venezuela', 10, 1 UNION ALL 
SELECT 482, 61, 2, N'Uruguay', 10, 1 UNION ALL 
SELECT 483, 62, 2, N'Paraguay', 10, 1 UNION ALL 
SELECT 484, 63, 2, N'Ecuador', 10, 1 UNION ALL 
SELECT 485, 64, 2, N'China', 10, 1 UNION ALL 
SELECT 486, 65, 2, N'Japan', 10, 1 UNION ALL 
SELECT 487, 66, 2, N'India', 10, 1 UNION ALL 
SELECT 488, 67, 2, N'Thailand', 10, 1 UNION ALL 
SELECT 489, 68, 2, N'Israel', 10, 1 UNION ALL 
SELECT 490, 69, 2, N'Lebanon', 10, 1 UNION ALL 
SELECT 491, 70, 2, N'Jordan', 10, 1 UNION ALL 
SELECT 492, 71, 2, N'Syria', 10, 1 UNION ALL 
SELECT 493, 72, 2, N'Saudi Arabia', 10, 1 UNION ALL 
SELECT 494, 73, 2, N'Yemen', 10, 1 UNION ALL 
SELECT 495, 74, 2, N'Oman', 10, 1 UNION ALL 
SELECT 496, 75, 2, N'the United Arab Emirates', 6, 1 UNION ALL 
SELECT 497, 76, 2, N'Kuwait', 10, 1 UNION ALL 
SELECT 498, 77, 2, N'Bahrain', 10, 1 UNION ALL 
SELECT 499, 78, 2, N'Qatar', 10, 1 UNION ALL 
SELECT 500, 79, 2, N'Iraq', 10, 1 UNION ALL 
SELECT 501, 80, 2, N'Iran', 10, 1 UNION ALL 
SELECT 502, 81, 2, N'Afghanistan', 10, 1 UNION ALL 
SELECT 503, 82, 2, N'Pakistan', 10, 1 UNION ALL 
SELECT 504, 83, 2, N'Uzbekistan', 10, 1 UNION ALL 
SELECT 505, 84, 2, N'Turkmenistan', 10, 1 UNION ALL 
SELECT 506, 85, 2, N'Tajikistan', 10, 1 UNION ALL 
SELECT 507, 86, 2, N'Kyrgyzstan', 10, 1 UNION ALL 
SELECT 508, 87, 2, N'Nepal', 10, 1 UNION ALL 
SELECT 509, 88, 2, N'Bhutan', 10, 1 UNION ALL 
SELECT 510, 89, 2, N'Bangladesh', 10, 1 UNION ALL 
SELECT 511, 90, 2, N'Sri Lanka', 10, 1 UNION ALL 
SELECT 512, 91, 2, N'Mongolia', 10, 1 UNION ALL 
SELECT 513, 92, 2, N'Laos', 10, 1 UNION ALL 
SELECT 514, 93, 2, N'Cambodia', 10, 1 UNION ALL 
SELECT 515, 94, 2, N'Vietnam', 10, 1 UNION ALL 
SELECT 516, 95, 2, N'Myanmar', 10, 1 UNION ALL 
SELECT 517, 96, 2, N'South Korea', 10, 1 UNION ALL 
SELECT 518, 97, 2, N'North Korea', 10, 1 UNION ALL 
SELECT 519, 98, 2, N'Malaysia', 10, 1 UNION ALL 
SELECT 520, 99, 2, N'Indonesia', 10, 1 UNION ALL 
SELECT 521, 100, 2, N'the Philippines', 10, 1 UNION ALL 
SELECT 522, 101, 2, N'Taiwan', 10, 1 UNION ALL 
SELECT 523, 102, 2, N'Hongkong', 10, 1 UNION ALL 
SELECT 524, 103, 2, N'Singapur', 10, 1 UNION ALL 
SELECT 525, 104, 2, N'Australia', 10, 1 UNION ALL 
SELECT 526, 105, 2, N'New Zealand', 10, 1 UNION ALL 
SELECT 527, 106, 2, N'Fiji', 10, 1 UNION ALL 
SELECT 528, 107, 2, N'Egypt', 10, 1 UNION ALL 
SELECT 529, 108, 2, N'Libya', 10, 1 UNION ALL 
SELECT 530, 109, 2, N'Tunisia', 10, 1 UNION ALL 
SELECT 531, 110, 2, N'Morocco', 10, 1 UNION ALL 
SELECT 532, 111, 2, N'Algeria', 10, 1 UNION ALL 
SELECT 533, 112, 2, N'Sudan', 10, 1 UNION ALL 
SELECT 534, 113, 2, N'Ethiopia', 10, 1 UNION ALL 
SELECT 535, 114, 2, N'Eritrea', 10, 1 UNION ALL 
SELECT 536, 115, 2, N'Djibuti', 10, 1 UNION ALL 
SELECT 537, 116, 2, N'Chad', 10, 1 UNION ALL 
SELECT 538, 117, 2, N'Mauretania', 10, 1 UNION ALL 
SELECT 539, 118, 2, N'Burkina Faso', 10, 1 UNION ALL 
SELECT 540, 119, 2, N'Mali', 10, 1 UNION ALL 
SELECT 541, 120, 2, N'Senegal', 10, 1 UNION ALL 
SELECT 542, 121, 2, N'Gambia', 10, 1 UNION ALL 
SELECT 543, 122, 2, N'Guinea', 10, 1 UNION ALL 
SELECT 544, 123, 2, N'Ghana', 10, 1 UNION ALL 
SELECT 545, 124, 2, N'Somalia', 10, 1 UNION ALL 
SELECT 546, 125, 2, N'Ivory Coast', 10, 1 UNION ALL 
SELECT 547, 126, 2, N'Togo', 10, 1 UNION ALL 
SELECT 548, 127, 2, N'Liberia', 10, 1 UNION ALL 
SELECT 549, 128, 2, N'Sierra Leone', 10, 1 UNION ALL 
SELECT 550, 129, 2, N'Niger', 10, 1 UNION ALL 
SELECT 551, 130, 2, N'Nigeria', 10, 1 UNION ALL 
SELECT 552, 131, 2, N'Cameroon', 10, 1 UNION ALL 
SELECT 553, 132, 2, N'Gabon', 10, 1 UNION ALL 
SELECT 554, 133, 2, N'Congo', 10, 1 UNION ALL 
SELECT 555, 134, 2, N'the Democratic Republic of Congo', 10, 1 UNION ALL 
SELECT 556, 135, 2, N'Uganda', 10, 1 UNION ALL 
SELECT 557, 136, 2, N'Burundi', 10, 1 UNION ALL 
SELECT 558, 137, 2, N'Kenya', 10, 1 UNION ALL 
SELECT 559, 138, 2, N'Tanzania', 10, 1 UNION ALL 
SELECT 560, 139, 2, N'Mozambique', 10, 1 UNION ALL 
SELECT 561, 140, 2, N'Rwanda', 10, 1 UNION ALL 
SELECT 562, 141, 2, N'Madagascar', 10, 1 UNION ALL 
SELECT 563, 142, 2, N'Angola', 10, 1 UNION ALL 
SELECT 564, 143, 2, N'Namibia', 10, 1 UNION ALL 
SELECT 565, 144, 2, N'South Africa', 10, 1 UNION ALL 
SELECT 566, 145, 2, N'Zambia', 10, 1 UNION ALL 
SELECT 567, 146, 2, N'Zimbabwe', 10, 1 UNION ALL 
SELECT 568, 147, 2, N'Botswana', 10, 1 UNION ALL 
SELECT 569, 148, 2, N'the Seychelles', 10, 1 UNION ALL 
SELECT 570, 149, 2, N'Mauritius', 10, 1 UNION ALL 
SELECT 571, 150, 2, N'the USA', 10, 1 UNION ALL 
SELECT 572, 151, 2, N'Canada', 10, 1 UNION ALL 
SELECT 573, 152, 2, N'Mexico', 10, 1 UNION ALL 
SELECT 574, 153, 2, N'Greenland', 10, 1 UNION ALL 
SELECT 575, 154, 2, N'Jamaica', 10, 1 UNION ALL 
SELECT 576, 155, 2, N'Cuba', 10, 1 UNION ALL 
SELECT 577, 156, 2, N'Honduras', 10, 1 UNION ALL 
SELECT 578, 157, 2, N'Salvador', 10, 1 UNION ALL 
SELECT 579, 158, 2, N'Guatemala', 10, 1 UNION ALL 
SELECT 580, 159, 2, N'Nicaragua', 10, 1 UNION ALL 
SELECT 581, 160, 2, N'Panama', 10, 1 UNION ALL 
SELECT 582, 161, 2, N'the Dominican Republic', 10, 1 UNION ALL 
SELECT 583, 162, 2, N'Haiti', 10, 1 UNION ALL 
SELECT 584, 163, 2, N'Puerto Rico', 10, 1 UNION ALL 
SELECT 585, 164, 2, N'Costa Rica', 10, 1 UNION ALL 
SELECT 586, 165, 2, N'Belize', 10, 1 UNION ALL 
SELECT 587, 166, 2, N'the Bahamas', 10, 1 UNION ALL 
SELECT 588, 167, 2, N'Europe', 10, 1 UNION ALL 
SELECT 589, 168, 2, N'South America', 10, 1 UNION ALL 
SELECT 590, 169, 2, N'North America', 10, 1 UNION ALL 
SELECT 591, 170, 2, N'Africa', 10, 1 UNION ALL 
SELECT 592, 171, 2, N'Asia', 10, 1 UNION ALL 
SELECT 593, 172, 2, N'Oceania', 10, 1 UNION ALL 
SELECT 594, 173, 2, N'Scandinavia', 10, 1 UNION ALL 
SELECT 595, 174, 2, N'the Caucasus', 10, 1 UNION ALL 
SELECT 596, 175, 2, N'the Caribbean', 10, 1 UNION ALL 
SELECT 597, 176, 2, N'cat', 10, 1 UNION ALL 
SELECT 598, 177, 2, N'hamster', 10, 1 UNION ALL 
SELECT 599, 178, 2, N'cow', 10, 1 UNION ALL 
SELECT 600, 179, 2, N'horse', 10, 1 UNION ALL 
SELECT 601, 180, 2, N'fly', 10, 1 UNION ALL 
SELECT 602, 181, 2, N'bee', 10, 1 UNION ALL 
SELECT 603, 182, 2, N'wasp', 10, 1 UNION ALL 
SELECT 604, 183, 2, N'mosquito', 10, 1 UNION ALL 
SELECT 605, 184, 2, N'frog', 10, 1 UNION ALL 
SELECT 606, 185, 2, N'bird', 10, 1 UNION ALL 
SELECT 607, 186, 2, N'fish', 10, 1 UNION ALL 
SELECT 608, 187, 2, N'stork', 10, 1 UNION ALL 
SELECT 609, 188, 2, N'sparrow', 10, 1 UNION ALL 
SELECT 610, 189, 2, N'butterfly', 10, 1 UNION ALL 
SELECT 611, 190, 2, N'monkey', 10, 1 UNION ALL 
SELECT 612, 191, 2, N'elephant', 10, 1 UNION ALL 
SELECT 613, 192, 2, N'lion', 10, 1 UNION ALL 
SELECT 614, 193, 2, N'giraffe', 10, 1 UNION ALL 
SELECT 615, 194, 2, N'camel', 10, 1 UNION ALL 
SELECT 616, 195, 2, N'tiger', 10, 1 UNION ALL 
SELECT 617, 196, 2, N'snake', 10, 1 UNION ALL 
SELECT 618, 197, 2, N'shark', 10, 1 UNION ALL 
SELECT 619, 198, 2, N'whale', 10, 1 UNION ALL 
SELECT 620, 199, 2, N'donkey', 10, 1 UNION ALL 
SELECT 621, 200, 2, N'sheep', 10, 1 UNION ALL 
SELECT 622, 201, 2, N'pigeon', 10, 1 UNION ALL 
SELECT 623, 202, 2, N'falcon', 10, 1 UNION ALL 
SELECT 624, 203, 2, N'eagle', 10, 1 UNION ALL 
SELECT 625, 204, 2, N'hawk', 10, 1 UNION ALL 
SELECT 626, 205, 2, N'the Andes', 10, 1 UNION ALL 
SELECT 627, 206, 2, N'the Himalayas', 10, 1 UNION ALL 
SELECT 628, 207, 2, N'the Alps', 10, 1 UNION ALL 
SELECT 629, 208, 2, N'the Mediterranean Sea', 10, 1 UNION ALL 
SELECT 630, 209, 2, N'the Atlantic', 10, 1 UNION ALL 
SELECT 631, 210, 2, N'the Pacific', 10, 1 UNION ALL 
SELECT 632, 211, 2, N'the Indian Ocean', 10, 1 UNION ALL 
SELECT 633, 212, 2, N'the Persian Gulf', 10, 1 UNION ALL 
SELECT 634, 213, 2, N'the Baltic Sea', 10, 1 UNION ALL 
SELECT 635, 214, 2, N'Sardinia', 10, 1 UNION ALL 
SELECT 636, 215, 2, N'Sicily', 10, 1 UNION ALL 
SELECT 637, 226, 2, N'Monday', 10, 1 UNION ALL 
SELECT 638, 227, 2, N'Tuesday', 10, 1 UNION ALL 
SELECT 639, 228, 2, N'Wednesday', 10, 1 UNION ALL 
SELECT 640, 229, 2, N'Thursday', 10, 1 UNION ALL 
SELECT 641, 230, 2, N'Friday', 10, 1 UNION ALL 
SELECT 642, 231, 2, N'Saturday', 10, 1 UNION ALL 
SELECT 643, 232, 2, N'Sunday', 10, 1 UNION ALL 
SELECT 644, 233, 2, N'January', 10, 1 UNION ALL 
SELECT 645, 234, 2, N'February', 10, 1 UNION ALL 
SELECT 646, 235, 2, N'March', 10, 1 UNION ALL 
SELECT 647, 236, 2, N'April', 10, 1 UNION ALL 
SELECT 648, 237, 2, N'May', 10, 1 UNION ALL 
SELECT 649, 238, 2, N'June', 10, 1 UNION ALL 
SELECT 650, 239, 2, N'July', 10, 1 UNION ALL 
SELECT 651, 240, 2, N'August', 10, 1 UNION ALL 
SELECT 652, 241, 2, N'September', 10, 1 UNION ALL 
SELECT 653, 242, 2, N'October', 10, 1 UNION ALL 
SELECT 654, 243, 2, N'November', 10, 1 UNION ALL 
SELECT 655, 244, 2, N'December', 10, 1 UNION ALL 
SELECT 656, 245, 2, N'year', 10, 1 UNION ALL 
SELECT 657, 246, 2, N'month', 10, 1 UNION ALL 
SELECT 658, 247, 2, N'day', 10, 1 UNION ALL 
SELECT 659, 248, 2, N'week', 10, 1 UNION ALL 
SELECT 660, 249, 2, N'hour', 10, 1 UNION ALL 
SELECT 661, 250, 2, N'minute', 10, 1 UNION ALL 
SELECT 662, 251, 2, N'second', 10, 1 UNION ALL 
SELECT 663, 252, 2, N'weekend', 10, 1 UNION ALL 
SELECT 664, 253, 2, N'tomorrow', 10, 1 UNION ALL 
SELECT 665, 254, 2, N'today', 10, 1 UNION ALL 
SELECT 666, 255, 2, N'yesterday', 10, 1 UNION ALL 
SELECT 667, 256, 2, N'turtle', 10, 1 UNION ALL 
SELECT 668, 257, 2, N'crocodile', 10, 1 UNION ALL 
SELECT 669, 258, 2, N'kangaroo', 10, 1 UNION ALL 
SELECT 670, 259, 2, N'reptile', 10, 1 UNION ALL 
SELECT 671, 260, 2, N'amphibian', 10, 1 UNION ALL 
SELECT 672, 261, 2, N'mammal', 10, 1 UNION ALL 
SELECT 673, 262, 2, N'worm', 10, 1 UNION ALL 
SELECT 674, 263, 2, N'insect', 10, 1 UNION ALL 
SELECT 675, 264, 2, N'apple', 10, 1 UNION ALL 
SELECT 676, 265, 2, N'pear', 10, 1 UNION ALL 
SELECT 677, 266, 2, N'cherry', 10, 1 UNION ALL 
SELECT 678, 267, 2, N'strawberry', 10, 1 UNION ALL 
SELECT 679, 268, 2, N'pineapple', 10, 1 UNION ALL 
SELECT 680, 269, 2, N'orange', 10, 1 UNION ALL 
SELECT 681, 270, 2, N'cherry', 10, 1 UNION ALL 
SELECT 682, 271, 2, N'currant', 10, 1 UNION ALL 
SELECT 683, 272, 2, N'raspberry', 10, 1 UNION ALL 
SELECT 684, 273, 2, N'banana', 10, 1 UNION ALL 
SELECT 685, 276, 2, N'hand', 10, 1 UNION ALL 
SELECT 686, 285, 2, N'book', 10, 1 UNION ALL 
SELECT 687, 286, 2, N'game', 10, 1 UNION ALL 
SELECT 688, 287, 2, N'product', 10, 1 UNION ALL 
SELECT 689, 288, 2, N'car', 10, 1 UNION ALL 
SELECT 690, 289, 2, N'software', 10, 1 UNION ALL 
SELECT 691, 307, 2, N'tv', 10, 1 UNION ALL 
SELECT 692, 308, 2, N'internet', 10, 1 UNION ALL 
SELECT 693, 309, 2, N'press', 10, 1 UNION ALL 
SELECT 694, 313, 2, N'hotel', 10, 1 UNION ALL 
SELECT 695, 314, 2, N'electricity', 10, 1 UNION ALL 
SELECT 696, 315, 2, N'phone', 10, 1 UNION ALL 
SELECT 697, 316, 2, N'heating', 10, 1 UNION ALL 
SELECT 698, 317, 2, N'water', 10, 1 UNION ALL 
SELECT 699, 318, 2, N'gas', 10, 1 UNION ALL 
SELECT 700, 319, 2, N'plane', 10, 1 UNION ALL 
SELECT 701, 320, 2, N'train', 10, 1 UNION ALL 
SELECT 702, 321, 2, N'bus', 10, 1 UNION ALL 
SELECT 703, 322, 2, N'lesson', 10, 1 UNION ALL 
SELECT 704, 339, 2, N'sea', 10, 1 UNION ALL 
SELECT 705, 340, 2, N'lake', 10, 1 UNION ALL 
SELECT 706, 341, 2, N'beach', 10, 1 UNION ALL 
SELECT 707, 455, 2, N'hospital', 10, 1 UNION ALL 
SELECT 708, 456, 2, N'school', 10, 1 UNION ALL 
SELECT 709, 457, 2, N'post office', 10, 1 UNION ALL 
SELECT 710, 458, 2, N'police', 10, 1 UNION ALL 
SELECT 711, 460, 2, N'Oscar', 10, 1 UNION ALL 
SELECT 712, 461, 2, N'Nobel Prize', 10, 1 UNION ALL 
SELECT 713, 462, 2, N'fireman', 10, 1 UNION ALL 
SELECT 714, 463, 2, N'doctor', 10, 1 UNION ALL 
SELECT 715, 464, 2, N'police officer', 10, 1 UNION ALL 
SELECT 716, 465, 2, N'teacher', 10, 1 UNION ALL 
SELECT 717, 466, 2, N'taxi driver', 10, 1 UNION ALL 
SELECT 718, 467, 2, N'driver', 10, 1 UNION ALL 
SELECT 719, 469, 2, N'apartment', 10, 0 UNION ALL 
SELECT 720, 470, 2, N'', 10, 0 UNION ALL 
SELECT 721, 472, 2, N'', 10, 0 UNION ALL 
SELECT 722, 473, 2, N'', 10, 0 UNION ALL 
SELECT 723, 475, 2, N'', 10, 0 UNION ALL 
SELECT 724, 476, 2, N'', 10, 0 UNION ALL 
SELECT 725, 485, 2, N'', 10, 0 UNION ALL 
SELECT 726, 487, 2, N'', 10, 0 UNION ALL 
SELECT 727, 496, 2, N'', 10, 0 UNION ALL 
SELECT 728, 497, 2, N'', 10, 0 UNION ALL 
SELECT 729, 498, 2, N'', 10, 0 UNION ALL 
SELECT 730, 499, 2, N'', 10, 0 UNION ALL 
SELECT 731, 506, 2, N'', 10, 0 UNION ALL 
SELECT 732, 507, 2, N'', 10, 0 UNION ALL 
SELECT 733, 508, 2, N'', 10, 0 UNION ALL 
SELECT 734, 511, 2, N'', 10, 0 UNION ALL 
SELECT 735, 512, 2, N'', 10, 0 UNION ALL 
SELECT 736, 513, 2, N'', 10, 0 UNION ALL 
SELECT 737, 514, 2, N'', 10, 0 UNION ALL 
SELECT 738, 515, 2, N'', 10, 0 UNION ALL 
SELECT 739, 516, 2, N'', 10, 0 UNION ALL 
SELECT 740, 517, 2, N'', 10, 0 UNION ALL 
SELECT 741, 518, 2, N'', 10, 0 UNION ALL 
SELECT 742, 522, 2, N'', 10, 0 UNION ALL 
SELECT 743, 523, 2, N'', 10, 0 UNION ALL 
SELECT 744, 524, 2, N'', 10, 0 UNION ALL 
SELECT 745, 526, 2, N'', 10, 0 UNION ALL 
SELECT 746, 527, 2, N'', 10, 0 UNION ALL 
SELECT 747, 528, 2, N'', 10, 0 UNION ALL 
SELECT 748, 529, 2, N'', 10, 0 UNION ALL 
SELECT 749, 543, 2, N'', 10, 0 UNION ALL 
SELECT 750, 544, 2, N'', 10, 0 UNION ALL 
SELECT 751, 545, 2, N'', 10, 0 UNION ALL 
SELECT 752, 546, 2, N'', 10, 0 UNION ALL 
SELECT 753, 547, 2, N'', 10, 0 UNION ALL 
SELECT 754, 548, 2, N'', 10, 0 UNION ALL 
SELECT 755, 549, 2, N'', 10, 0 UNION ALL 
SELECT 756, 550, 2, N'', 10, 0 UNION ALL 
SELECT 757, 551, 2, N'', 10, 0 UNION ALL 
SELECT 758, 553, 2, N'', 10, 0 UNION ALL 
SELECT 759, 555, 2, N'', 10, 0 UNION ALL 
SELECT 760, 556, 2, N'', 10, 0 UNION ALL 
SELECT 761, 557, 2, N'', 10, 0 UNION ALL 
SELECT 762, 558, 2, N'', 10, 0 UNION ALL 
SELECT 763, 559, 2, N'', 10, 0 UNION ALL 
SELECT 764, 560, 2, N'', 10, 0 UNION ALL 
SELECT 765, 561, 2, N'', 10, 0 UNION ALL 
SELECT 766, 562, 2, N'', 10, 0 UNION ALL 
SELECT 767, 563, 2, N'', 10, 0 UNION ALL 
SELECT 768, 564, 2, N'', 10, 0 UNION ALL 
SELECT 769, 567, 2, N'', 10, 0 UNION ALL 
SELECT 770, 568, 2, N'', 10, 0 UNION ALL 
SELECT 771, 574, 2, N'', 10, 0 UNION ALL 
SELECT 772, 575, 2, N'', 10, 0 UNION ALL 
SELECT 773, 576, 2, N'', 10, 0 UNION ALL 
SELECT 774, 577, 2, N'', 10, 0 UNION ALL 
SELECT 775, 578, 2, N'', 10, 0 UNION ALL 
SELECT 776, 579, 2, N'', 10, 0 UNION ALL 
SELECT 777, 580, 2, N'', 10, 0 UNION ALL 
SELECT 778, 581, 2, N'', 10, 0 UNION ALL 
SELECT 779, 582, 2, N'', 10, 0 UNION ALL 
SELECT 780, 583, 2, N'', 10, 0 UNION ALL 
SELECT 781, 584, 2, N'', 10, 0 UNION ALL 
SELECT 782, 585, 2, N'', 10, 0 UNION ALL 
SELECT 783, 586, 2, N'', 10, 0 UNION ALL 
SELECT 784, 587, 2, N'', 10, 0 UNION ALL 
SELECT 785, 588, 2, N'', 10, 0 UNION ALL 
SELECT 786, 589, 2, N'', 10, 0 UNION ALL 
SELECT 787, 590, 2, N'', 10, 0 UNION ALL 
SELECT 788, 591, 2, N'', 10, 0 UNION ALL 
SELECT 789, 592, 2, N'', 10, 0 UNION ALL 
SELECT 790, 593, 2, N'', 10, 0 UNION ALL 
SELECT 791, 595, 2, N'', 10, 0 UNION ALL 
SELECT 792, 596, 2, N'', 10, 0 UNION ALL 
SELECT 793, 597, 2, N'head', 10, 1 UNION ALL 
SELECT 794, 598, 2, N'leg', 10, 1 UNION ALL 
SELECT 795, 599, 2, N'stomach', 10, 1 UNION ALL 
SELECT 796, 600, 2, N'hair', 10, 1 UNION ALL 
SELECT 797, 601, 2, N'eye', 10, 1 UNION ALL 
SELECT 798, 602, 2, N'ear', 10, 1 UNION ALL 
SELECT 799, 603, 2, N'nose', 10, 1 UNION ALL 
SELECT 800, 604, 2, N'nail', 10, 1 UNION ALL 
SELECT 801, 605, 2, N'finger', 10, 1 UNION ALL 
SELECT 802, 606, 2, N'shoulder', 10, 1 UNION ALL 
SELECT 803, 607, 2, N'neck', 10, 1 UNION ALL 
SELECT 804, 608, 2, N'mouth', 10, 1 UNION ALL 
SELECT 805, 609, 2, N'tooth', 10, 1 UNION ALL 
SELECT 806, 610, 2, N'tounge', 10, 1 UNION ALL 
SELECT 807, 611, 2, N'heart', 10, 1 UNION ALL 
SELECT 808, 612, 2, N'liver', 10, 1 UNION ALL 
SELECT 809, 613, 2, N'stomach', 10, 1 UNION ALL 
SELECT 810, 614, 2, N'knee', 10, 1 UNION ALL 
SELECT 811, 615, 2, N'elbow', 10, 1 UNION ALL 
SELECT 812, 616, 2, N'foot', 10, 1 UNION ALL 
SELECT 813, 617, 2, N'heel', 10, 1 UNION ALL 
SELECT 814, 618, 2, N'cheek', 10, 1 UNION ALL 
SELECT 815, 619, 2, N'eyebrow', 10, 1 UNION ALL 
SELECT 816, 620, 2, N'eyelash', 10, 1 UNION ALL 
SELECT 817, 621, 2, N'eyelid', 10, 1 UNION ALL 
SELECT 818, 622, 2, N'forehead', 10, 1 UNION ALL 
SELECT 819, 623, 2, N'spine', 10, 1 UNION ALL 
SELECT 820, 624, 2, N'lung', 10, 1 UNION ALL 
SELECT 821, 625, 2, N'vein', 10, 1 UNION ALL 
SELECT 822, 626, 2, N'blood', 10, 1 UNION ALL 
SELECT 823, 627, 2, N'throat', 10, 1 UNION ALL 
SELECT 824, 628, 2, N'brain', 10, 1 UNION ALL 
SELECT 825, 16, 2, N'Bosnia and Herzegovina', 5, 1 UNION ALL 
SELECT 826, 16, 2, N'Bosnia-Herzegovina', 5, 1 UNION ALL 
SELECT 827, 16, 2, N'Bosnia', 5, 1 UNION ALL 
SELECT 828, 51, 2, N'the United Kingdom', 8, 1 UNION ALL 
SELECT 829, 51, 2, N'the UK', 10, 1 UNION ALL 
SELECT 830, 75, 2, N'the UAE', 8, 1 UNION ALL 
SELECT 831, 75, 2, N'the Emirates', 8, 1 UNION ALL 
SELECT 832, 95, 2, N'Burma', 5, 1 UNION ALL 
SELECT 833, 134, 2, N'DR Congo', 10, 1 UNION ALL 
SELECT 834, 134, 2, N'DRC', 5, 1 UNION ALL 
SELECT 835, 134, 2, N'Congo-Kinshasa', 5, 1 UNION ALL 
SELECT 836, 134, 2, N'Congo-Zaire', 5, 1 UNION ALL 
SELECT 837, 134, 2, N'DROC', 2, 1 UNION ALL 
SELECT 838, 150, 2, N'the United States', 10, 1 UNION ALL 
SELECT 839, 201, 2, N'dove', 10, 1 UNION ALL 
SELECT 840, 629, 2, N'mouse', 10, 1 UNION ALL 
SELECT 841, 630, 2, N'rat', 10, 1 UNION ALL 
SELECT 842, 206, 2, N'Himalaya', 10, 1 UNION ALL 
SELECT 843, 209, 2, N'the Atlantic Ocean', 6, 1 UNION ALL 
SELECT 844, 210, 2, N'the Pacific Ocean', 6, 1 UNION ALL 
SELECT 845, 631, 2, N'the Balkans', 6, 1 UNION ALL 
SELECT 846, 262, 2, N'bug', 7, 1 UNION ALL 
SELECT 847, 276, 2, N'arm', 8, 1 UNION ALL 
SELECT 848, 307, 2, N'television', 8, 1 UNION ALL 
SELECT 849, 319, 2, N'airplane', 10, 1 UNION ALL 
SELECT 850, 632, 2, N'toe', 10, 1 UNION ALL 
SELECT 851, 604, 2, N'fingernail', 5, 1 
COMMIT;
SET IDENTITY_INSERT [dbo].[Words] OFF

GO

-- Funkcja zwracająca język przypisany do danego wyrazu
CREATE FUNCTION [dbo].[checkWordLanguage] (@Word INT) 
RETURNS INT 
AS BEGIN
	DECLARE @Language INT

	SET @Language = (SELECT [w].[LanguageId] FROM [dbo].[Words] AS [w] WHERE [w].[Id] = @Word)

	RETURN @Language

END

GO




-- Właściwości wyrazów
CREATE TABLE [dbo].[WordsProperties] (
      [Id]			INT            IDENTITY (1, 1) NOT NULL
    , [WordId]		INT            NOT NULL
    , [PropertyId]	INT            NOT NULL
    , [ValueId]		INT			   NOT NULL
    , CONSTRAINT [PK_WordsProperties] PRIMARY KEY CLUSTERED ([Id] ASC)
	, CONSTRAINT [U_WordsProperties_WordProperty] UNIQUE NONCLUSTERED ([WordId] ASC, [PropertyId] ASC)
    , CONSTRAINT [FK_WordsProperties_Word] FOREIGN KEY ([WordId]) REFERENCES [dbo].[Words] ([Id])
    , CONSTRAINT [FK_WordsProperties_Property] FOREIGN KEY ([PropertyId]) REFERENCES [dbo].[GrammarPropertyDefinitions] ([Id])
    , CONSTRAINT [FK_WordsProperties_Value] FOREIGN KEY ([ValueId]) REFERENCES [dbo].[GrammarPropertyOptions] ([Id])
    , CONSTRAINT [CH_WordsProperties_MatchProperty] CHECK ([dbo].[checkGrammarOptionProperty]([ValueId]) = [PropertyId])
    , CONSTRAINT [CH_WordsProperties_MatchLanguage] CHECK ([dbo].[checkWordLanguage]([WordId]) = [dbo].[checkGrammarDefinitionLanguage]([PropertyId]))
);


--!!! Dodać constraint, który sprawdza czy PropertyId.Language == WordId.Language

SET IDENTITY_INSERT [dbo].[WordsProperties] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[WordsProperties]([Id], [WordId], [PropertyId], [ValueId])
SELECT 1, 1, 1, 2 UNION ALL 
SELECT 2, 1, 2, 4 UNION ALL 
SELECT 3, 1, 3, 8 UNION ALL 
SELECT 4, 1, 7, 9 UNION ALL 
SELECT 5, 2, 1, 1 UNION ALL 
SELECT 6, 2, 2, 6 UNION ALL 
SELECT 7, 2, 3, 8 UNION ALL 
SELECT 8, 2, 7, 10 UNION ALL 
SELECT 9, 3, 1, 1 UNION ALL 
SELECT 10, 3, 2, 5 UNION ALL 
SELECT 11, 3, 3, 8 UNION ALL 
SELECT 12, 3, 7, 9 UNION ALL 
SELECT 13, 4, 1, 2 UNION ALL 
SELECT 14, 4, 2, 4 UNION ALL 
SELECT 15, 4, 3, 8 UNION ALL 
SELECT 16, 4, 7, 9 UNION ALL 
SELECT 17, 5, 1, 2 UNION ALL 
SELECT 18, 5, 2, 4 UNION ALL 
SELECT 19, 5, 3, 8 UNION ALL 
SELECT 20, 5, 7, 9 UNION ALL 
SELECT 21, 6, 1, 1 UNION ALL 
SELECT 22, 6, 2, 5 UNION ALL 
SELECT 23, 6, 3, 8 UNION ALL 
SELECT 24, 6, 7, 9 UNION ALL 
SELECT 25, 7, 1, 2 UNION ALL 
SELECT 26, 7, 2, 4 UNION ALL 
SELECT 27, 7, 3, 8 UNION ALL 
SELECT 28, 7, 7, 9 UNION ALL 
SELECT 29, 8, 1, 2 UNION ALL 
SELECT 30, 8, 2, 4 UNION ALL 
SELECT 31, 8, 3, 8 UNION ALL 
SELECT 32, 8, 7, 9 UNION ALL 
SELECT 33, 9, 1, 2 UNION ALL 
SELECT 34, 9, 2, 4 UNION ALL 
SELECT 35, 9, 3, 8 UNION ALL 
SELECT 36, 9, 7, 9 UNION ALL 
SELECT 37, 10, 1, 2 UNION ALL 
SELECT 38, 10, 2, 4 UNION ALL 
SELECT 39, 10, 3, 8 UNION ALL 
SELECT 40, 10, 7, 9 UNION ALL 
SELECT 41, 11, 1, 2 UNION ALL 
SELECT 42, 11, 2, 4 UNION ALL 
SELECT 43, 11, 3, 8 UNION ALL 
SELECT 44, 11, 7, 9 UNION ALL 
SELECT 45, 12, 1, 2 UNION ALL 
SELECT 46, 12, 2, 4 UNION ALL 
SELECT 47, 12, 3, 8 UNION ALL 
SELECT 48, 12, 7, 9 UNION ALL 
SELECT 49, 13, 1, 1 UNION ALL 
SELECT 50, 13, 2, 4 UNION ALL 
SELECT 51, 13, 3, 8 UNION ALL 
SELECT 52, 13, 7, 9 UNION ALL 
SELECT 53, 14, 1, 2 UNION ALL 
SELECT 54, 14, 2, 4 UNION ALL 
SELECT 55, 14, 3, 8 UNION ALL 
SELECT 56, 14, 7, 9 UNION ALL 
SELECT 57, 15, 1, 2 UNION ALL 
SELECT 58, 15, 2, 4 UNION ALL 
SELECT 59, 15, 3, 8 UNION ALL 
SELECT 60, 15, 7, 9 UNION ALL 
SELECT 61, 16, 1, 2 UNION ALL 
SELECT 62, 16, 2, 4 UNION ALL 
SELECT 63, 16, 3, 8 UNION ALL 
SELECT 64, 16, 7, 9 UNION ALL 
SELECT 65, 17, 1, 2 UNION ALL 
SELECT 66, 17, 2, 4 UNION ALL 
SELECT 67, 17, 3, 8 UNION ALL 
SELECT 68, 17, 7, 9 UNION ALL 
SELECT 69, 18, 1, 2 UNION ALL 
SELECT 70, 18, 2, 4 UNION ALL 
SELECT 71, 18, 3, 8 UNION ALL 
SELECT 72, 18, 7, 9 UNION ALL 
SELECT 73, 19, 1, 1 UNION ALL 
SELECT 74, 19, 2, 4 UNION ALL 
SELECT 75, 19, 3, 8 UNION ALL 
SELECT 76, 19, 7, 9 UNION ALL 
SELECT 77, 20, 1, 1 UNION ALL 
SELECT 78, 20, 2, 5 UNION ALL 
SELECT 79, 20, 3, 8 UNION ALL 
SELECT 80, 20, 7, 9 UNION ALL 
SELECT 81, 21, 1, 2 UNION ALL 
SELECT 82, 21, 2, 4 UNION ALL 
SELECT 83, 21, 3, 8 UNION ALL 
SELECT 84, 21, 7, 9 UNION ALL 
SELECT 85, 22, 1, 2 UNION ALL 
SELECT 86, 22, 2, 4 UNION ALL 
SELECT 87, 22, 3, 8 UNION ALL 
SELECT 88, 22, 7, 9 UNION ALL 
SELECT 89, 23, 1, 2 UNION ALL 
SELECT 90, 23, 2, 4 UNION ALL 
SELECT 91, 23, 3, 8 UNION ALL 
SELECT 92, 23, 7, 9 UNION ALL 
SELECT 93, 24, 1, 2 UNION ALL 
SELECT 94, 24, 2, 4 UNION ALL 
SELECT 95, 24, 3, 8 UNION ALL 
SELECT 96, 24, 7, 9 UNION ALL 
SELECT 97, 25, 1, 2 UNION ALL 
SELECT 98, 25, 2, 4 UNION ALL 
SELECT 99, 25, 3, 8 UNION ALL 
SELECT 100, 25, 7, 9 UNION ALL 
SELECT 101, 26, 1, 1 UNION ALL 
SELECT 102, 26, 2, 5 UNION ALL 
SELECT 103, 26, 3, 8 UNION ALL 
SELECT 104, 26, 7, 9 UNION ALL 
SELECT 105, 27, 1, 2 UNION ALL 
SELECT 106, 27, 2, 4 UNION ALL 
SELECT 107, 27, 3, 8 UNION ALL 
SELECT 108, 27, 7, 9 UNION ALL 
SELECT 109, 28, 1, 2 UNION ALL 
SELECT 110, 28, 2, 4 UNION ALL 
SELECT 111, 28, 3, 8 UNION ALL 
SELECT 112, 28, 7, 9 UNION ALL 
SELECT 113, 29, 1, 1 UNION ALL 
SELECT 114, 29, 2, 4 UNION ALL 
SELECT 115, 29, 3, 8 UNION ALL 
SELECT 116, 29, 7, 9 UNION ALL 
SELECT 117, 30, 1, 2 UNION ALL 
SELECT 118, 30, 2, 4 UNION ALL 
SELECT 119, 30, 3, 8 UNION ALL 
SELECT 120, 30, 7, 9 UNION ALL 
SELECT 121, 31, 1, 1 UNION ALL 
SELECT 122, 31, 2, 4 UNION ALL 
SELECT 123, 31, 3, 8 UNION ALL 
SELECT 124, 31, 7, 9 UNION ALL 
SELECT 125, 32, 1, 2 UNION ALL 
SELECT 126, 32, 2, 4 UNION ALL 
SELECT 127, 32, 3, 8 UNION ALL 
SELECT 128, 32, 7, 9 UNION ALL 
SELECT 129, 33, 1, 1 UNION ALL 
SELECT 130, 33, 2, 4 UNION ALL 
SELECT 131, 33, 3, 8 UNION ALL 
SELECT 132, 33, 7, 9 UNION ALL 
SELECT 133, 34, 1, 2 UNION ALL 
SELECT 134, 34, 2, 4 UNION ALL 
SELECT 135, 34, 3, 8 UNION ALL 
SELECT 136, 34, 7, 9 UNION ALL 
SELECT 137, 35, 1, 2 UNION ALL 
SELECT 138, 35, 2, 4 UNION ALL 
SELECT 139, 35, 3, 8 UNION ALL 
SELECT 140, 35, 7, 9 UNION ALL 
SELECT 141, 36, 1, 2 UNION ALL 
SELECT 142, 36, 2, 4 UNION ALL 
SELECT 143, 36, 3, 8 UNION ALL 
SELECT 144, 36, 7, 9 UNION ALL 
SELECT 145, 37, 1, 3 UNION ALL 
SELECT 146, 37, 2, 4 UNION ALL 
SELECT 147, 37, 3, 8 UNION ALL 
SELECT 148, 37, 7, 9 UNION ALL 
SELECT 149, 38, 1, 2 UNION ALL 
SELECT 150, 38, 2, 4 UNION ALL 
SELECT 151, 38, 3, 8 UNION ALL 
SELECT 152, 38, 7, 9 UNION ALL 
SELECT 153, 39, 1, 2 UNION ALL 
SELECT 154, 39, 2, 4 UNION ALL 
SELECT 155, 39, 3, 8 UNION ALL 
SELECT 156, 39, 7, 9 UNION ALL 
SELECT 157, 40, 1, 2 UNION ALL 
SELECT 158, 40, 2, 4 UNION ALL 
SELECT 159, 40, 3, 8 UNION ALL 
SELECT 160, 40, 7, 9 UNION ALL 
SELECT 161, 41, 1, 2 UNION ALL 
SELECT 162, 41, 2, 4 UNION ALL 
SELECT 163, 41, 3, 8 UNION ALL 
SELECT 164, 41, 7, 9 UNION ALL 
SELECT 165, 42, 1, 2 UNION ALL 
SELECT 166, 42, 2, 4 UNION ALL 
SELECT 167, 42, 3, 8 UNION ALL 
SELECT 168, 42, 7, 9 UNION ALL 
SELECT 169, 43, 1, 3 UNION ALL 
SELECT 170, 43, 2, 4 UNION ALL 
SELECT 171, 43, 3, 8 UNION ALL 
SELECT 172, 43, 7, 9 UNION ALL 
SELECT 173, 44, 1, 2 UNION ALL 
SELECT 174, 44, 2, 4 UNION ALL 
SELECT 175, 44, 3, 8 UNION ALL 
SELECT 176, 44, 7, 9 UNION ALL 
SELECT 177, 45, 1, 2 UNION ALL 
SELECT 178, 45, 2, 4 UNION ALL 
SELECT 179, 45, 3, 8 UNION ALL 
SELECT 180, 45, 7, 9 UNION ALL 
SELECT 181, 46, 1, 2 UNION ALL 
SELECT 182, 46, 2, 4 UNION ALL 
SELECT 183, 46, 3, 8 UNION ALL 
SELECT 184, 46, 7, 9 UNION ALL 
SELECT 185, 47, 1, 2 UNION ALL 
SELECT 186, 47, 2, 4 UNION ALL 
SELECT 187, 47, 3, 8 UNION ALL 
SELECT 188, 47, 7, 9 UNION ALL 
SELECT 189, 48, 1, 2 UNION ALL 
SELECT 190, 48, 2, 4 UNION ALL 
SELECT 191, 48, 3, 8 UNION ALL 
SELECT 192, 48, 7, 9 UNION ALL 
SELECT 193, 49, 1, 2 UNION ALL 
SELECT 194, 49, 2, 4 UNION ALL 
SELECT 195, 49, 3, 8 UNION ALL 
SELECT 196, 49, 7, 9 UNION ALL 
SELECT 197, 50, 1, 2 UNION ALL 
SELECT 198, 50, 2, 4 UNION ALL 
SELECT 199, 50, 3, 8 UNION ALL 
SELECT 200, 50, 7, 9 UNION ALL 
SELECT 201, 51, 1, 2 UNION ALL 
SELECT 202, 51, 2, 4 UNION ALL 
SELECT 203, 51, 3, 8 UNION ALL 
SELECT 204, 51, 7, 9 UNION ALL 
SELECT 205, 52, 1, 1 UNION ALL 
SELECT 206, 52, 2, 4 UNION ALL 
SELECT 207, 52, 3, 8 UNION ALL 
SELECT 208, 52, 7, 9 UNION ALL 
SELECT 209, 53, 1, 2 UNION ALL 
SELECT 210, 53, 2, 4 UNION ALL 
SELECT 211, 53, 3, 8 UNION ALL 
SELECT 212, 53, 7, 9 UNION ALL 
SELECT 213, 54, 1, 2 UNION ALL 
SELECT 214, 54, 2, 4 UNION ALL 
SELECT 215, 54, 3, 8 UNION ALL 
SELECT 216, 54, 7, 9 UNION ALL 
SELECT 217, 55, 1, 2 UNION ALL 
SELECT 218, 55, 2, 4 UNION ALL 
SELECT 219, 55, 3, 8 UNION ALL 
SELECT 220, 55, 7, 9 UNION ALL 
SELECT 221, 56, 1, 1 UNION ALL 
SELECT 222, 56, 2, 4 UNION ALL 
SELECT 223, 56, 3, 8 UNION ALL 
SELECT 224, 56, 7, 9 UNION ALL 
SELECT 225, 57, 1, 1 UNION ALL 
SELECT 226, 57, 2, 4 UNION ALL 
SELECT 227, 57, 3, 8 UNION ALL 
SELECT 228, 57, 7, 9 UNION ALL 
SELECT 229, 58, 1, 1 UNION ALL 
SELECT 230, 58, 2, 4 UNION ALL 
SELECT 231, 58, 3, 8 UNION ALL 
SELECT 232, 58, 7, 9 UNION ALL 
SELECT 233, 59, 1, 2 UNION ALL 
SELECT 234, 59, 2, 4 UNION ALL 
SELECT 235, 59, 3, 8 UNION ALL 
SELECT 236, 59, 7, 9 UNION ALL 
SELECT 237, 60, 1, 2 UNION ALL 
SELECT 238, 60, 2, 4 UNION ALL 
SELECT 239, 60, 3, 8 UNION ALL 
SELECT 240, 60, 7, 9 UNION ALL 
SELECT 241, 61, 1, 3 UNION ALL 
SELECT 242, 61, 2, 4 UNION ALL 
SELECT 243, 61, 3, 8 UNION ALL 
SELECT 244, 61, 7, 9 UNION ALL 
SELECT 245, 62, 1, 2 UNION ALL 
SELECT 246, 62, 2, 4 UNION ALL 
SELECT 247, 62, 3, 8 UNION ALL 
SELECT 248, 62, 7, 9 UNION ALL 
SELECT 249, 63, 1, 3 UNION ALL 
SELECT 250, 63, 2, 4 UNION ALL 
SELECT 251, 63, 3, 8 UNION ALL 
SELECT 252, 63, 7, 9 UNION ALL 
SELECT 253, 64, 1, 3 UNION ALL 
SELECT 254, 64, 2, 5 UNION ALL 
SELECT 255, 64, 3, 8 UNION ALL 
SELECT 256, 64, 7, 9 UNION ALL 
SELECT 257, 65, 1, 2 UNION ALL 
SELECT 258, 65, 2, 4 UNION ALL 
SELECT 259, 65, 3, 8 UNION ALL 
SELECT 260, 65, 7, 9 UNION ALL 
SELECT 261, 66, 1, 2 UNION ALL 
SELECT 262, 66, 2, 5 UNION ALL 
SELECT 263, 66, 3, 8 UNION ALL 
SELECT 264, 66, 7, 9 UNION ALL 
SELECT 265, 67, 1, 2 UNION ALL 
SELECT 266, 67, 2, 4 UNION ALL 
SELECT 267, 67, 3, 8 UNION ALL 
SELECT 268, 67, 7, 9 UNION ALL 
SELECT 269, 68, 1, 1 UNION ALL 
SELECT 270, 68, 2, 5 UNION ALL 
SELECT 271, 68, 3, 8 UNION ALL 
SELECT 272, 68, 7, 9 UNION ALL 
SELECT 273, 69, 1, 3 UNION ALL 
SELECT 274, 69, 2, 4 UNION ALL 
SELECT 275, 69, 3, 8 UNION ALL 
SELECT 276, 69, 7, 9 UNION ALL 
SELECT 277, 70, 1, 2 UNION ALL 
SELECT 278, 70, 2, 4 UNION ALL 
SELECT 279, 70, 3, 8 UNION ALL 
SELECT 280, 70, 7, 9 UNION ALL 
SELECT 281, 71, 1, 1 UNION ALL 
SELECT 282, 71, 2, 4 UNION ALL 
SELECT 283, 71, 3, 8 UNION ALL 
SELECT 284, 71, 7, 9 UNION ALL 
SELECT 285, 72, 1, 1 UNION ALL 
SELECT 286, 72, 2, 4 UNION ALL 
SELECT 287, 72, 3, 8 UNION ALL 
SELECT 288, 72, 7, 9 UNION ALL 
SELECT 289, 73, 1, 2 UNION ALL 
SELECT 290, 73, 2, 4 UNION ALL 
SELECT 291, 73, 3, 8 UNION ALL 
SELECT 292, 73, 7, 9 UNION ALL 
SELECT 293, 74, 1, 2 UNION ALL 
SELECT 294, 74, 2, 4 UNION ALL 
SELECT 295, 74, 3, 8 UNION ALL 
SELECT 296, 74, 7, 9 UNION ALL 
SELECT 297, 75, 1, 2 UNION ALL 
SELECT 298, 75, 2, 4 UNION ALL 
SELECT 299, 75, 3, 8 UNION ALL 
SELECT 300, 75, 7, 9 UNION ALL 
SELECT 301, 76, 1, 1 UNION ALL 
SELECT 302, 76, 2, 4 UNION ALL 
SELECT 303, 76, 3, 8 UNION ALL 
SELECT 304, 76, 7, 9 UNION ALL 
SELECT 305, 77, 1, 1 UNION ALL 
SELECT 306, 77, 2, 4 UNION ALL 
SELECT 307, 77, 3, 8 UNION ALL 
SELECT 308, 77, 7, 9 UNION ALL 
SELECT 309, 78, 1, 1 UNION ALL 
SELECT 310, 78, 2, 5 UNION ALL 
SELECT 311, 78, 3, 8 UNION ALL 
SELECT 312, 78, 7, 9 UNION ALL 
SELECT 313, 79, 1, 1 UNION ALL 
SELECT 314, 79, 2, 4 UNION ALL 
SELECT 315, 79, 3, 8 UNION ALL 
SELECT 316, 79, 7, 9 UNION ALL 
SELECT 317, 80, 1, 2 UNION ALL 
SELECT 318, 80, 2, 4 UNION ALL 
SELECT 319, 80, 3, 8 UNION ALL 
SELECT 320, 80, 7, 9 UNION ALL 
SELECT 321, 81, 1, 2 UNION ALL 
SELECT 322, 81, 2, 4 UNION ALL 
SELECT 323, 81, 3, 8 UNION ALL 
SELECT 324, 81, 7, 9 UNION ALL 
SELECT 325, 82, 1, 2 UNION ALL 
SELECT 326, 82, 2, 4 UNION ALL 
SELECT 327, 82, 3, 8 UNION ALL 
SELECT 328, 82, 7, 9 UNION ALL 
SELECT 329, 83, 1, 2 UNION ALL 
SELECT 330, 83, 2, 4 UNION ALL 
SELECT 331, 83, 3, 8 UNION ALL 
SELECT 332, 83, 7, 9 UNION ALL 
SELECT 333, 84, 1, 2 UNION ALL 
SELECT 334, 84, 2, 4 UNION ALL 
SELECT 335, 84, 3, 8 UNION ALL 
SELECT 336, 84, 7, 9 UNION ALL 
SELECT 337, 85, 1, 1 UNION ALL 
SELECT 338, 85, 2, 4 UNION ALL 
SELECT 339, 85, 3, 8 UNION ALL 
SELECT 340, 85, 7, 9 UNION ALL 
SELECT 341, 86, 1, 2 UNION ALL 
SELECT 342, 86, 2, 4 UNION ALL 
SELECT 343, 86, 3, 8 UNION ALL 
SELECT 344, 86, 7, 9 UNION ALL 
SELECT 345, 87, 1, 2 UNION ALL 
SELECT 346, 87, 2, 4 UNION ALL 
SELECT 347, 87, 3, 8 UNION ALL 
SELECT 348, 87, 7, 9 UNION ALL 
SELECT 349, 88, 1, 2 UNION ALL 
SELECT 350, 88, 2, 4 UNION ALL 
SELECT 351, 88, 3, 8 UNION ALL 
SELECT 352, 88, 7, 9 UNION ALL 
SELECT 353, 89, 1, 2 UNION ALL 
SELECT 354, 89, 2, 4 UNION ALL 
SELECT 355, 89, 3, 8 UNION ALL 
SELECT 356, 89, 7, 9 UNION ALL 
SELECT 357, 90, 1, 2 UNION ALL 
SELECT 358, 90, 2, 4 UNION ALL 
SELECT 359, 90, 3, 8 UNION ALL 
SELECT 360, 90, 7, 9 UNION ALL 
SELECT 361, 91, 1, 2 UNION ALL 
SELECT 362, 91, 2, 4 UNION ALL 
SELECT 363, 91, 3, 8 UNION ALL 
SELECT 364, 91, 7, 9 UNION ALL 
SELECT 365, 92, 1, 2 UNION ALL 
SELECT 366, 92, 2, 4 UNION ALL 
SELECT 367, 92, 3, 8 UNION ALL 
SELECT 368, 92, 7, 9 UNION ALL 
SELECT 369, 93, 1, 3 UNION ALL 
SELECT 370, 93, 2, 4 UNION ALL 
SELECT 371, 93, 3, 8 UNION ALL 
SELECT 372, 93, 7, 9 UNION ALL 
SELECT 373, 94, 1, 3 UNION ALL 
SELECT 374, 94, 2, 4 UNION ALL 
SELECT 375, 94, 3, 8 UNION ALL 
SELECT 376, 94, 7, 9 UNION ALL 
SELECT 377, 95, 1, 3 UNION ALL 
SELECT 378, 95, 2, 4 UNION ALL 
SELECT 379, 95, 3, 8 UNION ALL 
SELECT 380, 95, 7, 9 UNION ALL 
SELECT 381, 96, 1, 2 UNION ALL 
SELECT 382, 96, 2, 4 UNION ALL 
SELECT 383, 96, 3, 8 UNION ALL 
SELECT 384, 96, 7, 9 UNION ALL 
SELECT 385, 97, 1, 2 UNION ALL 
SELECT 386, 97, 2, 4 UNION ALL 
SELECT 387, 97, 3, 8 UNION ALL 
SELECT 388, 97, 7, 9 UNION ALL 
SELECT 389, 98, 1, 2 UNION ALL 
SELECT 390, 98, 2, 4 UNION ALL 
SELECT 391, 98, 3, 8 UNION ALL 
SELECT 392, 98, 7, 9 UNION ALL 
SELECT 393, 99, 1, 2 UNION ALL 
SELECT 394, 99, 2, 4 UNION ALL 
SELECT 395, 99, 3, 8 UNION ALL 
SELECT 396, 99, 7, 9 UNION ALL 
SELECT 397, 100, 1, 2 UNION ALL 
SELECT 398, 100, 2, 4 UNION ALL 
SELECT 399, 100, 3, 8 UNION ALL 
SELECT 400, 100, 7, 9 UNION ALL 
SELECT 401, 101, 1, 2 UNION ALL 
SELECT 402, 101, 2, 4 UNION ALL 
SELECT 403, 101, 3, 8 UNION ALL 
SELECT 404, 101, 7, 9 UNION ALL 
SELECT 405, 102, 1, 1 UNION ALL 
SELECT 406, 102, 2, 4 UNION ALL 
SELECT 407, 102, 3, 8 UNION ALL 
SELECT 408, 102, 7, 9 UNION ALL 
SELECT 409, 103, 1, 1 UNION ALL 
SELECT 410, 103, 2, 4 UNION ALL 
SELECT 411, 103, 3, 8 UNION ALL 
SELECT 412, 103, 7, 9 UNION ALL 
SELECT 413, 104, 1, 1 UNION ALL 
SELECT 414, 104, 2, 4 UNION ALL 
SELECT 415, 104, 3, 8 UNION ALL 
SELECT 416, 104, 7, 9 UNION ALL 
SELECT 417, 105, 1, 1 UNION ALL 
SELECT 418, 105, 2, 4 UNION ALL 
SELECT 419, 105, 3, 8 UNION ALL 
SELECT 420, 105, 7, 9 UNION ALL 
SELECT 421, 106, 1, 1 UNION ALL 
SELECT 422, 106, 2, 4 UNION ALL 
SELECT 423, 106, 3, 8 UNION ALL 
SELECT 424, 106, 7, 9 UNION ALL 
SELECT 425, 107, 1, 1 UNION ALL 
SELECT 426, 107, 2, 4 UNION ALL 
SELECT 427, 107, 3, 8 UNION ALL 
SELECT 428, 107, 7, 9 UNION ALL 
SELECT 429, 108, 1, 1 UNION ALL 
SELECT 430, 108, 2, 4 UNION ALL 
SELECT 431, 108, 3, 8 UNION ALL 
SELECT 432, 108, 7, 9 UNION ALL 
SELECT 433, 109, 1, 1 UNION ALL 
SELECT 434, 109, 2, 4 UNION ALL 
SELECT 435, 109, 3, 8 UNION ALL 
SELECT 436, 109, 7, 9 UNION ALL 
SELECT 437, 110, 1, 1 UNION ALL 
SELECT 438, 110, 2, 4 UNION ALL 
SELECT 439, 110, 3, 8 UNION ALL 
SELECT 440, 110, 7, 9 UNION ALL 
SELECT 441, 111, 1, 1 UNION ALL 
SELECT 442, 111, 2, 4 UNION ALL 
SELECT 443, 111, 3, 8 UNION ALL 
SELECT 444, 111, 7, 9 UNION ALL 
SELECT 445, 112, 1, 1 UNION ALL 
SELECT 446, 112, 2, 4 UNION ALL 
SELECT 447, 112, 3, 8 UNION ALL 
SELECT 448, 112, 7, 9 UNION ALL 
SELECT 449, 113, 1, 2 UNION ALL 
SELECT 450, 113, 2, 4 UNION ALL 
SELECT 451, 113, 3, 8 UNION ALL 
SELECT 452, 113, 7, 9 UNION ALL 
SELECT 453, 114, 1, 1 UNION ALL 
SELECT 454, 114, 2, 4 UNION ALL 
SELECT 455, 114, 3, 8 UNION ALL 
SELECT 456, 114, 7, 9 UNION ALL 
SELECT 457, 115, 1, 1 UNION ALL 
SELECT 458, 115, 2, 4 UNION ALL 
SELECT 459, 115, 3, 8 UNION ALL 
SELECT 460, 115, 7, 9 UNION ALL 
SELECT 461, 116, 1, 2 UNION ALL 
SELECT 462, 116, 2, 4 UNION ALL 
SELECT 463, 116, 3, 8 UNION ALL 
SELECT 464, 116, 7, 9 UNION ALL 
SELECT 465, 117, 1, 1 UNION ALL 
SELECT 466, 117, 2, 4 UNION ALL 
SELECT 467, 117, 3, 8 UNION ALL 
SELECT 468, 117, 7, 9 UNION ALL 
SELECT 469, 118, 1, 2 UNION ALL 
SELECT 470, 118, 2, 4 UNION ALL 
SELECT 471, 118, 3, 8 UNION ALL 
SELECT 472, 118, 7, 9 UNION ALL 
SELECT 473, 119, 1, 1 UNION ALL 
SELECT 474, 119, 2, 4 UNION ALL 
SELECT 475, 119, 3, 8 UNION ALL 
SELECT 476, 119, 7, 9 UNION ALL 
SELECT 477, 120, 1, 1 UNION ALL 
SELECT 478, 120, 2, 4 UNION ALL 
SELECT 479, 120, 3, 8 UNION ALL 
SELECT 480, 120, 7, 9 UNION ALL 
SELECT 481, 121, 1, 2 UNION ALL 
SELECT 482, 121, 2, 4 UNION ALL 
SELECT 483, 121, 3, 8 UNION ALL 
SELECT 484, 121, 7, 9 UNION ALL 
SELECT 485, 122, 1, 2 UNION ALL 
SELECT 486, 122, 2, 4 UNION ALL 
SELECT 487, 122, 3, 8 UNION ALL 
SELECT 488, 122, 7, 9 UNION ALL 
SELECT 489, 123, 1, 1 UNION ALL 
SELECT 490, 123, 2, 4 UNION ALL 
SELECT 491, 123, 3, 8 UNION ALL 
SELECT 492, 123, 7, 9 UNION ALL 
SELECT 493, 124, 1, 1 UNION ALL 
SELECT 494, 124, 2, 4 UNION ALL 
SELECT 495, 124, 3, 8 UNION ALL 
SELECT 496, 124, 7, 9 UNION ALL 
SELECT 497, 125, 1, 1 UNION ALL 
SELECT 498, 125, 2, 4 UNION ALL 
SELECT 499, 125, 3, 8 UNION ALL 
SELECT 500, 125, 7, 9 UNION ALL 
SELECT 501, 126, 1, 2 UNION ALL 
SELECT 502, 126, 2, 5 UNION ALL 
SELECT 503, 126, 3, 8 UNION ALL 
SELECT 504, 126, 7, 9 UNION ALL 
SELECT 505, 127, 1, 2 UNION ALL 
SELECT 506, 127, 2, 4 UNION ALL 
SELECT 507, 127, 3, 8 UNION ALL 
SELECT 508, 127, 7, 9 UNION ALL 
SELECT 509, 128, 1, 2 UNION ALL 
SELECT 510, 128, 2, 4 UNION ALL 
SELECT 511, 128, 3, 8 UNION ALL 
SELECT 512, 128, 7, 9 UNION ALL 
SELECT 513, 129, 1, 2 UNION ALL 
SELECT 514, 129, 2, 4 UNION ALL 
SELECT 515, 129, 3, 8 UNION ALL 
SELECT 516, 129, 7, 9 UNION ALL 
SELECT 517, 130, 1, 2 UNION ALL 
SELECT 518, 130, 2, 4 UNION ALL 
SELECT 519, 130, 3, 8 UNION ALL 
SELECT 520, 130, 7, 9 UNION ALL 
SELECT 521, 131, 1, 3 UNION ALL 
SELECT 522, 131, 2, 4 UNION ALL 
SELECT 523, 131, 3, 8 UNION ALL 
SELECT 524, 131, 7, 9 UNION ALL 
SELECT 525, 132, 1, 1 UNION ALL 
SELECT 526, 132, 2, 4 UNION ALL 
SELECT 527, 132, 3, 8 UNION ALL 
SELECT 528, 132, 7, 9 UNION ALL 
SELECT 529, 133, 1, 2 UNION ALL 
SELECT 530, 133, 2, 4 UNION ALL 
SELECT 531, 133, 3, 8 UNION ALL 
SELECT 532, 133, 7, 9 UNION ALL 
SELECT 533, 134, 1, 2 UNION ALL 
SELECT 534, 134, 2, 4 UNION ALL 
SELECT 535, 134, 3, 8 UNION ALL 
SELECT 536, 134, 7, 9 UNION ALL 
SELECT 537, 135, 1, 1 UNION ALL 
SELECT 538, 135, 2, 4 UNION ALL 
SELECT 539, 135, 3, 8 UNION ALL 
SELECT 540, 135, 7, 9 UNION ALL 
SELECT 541, 136, 1, 1 UNION ALL 
SELECT 542, 136, 2, 4 UNION ALL 
SELECT 543, 136, 3, 8 UNION ALL 
SELECT 544, 136, 7, 9 UNION ALL 
SELECT 545, 137, 1, 2 UNION ALL 
SELECT 546, 137, 2, 4 UNION ALL 
SELECT 547, 137, 3, 8 UNION ALL 
SELECT 548, 137, 7, 9 UNION ALL 
SELECT 549, 138, 1, 2 UNION ALL 
SELECT 550, 138, 2, 4 UNION ALL 
SELECT 551, 138, 3, 8 UNION ALL 
SELECT 552, 138, 7, 9 UNION ALL 
SELECT 553, 139, 1, 2 UNION ALL 
SELECT 554, 139, 2, 4 UNION ALL 
SELECT 555, 139, 3, 8 UNION ALL 
SELECT 556, 139, 7, 9 UNION ALL 
SELECT 557, 140, 1, 1 UNION ALL 
SELECT 558, 140, 2, 4 UNION ALL 
SELECT 559, 140, 3, 8 UNION ALL 
SELECT 560, 140, 7, 9 UNION ALL 
SELECT 561, 141, 1, 3 UNION ALL 
SELECT 562, 141, 2, 4 UNION ALL 
SELECT 563, 141, 3, 8 UNION ALL 
SELECT 564, 141, 7, 9 UNION ALL 
SELECT 565, 142, 1, 1 UNION ALL 
SELECT 566, 142, 2, 5 UNION ALL 
SELECT 567, 142, 3, 8 UNION ALL 
SELECT 568, 142, 7, 9 UNION ALL 
SELECT 569, 143, 1, 1 UNION ALL 
SELECT 570, 143, 2, 4 UNION ALL 
SELECT 571, 143, 3, 8 UNION ALL 
SELECT 572, 143, 7, 9 UNION ALL 
SELECT 573, 144, 1, 2 UNION ALL 
SELECT 574, 144, 2, 5 UNION ALL 
SELECT 575, 144, 3, 8 UNION ALL 
SELECT 576, 144, 7, 9 UNION ALL 
SELECT 577, 145, 1, 2 UNION ALL 
SELECT 578, 145, 2, 5 UNION ALL 
SELECT 579, 145, 3, 8 UNION ALL 
SELECT 580, 145, 7, 9 UNION ALL 
SELECT 581, 146, 1, 1 UNION ALL 
SELECT 582, 146, 2, 4 UNION ALL 
SELECT 583, 146, 3, 8 UNION ALL 
SELECT 584, 146, 7, 9 UNION ALL 
SELECT 585, 147, 1, 2 UNION ALL 
SELECT 586, 147, 2, 4 UNION ALL 
SELECT 587, 147, 3, 8 UNION ALL 
SELECT 588, 147, 7, 9 UNION ALL 
SELECT 589, 148, 1, 2 UNION ALL 
SELECT 590, 148, 2, 4 UNION ALL 
SELECT 591, 148, 3, 8 UNION ALL 
SELECT 592, 148, 7, 9 UNION ALL 
SELECT 593, 149, 1, 3 UNION ALL 
SELECT 594, 149, 2, 4 UNION ALL 
SELECT 595, 149, 3, 8 UNION ALL 
SELECT 596, 149, 7, 9 UNION ALL 
SELECT 597, 150, 1, 2 UNION ALL 
SELECT 598, 150, 2, 4 UNION ALL 
SELECT 599, 150, 3, 8 UNION ALL 
SELECT 600, 150, 7, 9 UNION ALL 
SELECT 601, 151, 1, 3 UNION ALL 
SELECT 602, 151, 2, 4 UNION ALL 
SELECT 603, 151, 3, 8 UNION ALL 
SELECT 604, 151, 7, 9 UNION ALL 
SELECT 605, 152, 1, 1 UNION ALL 
SELECT 606, 152, 2, 4 UNION ALL 
SELECT 607, 152, 3, 8 UNION ALL 
SELECT 608, 152, 7, 9 UNION ALL 
SELECT 609, 153, 1, 2 UNION ALL 
SELECT 610, 153, 2, 4 UNION ALL 
SELECT 611, 153, 3, 8 UNION ALL 
SELECT 612, 153, 7, 9 UNION ALL 
SELECT 613, 154, 1, 2 UNION ALL 
SELECT 614, 154, 2, 4 UNION ALL 
SELECT 615, 154, 3, 8 UNION ALL 
SELECT 616, 154, 7, 9 UNION ALL 
SELECT 617, 155, 1, 1 UNION ALL 
SELECT 618, 155, 2, 5 UNION ALL 
SELECT 619, 155, 3, 8 UNION ALL 
SELECT 620, 155, 7, 9 UNION ALL 
SELECT 621, 156, 1, 1 UNION ALL 
SELECT 622, 156, 2, 5 UNION ALL 
SELECT 623, 156, 3, 8 UNION ALL 
SELECT 624, 156, 7, 9 UNION ALL 
SELECT 625, 157, 1, 1 UNION ALL 
SELECT 626, 157, 2, 4 UNION ALL 
SELECT 627, 157, 3, 8 UNION ALL 
SELECT 628, 157, 7, 9 UNION ALL 
SELECT 629, 158, 1, 2 UNION ALL 
SELECT 630, 158, 2, 4 UNION ALL 
SELECT 631, 158, 3, 8 UNION ALL 
SELECT 632, 158, 7, 9 UNION ALL 
SELECT 633, 159, 1, 2 UNION ALL 
SELECT 634, 159, 2, 4 UNION ALL 
SELECT 635, 159, 3, 8 UNION ALL 
SELECT 636, 159, 7, 9 UNION ALL 
SELECT 637, 160, 1, 3 UNION ALL 
SELECT 638, 160, 2, 4 UNION ALL 
SELECT 639, 160, 3, 8 UNION ALL 
SELECT 640, 160, 7, 9 UNION ALL 
SELECT 641, 161, 1, 1 UNION ALL 
SELECT 642, 161, 2, 4 UNION ALL 
SELECT 643, 161, 3, 8 UNION ALL 
SELECT 644, 161, 7, 9 UNION ALL 
SELECT 645, 162, 1, 2 UNION ALL 
SELECT 646, 162, 2, 4 UNION ALL 
SELECT 647, 162, 3, 8 UNION ALL 
SELECT 648, 162, 7, 9 UNION ALL 
SELECT 649, 163, 1, 2 UNION ALL 
SELECT 650, 163, 2, 4 UNION ALL 
SELECT 651, 163, 3, 8 UNION ALL 
SELECT 652, 163, 7, 9 UNION ALL 
SELECT 653, 164, 1, 3 UNION ALL 
SELECT 654, 164, 2, 4 UNION ALL 
SELECT 655, 164, 3, 8 UNION ALL 
SELECT 656, 164, 7, 9 UNION ALL 
SELECT 657, 165, 1, 1 UNION ALL 
SELECT 658, 165, 2, 4 UNION ALL 
SELECT 659, 165, 3, 8 UNION ALL 
SELECT 660, 165, 7, 9 UNION ALL 
SELECT 661, 166, 1, 2 UNION ALL 
SELECT 662, 166, 2, 4 UNION ALL 
SELECT 663, 166, 3, 8 UNION ALL 
SELECT 664, 166, 7, 9 UNION ALL 
SELECT 665, 167, 1, 3 UNION ALL 
SELECT 666, 167, 2, 4 UNION ALL 
SELECT 667, 167, 3, 8 UNION ALL 
SELECT 668, 167, 7, 9 UNION ALL 
SELECT 669, 168, 1, 3 UNION ALL 
SELECT 670, 168, 2, 4 UNION ALL 
SELECT 671, 168, 3, 8 UNION ALL 
SELECT 672, 168, 7, 9 UNION ALL 
SELECT 673, 169, 1, 1 UNION ALL 
SELECT 674, 169, 2, 4 UNION ALL 
SELECT 675, 169, 3, 8 UNION ALL 
SELECT 676, 169, 7, 9 UNION ALL 
SELECT 677, 170, 1, 2 UNION ALL 
SELECT 678, 170, 2, 4 UNION ALL 
SELECT 679, 170, 3, 8 UNION ALL 
SELECT 680, 170, 7, 9 UNION ALL 
SELECT 681, 171, 1, 2 UNION ALL 
SELECT 682, 171, 2, 4 UNION ALL 
SELECT 683, 171, 3, 8 UNION ALL 
SELECT 684, 171, 7, 9 UNION ALL 
SELECT 685, 172, 1, 3 UNION ALL 
SELECT 686, 172, 2, 4 UNION ALL 
SELECT 687, 172, 3, 8 UNION ALL 
SELECT 688, 172, 7, 9 UNION ALL 
SELECT 689, 173, 1, 3 UNION ALL 
SELECT 690, 173, 2, 4 UNION ALL 
SELECT 691, 173, 3, 8 UNION ALL 
SELECT 692, 173, 7, 9 UNION ALL 
SELECT 693, 174, 1, 3 UNION ALL 
SELECT 694, 174, 2, 4 UNION ALL 
SELECT 695, 174, 3, 8 UNION ALL 
SELECT 696, 174, 7, 9 UNION ALL 
SELECT 697, 175, 1, 1 UNION ALL 
SELECT 698, 175, 2, 4 UNION ALL 
SELECT 699, 175, 3, 8 UNION ALL 
SELECT 700, 175, 7, 9 UNION ALL 
SELECT 701, 176, 1, 2 UNION ALL 
SELECT 702, 176, 2, 4 UNION ALL 
SELECT 703, 176, 3, 8 UNION ALL 
SELECT 704, 176, 7, 9 UNION ALL 
SELECT 705, 177, 1, 2 UNION ALL 
SELECT 706, 177, 2, 4 UNION ALL 
SELECT 707, 177, 3, 8 UNION ALL 
SELECT 708, 177, 7, 9 UNION ALL 
SELECT 709, 178, 1, 2 UNION ALL 
SELECT 710, 178, 2, 4 UNION ALL 
SELECT 711, 178, 3, 8 UNION ALL 
SELECT 712, 178, 7, 9 UNION ALL 
SELECT 713, 179, 1, 2 UNION ALL 
SELECT 714, 179, 2, 4 UNION ALL 
SELECT 715, 179, 3, 8 UNION ALL 
SELECT 716, 179, 7, 9 UNION ALL 
SELECT 717, 180, 1, 2 UNION ALL 
SELECT 718, 180, 2, 4 UNION ALL 
SELECT 719, 180, 3, 8 UNION ALL 
SELECT 720, 180, 7, 9 UNION ALL 
SELECT 721, 181, 1, 2 UNION ALL 
SELECT 722, 181, 2, 4 UNION ALL 
SELECT 723, 181, 3, 8 UNION ALL 
SELECT 724, 181, 7, 9 UNION ALL 
SELECT 725, 182, 1, 2 UNION ALL 
SELECT 726, 182, 2, 4 UNION ALL 
SELECT 727, 182, 3, 8 UNION ALL 
SELECT 728, 182, 7, 9 UNION ALL 
SELECT 729, 183, 1, 1 UNION ALL 
SELECT 730, 183, 2, 4 UNION ALL 
SELECT 731, 183, 3, 8 UNION ALL 
SELECT 732, 183, 7, 9 UNION ALL 
SELECT 733, 184, 1, 1 UNION ALL 
SELECT 734, 184, 2, 5 UNION ALL 
SELECT 735, 184, 3, 8 UNION ALL 
SELECT 736, 184, 7, 9 UNION ALL 
SELECT 737, 185, 1, 3 UNION ALL 
SELECT 738, 185, 2, 4 UNION ALL 
SELECT 739, 185, 3, 8 UNION ALL 
SELECT 740, 185, 7, 9 UNION ALL 
SELECT 741, 186, 1, 1 UNION ALL 
SELECT 742, 186, 2, 6 UNION ALL 
SELECT 743, 186, 3, 8 UNION ALL 
SELECT 744, 186, 7, 10 UNION ALL 
SELECT 745, 187, 1, 1 UNION ALL 
SELECT 746, 187, 2, 6 UNION ALL 
SELECT 747, 187, 3, 8 UNION ALL 
SELECT 748, 187, 7, 10 UNION ALL 
SELECT 749, 188, 1, 2 UNION ALL 
SELECT 750, 188, 2, 6 UNION ALL 
SELECT 751, 188, 3, 8 UNION ALL 
SELECT 752, 188, 7, 10 UNION ALL 
SELECT 753, 189, 1, 1 UNION ALL 
SELECT 754, 189, 2, 6 UNION ALL 
SELECT 755, 189, 3, 8 UNION ALL 
SELECT 756, 189, 7, 10 UNION ALL 
SELECT 757, 190, 1, 2 UNION ALL 
SELECT 758, 190, 2, 6 UNION ALL 
SELECT 759, 190, 3, 8 UNION ALL 
SELECT 760, 190, 7, 10 UNION ALL 
SELECT 761, 191, 1, 2 UNION ALL 
SELECT 762, 191, 2, 6 UNION ALL 
SELECT 763, 191, 3, 8 UNION ALL 
SELECT 764, 191, 7, 10 UNION ALL 
SELECT 765, 192, 1, 2 UNION ALL 
SELECT 766, 192, 2, 6 UNION ALL 
SELECT 767, 192, 3, 8 UNION ALL 
SELECT 768, 192, 7, 10 UNION ALL 
SELECT 769, 193, 1, 1 UNION ALL 
SELECT 770, 193, 2, 6 UNION ALL 
SELECT 771, 193, 3, 8 UNION ALL 
SELECT 772, 193, 7, 10 UNION ALL 
SELECT 773, 194, 1, 2 UNION ALL 
SELECT 774, 194, 2, 6 UNION ALL 
SELECT 775, 194, 3, 8 UNION ALL 
SELECT 776, 194, 7, 10 UNION ALL 
SELECT 777, 195, 1, 1 UNION ALL 
SELECT 778, 195, 2, 6 UNION ALL 
SELECT 779, 195, 3, 8 UNION ALL 
SELECT 780, 195, 7, 10 UNION ALL 
SELECT 781, 196, 1, 2 UNION ALL 
SELECT 782, 196, 2, 6 UNION ALL 
SELECT 783, 196, 3, 8 UNION ALL 
SELECT 784, 196, 7, 10 UNION ALL 
SELECT 785, 197, 1, 1 UNION ALL 
SELECT 786, 197, 2, 6 UNION ALL 
SELECT 787, 197, 3, 8 UNION ALL 
SELECT 788, 197, 7, 10 UNION ALL 
SELECT 789, 198, 1, 1 UNION ALL 
SELECT 790, 198, 2, 6 UNION ALL 
SELECT 791, 198, 3, 8 UNION ALL 
SELECT 792, 198, 7, 10 UNION ALL 
SELECT 793, 199, 1, 1 UNION ALL 
SELECT 794, 199, 2, 6 UNION ALL 
SELECT 795, 199, 3, 8 UNION ALL 
SELECT 796, 199, 7, 10 UNION ALL 
SELECT 797, 200, 1, 2 UNION ALL 
SELECT 798, 200, 2, 6 UNION ALL 
SELECT 799, 200, 3, 8 UNION ALL 
SELECT 800, 200, 7, 10 UNION ALL 
SELECT 801, 201, 1, 1 UNION ALL 
SELECT 802, 201, 2, 6 UNION ALL 
SELECT 803, 201, 3, 8 UNION ALL 
SELECT 804, 201, 7, 10 UNION ALL 
SELECT 805, 202, 1, 1 UNION ALL 
SELECT 806, 202, 2, 6 UNION ALL 
SELECT 807, 202, 3, 8 UNION ALL 
SELECT 808, 202, 7, 10 UNION ALL 
SELECT 809, 203, 1, 2 UNION ALL 
SELECT 810, 203, 2, 6 UNION ALL 
SELECT 811, 203, 3, 8 UNION ALL 
SELECT 812, 203, 7, 10 UNION ALL 
SELECT 813, 204, 1, 1 UNION ALL 
SELECT 814, 204, 2, 6 UNION ALL 
SELECT 815, 204, 3, 8 UNION ALL 
SELECT 816, 204, 7, 10 UNION ALL 
SELECT 817, 205, 1, 1 UNION ALL 
SELECT 818, 205, 2, 6 UNION ALL 
SELECT 819, 205, 3, 8 UNION ALL 
SELECT 820, 205, 7, 10 UNION ALL 
SELECT 821, 206, 1, 1 UNION ALL 
SELECT 822, 206, 2, 6 UNION ALL 
SELECT 823, 206, 3, 8 UNION ALL 
SELECT 824, 206, 7, 10 UNION ALL 
SELECT 825, 207, 1, 1 UNION ALL 
SELECT 826, 207, 2, 6 UNION ALL 
SELECT 827, 207, 3, 8 UNION ALL 
SELECT 828, 207, 7, 10 UNION ALL 
SELECT 829, 208, 1, 1 UNION ALL 
SELECT 830, 208, 2, 6 UNION ALL 
SELECT 831, 208, 3, 8 UNION ALL 
SELECT 832, 208, 7, 10 UNION ALL 
SELECT 833, 209, 1, 1 UNION ALL 
SELECT 834, 209, 2, 6 UNION ALL 
SELECT 835, 209, 3, 8 UNION ALL 
SELECT 836, 209, 7, 10 UNION ALL 
SELECT 837, 210, 1, 2 UNION ALL 
SELECT 838, 210, 2, 6 UNION ALL 
SELECT 839, 210, 3, 8 UNION ALL 
SELECT 840, 210, 7, 10 UNION ALL 
SELECT 841, 211, 1, 1 UNION ALL 
SELECT 842, 211, 2, 6 UNION ALL 
SELECT 843, 211, 3, 8 UNION ALL 
SELECT 844, 211, 7, 10 UNION ALL 
SELECT 845, 212, 1, 1 UNION ALL 
SELECT 846, 212, 2, 6 UNION ALL 
SELECT 847, 212, 3, 8 UNION ALL 
SELECT 848, 212, 7, 10 UNION ALL 
SELECT 849, 213, 1, 1 UNION ALL 
SELECT 850, 213, 2, 6 UNION ALL 
SELECT 851, 213, 3, 8 UNION ALL 
SELECT 852, 213, 7, 10 UNION ALL 
SELECT 853, 214, 1, 1 UNION ALL 
SELECT 854, 214, 2, 6 UNION ALL 
SELECT 855, 214, 3, 8 UNION ALL 
SELECT 856, 214, 7, 10 UNION ALL 
SELECT 857, 215, 1, 1 UNION ALL 
SELECT 858, 215, 2, 5 UNION ALL 
SELECT 859, 215, 3, 8 UNION ALL 
SELECT 860, 215, 7, 9 UNION ALL 
SELECT 861, 216, 1, 1 UNION ALL 
SELECT 862, 216, 2, 5 UNION ALL 
SELECT 863, 216, 3, 8 UNION ALL 
SELECT 864, 216, 7, 9 UNION ALL 
SELECT 865, 217, 1, 1 UNION ALL 
SELECT 866, 217, 2, 5 UNION ALL 
SELECT 867, 217, 3, 8 UNION ALL 
SELECT 868, 217, 7, 9 UNION ALL 
SELECT 869, 218, 1, 3 UNION ALL 
SELECT 870, 218, 2, 4 UNION ALL 
SELECT 871, 218, 3, 8 UNION ALL 
SELECT 872, 218, 7, 9 UNION ALL 
SELECT 873, 219, 1, 1 UNION ALL 
SELECT 874, 219, 2, 4 UNION ALL 
SELECT 875, 219, 3, 8 UNION ALL 
SELECT 876, 219, 7, 9 UNION ALL 
SELECT 877, 220, 1, 1 UNION ALL 
SELECT 878, 220, 2, 4 UNION ALL 
SELECT 879, 220, 3, 8 UNION ALL 
SELECT 880, 220, 7, 9 UNION ALL 
SELECT 881, 221, 1, 1 UNION ALL 
SELECT 882, 221, 2, 4 UNION ALL 
SELECT 883, 221, 3, 8 UNION ALL 
SELECT 884, 221, 7, 9 UNION ALL 
SELECT 885, 222, 1, 2 UNION ALL 
SELECT 886, 222, 2, 4 UNION ALL 
SELECT 887, 222, 3, 8 UNION ALL 
SELECT 888, 222, 7, 9 UNION ALL 
SELECT 889, 223, 1, 3 UNION ALL 
SELECT 890, 223, 2, 4 UNION ALL 
SELECT 891, 223, 3, 8 UNION ALL 
SELECT 892, 223, 7, 9 UNION ALL 
SELECT 893, 224, 1, 2 UNION ALL 
SELECT 894, 224, 2, 4 UNION ALL 
SELECT 895, 224, 3, 8 UNION ALL 
SELECT 896, 224, 7, 9 UNION ALL 
SELECT 897, 225, 1, 2 UNION ALL 
SELECT 898, 225, 2, 4 UNION ALL 
SELECT 899, 225, 3, 8 UNION ALL 
SELECT 900, 225, 7, 9 UNION ALL 
SELECT 901, 226, 1, 1 UNION ALL 
SELECT 902, 226, 2, 6 UNION ALL 
SELECT 903, 226, 3, 8 UNION ALL 
SELECT 904, 226, 7, 10 UNION ALL 
SELECT 905, 227, 1, 1 UNION ALL 
SELECT 906, 227, 2, 6 UNION ALL 
SELECT 907, 227, 3, 8 UNION ALL 
SELECT 908, 227, 7, 10 UNION ALL 
SELECT 909, 228, 1, 2 UNION ALL 
SELECT 910, 228, 2, 6 UNION ALL 
SELECT 911, 228, 3, 8 UNION ALL 
SELECT 912, 228, 7, 10 UNION ALL 
SELECT 913, 229, 1, 1 UNION ALL 
SELECT 914, 229, 2, 6 UNION ALL 
SELECT 915, 229, 3, 8 UNION ALL 
SELECT 916, 229, 7, 10 UNION ALL 
SELECT 917, 230, 1, 1 UNION ALL 
SELECT 918, 230, 2, 6 UNION ALL 
SELECT 919, 230, 3, 8 UNION ALL 
SELECT 920, 230, 7, 10 UNION ALL 
SELECT 921, 231, 1, 2 UNION ALL 
SELECT 922, 231, 2, 6 UNION ALL 
SELECT 923, 231, 3, 8 UNION ALL 
SELECT 924, 231, 7, 10 UNION ALL 
SELECT 925, 232, 1, 2 UNION ALL 
SELECT 926, 232, 2, 6 UNION ALL 
SELECT 927, 232, 3, 8 UNION ALL 
SELECT 928, 232, 7, 10 UNION ALL 
SELECT 929, 233, 1, 1 UNION ALL 
SELECT 930, 233, 2, 6 UNION ALL 
SELECT 931, 233, 3, 8 UNION ALL 
SELECT 932, 233, 7, 10 UNION ALL 
SELECT 933, 234, 1, 1 UNION ALL 
SELECT 934, 234, 2, 6 UNION ALL 
SELECT 935, 234, 3, 8 UNION ALL 
SELECT 936, 234, 7, 10 UNION ALL 
SELECT 937, 235, 1, 1 UNION ALL 
SELECT 938, 235, 2, 6 UNION ALL 
SELECT 939, 235, 3, 8 UNION ALL 
SELECT 940, 235, 7, 10 UNION ALL 
SELECT 941, 236, 1, 1 UNION ALL 
SELECT 942, 236, 2, 6 UNION ALL 
SELECT 943, 236, 3, 8 UNION ALL 
SELECT 944, 236, 7, 10 UNION ALL 
SELECT 945, 237, 1, 1 UNION ALL 
SELECT 946, 237, 2, 6 UNION ALL 
SELECT 947, 237, 3, 8 UNION ALL 
SELECT 948, 237, 7, 10 UNION ALL 
SELECT 949, 238, 1, 1 UNION ALL 
SELECT 950, 238, 2, 6 UNION ALL 
SELECT 951, 238, 3, 8 UNION ALL 
SELECT 952, 238, 7, 10 UNION ALL 
SELECT 953, 239, 1, 1 UNION ALL 
SELECT 954, 239, 2, 6 UNION ALL 
SELECT 955, 239, 3, 8 UNION ALL 
SELECT 956, 239, 7, 10 UNION ALL 
SELECT 957, 240, 1, 1 UNION ALL 
SELECT 958, 240, 2, 6 UNION ALL 
SELECT 959, 240, 3, 8 UNION ALL 
SELECT 960, 240, 7, 10 UNION ALL 
SELECT 961, 241, 1, 1 UNION ALL 
SELECT 962, 241, 2, 6 UNION ALL 
SELECT 963, 241, 3, 8 UNION ALL 
SELECT 964, 241, 7, 10 UNION ALL 
SELECT 965, 242, 1, 1 UNION ALL 
SELECT 966, 242, 2, 6 UNION ALL 
SELECT 967, 242, 3, 8 UNION ALL 
SELECT 968, 242, 7, 10 UNION ALL 
SELECT 969, 243, 1, 1 UNION ALL 
SELECT 970, 243, 2, 6 UNION ALL 
SELECT 971, 243, 3, 8 UNION ALL 
SELECT 972, 243, 7, 10 UNION ALL 
SELECT 973, 244, 1, 1 UNION ALL 
SELECT 974, 244, 2, 6 UNION ALL 
SELECT 975, 244, 3, 8 UNION ALL 
SELECT 976, 244, 7, 10 UNION ALL 
SELECT 977, 245, 1, 1 UNION ALL 
SELECT 978, 245, 2, 6 UNION ALL 
SELECT 979, 245, 3, 8 UNION ALL 
SELECT 980, 245, 7, 10 UNION ALL 
SELECT 981, 246, 1, 1 UNION ALL 
SELECT 982, 246, 2, 6 UNION ALL 
SELECT 983, 246, 3, 8 UNION ALL 
SELECT 984, 246, 7, 10 UNION ALL 
SELECT 985, 247, 1, 1 UNION ALL 
SELECT 986, 247, 2, 6 UNION ALL 
SELECT 987, 247, 3, 8 UNION ALL 
SELECT 988, 247, 7, 10 UNION ALL 
SELECT 989, 248, 1, 1 UNION ALL 
SELECT 990, 248, 2, 6 UNION ALL 
SELECT 991, 248, 3, 8 UNION ALL 
SELECT 992, 248, 7, 10 UNION ALL 
SELECT 993, 249, 1, 2 UNION ALL 
SELECT 994, 249, 2, 6 UNION ALL 
SELECT 995, 249, 3, 8 UNION ALL 
SELECT 996, 249, 7, 10 UNION ALL 
SELECT 997, 250, 1, 2 UNION ALL 
SELECT 998, 250, 2, 6 UNION ALL 
SELECT 999, 250, 3, 8 UNION ALL 
SELECT 1000, 250, 7, 10 UNION ALL 
SELECT 1001, 251, 1, 2 UNION ALL 
SELECT 1002, 251, 2, 6 UNION ALL 
SELECT 1003, 251, 3, 8 UNION ALL 
SELECT 1004, 251, 7, 10 UNION ALL 
SELECT 1005, 252, 1, 1 UNION ALL 
SELECT 1006, 252, 2, 6 UNION ALL 
SELECT 1007, 252, 3, 8 UNION ALL 
SELECT 1008, 252, 7, 10 UNION ALL 
SELECT 1009, 253, 1, 3 UNION ALL 
SELECT 1010, 253, 2, 4 UNION ALL 
SELECT 1011, 253, 3, 8 UNION ALL 
SELECT 1012, 253, 7, 10 UNION ALL 
SELECT 1013, 254, 1, 3 UNION ALL 
SELECT 1014, 254, 2, 4 UNION ALL 
SELECT 1015, 254, 3, 8 UNION ALL 
SELECT 1016, 254, 7, 10 UNION ALL 
SELECT 1017, 255, 1, 3 UNION ALL 
SELECT 1018, 255, 2, 4 UNION ALL 
SELECT 1019, 255, 3, 8 UNION ALL 
SELECT 1020, 255, 7, 10 UNION ALL 
SELECT 1021, 256, 1, 1 UNION ALL 
SELECT 1022, 256, 2, 6 UNION ALL 
SELECT 1023, 256, 3, 8 UNION ALL 
SELECT 1024, 256, 7, 10 UNION ALL 
SELECT 1025, 257, 1, 1 UNION ALL 
SELECT 1026, 257, 2, 6 UNION ALL 
SELECT 1027, 257, 3, 8 UNION ALL 
SELECT 1028, 257, 7, 10 UNION ALL 
SELECT 1029, 258, 1, 1 UNION ALL 
SELECT 1030, 258, 2, 6 UNION ALL 
SELECT 1031, 258, 3, 8 UNION ALL 
SELECT 1032, 258, 7, 10 UNION ALL 
SELECT 1033, 259, 1, 1 UNION ALL 
SELECT 1034, 259, 2, 6 UNION ALL 
SELECT 1035, 259, 3, 8 UNION ALL 
SELECT 1036, 259, 7, 10 UNION ALL 
SELECT 1037, 260, 1, 1 UNION ALL 
SELECT 1038, 260, 2, 6 UNION ALL 
SELECT 1039, 260, 3, 8 UNION ALL 
SELECT 1040, 260, 7, 10 UNION ALL 
SELECT 1041, 261, 1, 1 UNION ALL 
SELECT 1042, 261, 2, 6 UNION ALL 
SELECT 1043, 261, 3, 8 UNION ALL 
SELECT 1044, 261, 7, 10 UNION ALL 
SELECT 1045, 262, 1, 1 UNION ALL 
SELECT 1046, 262, 2, 6 UNION ALL 
SELECT 1047, 262, 3, 8 UNION ALL 
SELECT 1048, 262, 7, 10 UNION ALL 
SELECT 1049, 263, 1, 1 UNION ALL 
SELECT 1050, 263, 2, 6 UNION ALL 
SELECT 1051, 263, 3, 8 UNION ALL 
SELECT 1052, 263, 7, 10 UNION ALL 
SELECT 1053, 264, 1, 3 UNION ALL 
SELECT 1054, 264, 2, 6 UNION ALL 
SELECT 1055, 264, 3, 8 UNION ALL 
SELECT 1056, 264, 7, 10 UNION ALL 
SELECT 1057, 265, 1, 2 UNION ALL 
SELECT 1058, 265, 2, 6 UNION ALL 
SELECT 1059, 265, 3, 8 UNION ALL 
SELECT 1060, 265, 7, 10 UNION ALL 
SELECT 1061, 266, 1, 2 UNION ALL 
SELECT 1062, 266, 2, 6 UNION ALL 
SELECT 1063, 266, 3, 8 UNION ALL 
SELECT 1064, 266, 7, 10 UNION ALL 
SELECT 1065, 267, 1, 2 UNION ALL 
SELECT 1066, 267, 2, 6 UNION ALL 
SELECT 1067, 267, 3, 8 UNION ALL 
SELECT 1068, 267, 7, 10 UNION ALL 
SELECT 1069, 268, 1, 1 UNION ALL 
SELECT 1070, 268, 2, 6 UNION ALL 
SELECT 1071, 268, 3, 8 UNION ALL 
SELECT 1072, 268, 7, 10 UNION ALL 
SELECT 1073, 269, 1, 2 UNION ALL 
SELECT 1074, 269, 2, 6 UNION ALL 
SELECT 1075, 269, 3, 8 UNION ALL 
SELECT 1076, 269, 7, 10 UNION ALL 
SELECT 1077, 270, 1, 2 UNION ALL 
SELECT 1078, 270, 2, 6 UNION ALL 
SELECT 1079, 270, 3, 8 UNION ALL 
SELECT 1080, 270, 7, 10 UNION ALL 
SELECT 1081, 271, 1, 2 UNION ALL 
SELECT 1082, 271, 2, 6 UNION ALL 
SELECT 1083, 271, 3, 8 UNION ALL 
SELECT 1084, 271, 7, 10 UNION ALL 
SELECT 1085, 272, 1, 2 UNION ALL 
SELECT 1086, 272, 2, 6 UNION ALL 
SELECT 1087, 272, 3, 8 UNION ALL 
SELECT 1088, 272, 7, 10 UNION ALL 
SELECT 1089, 273, 1, 1 UNION ALL 
SELECT 1090, 273, 2, 6 UNION ALL 
SELECT 1091, 273, 3, 8 UNION ALL 
SELECT 1092, 273, 7, 10 UNION ALL 
SELECT 1093, 274, 1, 2 UNION ALL 
SELECT 1094, 274, 2, 6 UNION ALL 
SELECT 1095, 274, 3, 8 UNION ALL 
SELECT 1096, 274, 7, 10 UNION ALL 
SELECT 1097, 275, 1, 2 UNION ALL 
SELECT 1098, 275, 2, 6 UNION ALL 
SELECT 1099, 275, 3, 8 UNION ALL 
SELECT 1100, 275, 7, 10 UNION ALL 
SELECT 1101, 276, 1, 2 UNION ALL 
SELECT 1102, 276, 2, 6 UNION ALL 
SELECT 1103, 276, 3, 8 UNION ALL 
SELECT 1104, 276, 7, 10 UNION ALL 
SELECT 1105, 277, 1, 1 UNION ALL 
SELECT 1106, 277, 2, 6 UNION ALL 
SELECT 1107, 277, 3, 8 UNION ALL 
SELECT 1108, 277, 7, 10 UNION ALL 
SELECT 1109, 278, 1, 1 UNION ALL 
SELECT 1110, 278, 2, 6 UNION ALL 
SELECT 1111, 278, 3, 8 UNION ALL 
SELECT 1112, 278, 7, 10 UNION ALL 
SELECT 1113, 279, 1, 3 UNION ALL 
SELECT 1114, 279, 2, 6 UNION ALL 
SELECT 1115, 279, 3, 8 UNION ALL 
SELECT 1116, 279, 7, 10 UNION ALL 
SELECT 1117, 280, 1, 2 UNION ALL 
SELECT 1118, 280, 2, 6 UNION ALL 
SELECT 1119, 280, 3, 8 UNION ALL 
SELECT 1120, 280, 7, 10 UNION ALL 
SELECT 1121, 281, 1, 1 UNION ALL 
SELECT 1122, 281, 2, 4 UNION ALL 
SELECT 1123, 281, 3, 8 UNION ALL 
SELECT 1124, 281, 7, 10 UNION ALL 
SELECT 1125, 282, 1, 2 UNION ALL 
SELECT 1126, 282, 2, 6 UNION ALL 
SELECT 1127, 282, 3, 8 UNION ALL 
SELECT 1128, 282, 7, 10 UNION ALL 
SELECT 1129, 283, 1, 1 UNION ALL 
SELECT 1130, 283, 2, 6 UNION ALL 
SELECT 1131, 283, 3, 8 UNION ALL 
SELECT 1132, 283, 7, 9 UNION ALL 
SELECT 1133, 284, 1, 1 UNION ALL 
SELECT 1134, 284, 2, 6 UNION ALL 
SELECT 1135, 284, 3, 8 UNION ALL 
SELECT 1136, 284, 7, 10 UNION ALL 
SELECT 1137, 285, 1, 1 UNION ALL 
SELECT 1138, 285, 2, 6 UNION ALL 
SELECT 1139, 285, 3, 8 UNION ALL 
SELECT 1140, 285, 7, 10 UNION ALL 
SELECT 1141, 286, 1, 3 UNION ALL 
SELECT 1142, 286, 2, 6 UNION ALL 
SELECT 1143, 286, 3, 8 UNION ALL 
SELECT 1144, 286, 7, 10 UNION ALL 
SELECT 1145, 287, 1, 2 UNION ALL 
SELECT 1146, 287, 2, 6 UNION ALL 
SELECT 1147, 287, 3, 8 UNION ALL 
SELECT 1148, 287, 7, 10 UNION ALL 
SELECT 1149, 288, 1, 1 UNION ALL 
SELECT 1150, 288, 2, 6 UNION ALL 
SELECT 1151, 288, 3, 8 UNION ALL 
SELECT 1152, 288, 7, 10 UNION ALL 
SELECT 1153, 289, 1, 1 UNION ALL 
SELECT 1154, 289, 2, 6 UNION ALL 
SELECT 1155, 289, 3, 8 UNION ALL 
SELECT 1156, 289, 7, 10 UNION ALL 
SELECT 1157, 290, 1, 1 UNION ALL 
SELECT 1158, 290, 2, 6 UNION ALL 
SELECT 1159, 290, 3, 8 UNION ALL 
SELECT 1160, 290, 7, 10 UNION ALL 
SELECT 1161, 291, 1, 1 UNION ALL 
SELECT 1162, 291, 2, 6 UNION ALL 
SELECT 1163, 291, 3, 8 UNION ALL 
SELECT 1164, 291, 7, 10 UNION ALL 
SELECT 1165, 292, 1, 2 UNION ALL 
SELECT 1166, 292, 2, 6 UNION ALL 
SELECT 1167, 292, 3, 8 UNION ALL 
SELECT 1168, 292, 7, 10 UNION ALL 
SELECT 1169, 293, 1, 3 UNION ALL 
SELECT 1170, 293, 2, 6 UNION ALL 
SELECT 1171, 293, 3, 8 UNION ALL 
SELECT 1172, 293, 7, 9 UNION ALL 
SELECT 1173, 294, 1, 3 UNION ALL 
SELECT 1174, 294, 2, 6 UNION ALL 
SELECT 1175, 294, 3, 8 UNION ALL 
SELECT 1176, 294, 7, 9 UNION ALL 
SELECT 1177, 295, 1, 2 UNION ALL 
SELECT 1178, 295, 2, 6 UNION ALL 
SELECT 1179, 295, 3, 8 UNION ALL 
SELECT 1180, 295, 7, 9 UNION ALL 
SELECT 1181, 296, 1, 1 UNION ALL 
SELECT 1182, 296, 2, 6 UNION ALL 
SELECT 1183, 296, 3, 8 UNION ALL 
SELECT 1184, 296, 7, 9 UNION ALL 
SELECT 1185, 297, 1, 2 UNION ALL 
SELECT 1186, 297, 2, 6 UNION ALL 
SELECT 1187, 297, 3, 8 UNION ALL 
SELECT 1188, 297, 7, 9 UNION ALL 
SELECT 1189, 298, 1, 2 UNION ALL 
SELECT 1190, 298, 2, 6 UNION ALL 
SELECT 1191, 298, 3, 8 UNION ALL 
SELECT 1192, 298, 7, 9 UNION ALL 
SELECT 1193, 299, 1, 2 UNION ALL 
SELECT 1194, 299, 2, 6 UNION ALL 
SELECT 1195, 299, 3, 8 UNION ALL 
SELECT 1196, 299, 7, 10 UNION ALL 
SELECT 1197, 300, 1, 1 UNION ALL 
SELECT 1198, 300, 2, 6 UNION ALL 
SELECT 1199, 300, 3, 8 UNION ALL 
SELECT 1200, 300, 7, 10 UNION ALL 
SELECT 1201, 301, 1, 2 UNION ALL 
SELECT 1202, 301, 2, 6 UNION ALL 
SELECT 1203, 301, 3, 8 UNION ALL 
SELECT 1204, 301, 7, 10 UNION ALL 
SELECT 1205, 302, 1, 1 UNION ALL 
SELECT 1206, 302, 2, 6 UNION ALL 
SELECT 1207, 302, 3, 7 UNION ALL 
SELECT 1208, 302, 7, 10 UNION ALL 
SELECT 1209, 303, 1, 1 UNION ALL 
SELECT 1210, 303, 2, 6 UNION ALL 
SELECT 1211, 303, 3, 7 UNION ALL 
SELECT 1212, 303, 7, 10 UNION ALL 
SELECT 1213, 304, 1, 1 UNION ALL 
SELECT 1214, 304, 2, 6 UNION ALL 
SELECT 1215, 304, 3, 7 UNION ALL 
SELECT 1216, 304, 7, 10 UNION ALL 
SELECT 1217, 305, 1, 1 UNION ALL 
SELECT 1218, 305, 2, 6 UNION ALL 
SELECT 1219, 305, 3, 7 UNION ALL 
SELECT 1220, 305, 7, 10 UNION ALL 
SELECT 1221, 306, 1, 1 UNION ALL 
SELECT 1222, 306, 2, 6 UNION ALL 
SELECT 1223, 306, 3, 7 UNION ALL 
SELECT 1224, 306, 7, 10 UNION ALL 
SELECT 1225, 307, 1, 1 UNION ALL 
SELECT 1226, 307, 2, 6 UNION ALL 
SELECT 1227, 307, 3, 7 UNION ALL 
SELECT 1228, 307, 7, 10 UNION ALL 
SELECT 1229, 308, 1, 3 UNION ALL 
SELECT 1230, 308, 2, 6 UNION ALL 
SELECT 1231, 308, 3, 8 UNION ALL 
SELECT 1232, 308, 7, 9 UNION ALL 
SELECT 1233, 309, 1, 1 UNION ALL 
SELECT 1234, 309, 2, 6 UNION ALL 
SELECT 1235, 309, 3, 8 UNION ALL 
SELECT 1236, 309, 7, 9 UNION ALL 
SELECT 1237, 310, 1, 1 UNION ALL 
SELECT 1238, 310, 2, 5 UNION ALL 
SELECT 1239, 310, 3, 8 UNION ALL 
SELECT 1240, 310, 7, 10 UNION ALL 
SELECT 1241, 311, 1, 3 UNION ALL 
SELECT 1242, 311, 2, 6 UNION ALL 
SELECT 1243, 311, 3, 8 UNION ALL 
SELECT 1244, 311, 7, 10 UNION ALL 
SELECT 1245, 312, 1, 3 UNION ALL 
SELECT 1246, 312, 2, 6 UNION ALL 
SELECT 1247, 312, 3, 8 UNION ALL 
SELECT 1248, 312, 7, 10 UNION ALL 
SELECT 1249, 313, 1, 1 UNION ALL 
SELECT 1250, 313, 2, 6 UNION ALL 
SELECT 1251, 313, 3, 8 UNION ALL 
SELECT 1252, 313, 7, 10 UNION ALL 
SELECT 1253, 314, 1, 1 UNION ALL 
SELECT 1254, 314, 2, 6 UNION ALL 
SELECT 1255, 314, 3, 8 UNION ALL 
SELECT 1256, 314, 7, 9 UNION ALL 
SELECT 1257, 315, 1, 1 UNION ALL 
SELECT 1258, 315, 2, 6 UNION ALL 
SELECT 1259, 315, 3, 8 UNION ALL 
SELECT 1260, 315, 7, 9 UNION ALL 
SELECT 1261, 316, 1, 1 UNION ALL 
SELECT 1262, 316, 2, 6 UNION ALL 
SELECT 1263, 316, 3, 8 UNION ALL 
SELECT 1264, 316, 7, 9 UNION ALL 
SELECT 1265, 317, 1, 3 UNION ALL 
SELECT 1266, 317, 2, 6 UNION ALL 
SELECT 1267, 317, 3, 8 UNION ALL 
SELECT 1268, 317, 7, 9 UNION ALL 
SELECT 1269, 318, 1, 2 UNION ALL 
SELECT 1270, 318, 2, 6 UNION ALL 
SELECT 1271, 318, 3, 8 UNION ALL 
SELECT 1272, 318, 7, 9 UNION ALL 
SELECT 1273, 319, 1, 2 UNION ALL 
SELECT 1274, 319, 2, 6 UNION ALL 
SELECT 1275, 319, 3, 8 UNION ALL 
SELECT 1276, 319, 7, 9 UNION ALL 
SELECT 1277, 320, 1, 1 UNION ALL 
SELECT 1278, 320, 2, 6 UNION ALL 
SELECT 1279, 320, 3, 8 UNION ALL 
SELECT 1280, 320, 7, 10 UNION ALL 
SELECT 1281, 321, 1, 3 UNION ALL 
SELECT 1282, 321, 2, 6 UNION ALL 
SELECT 1283, 321, 3, 8 UNION ALL 
SELECT 1284, 321, 7, 10 UNION ALL 
SELECT 1285, 322, 1, 2 UNION ALL 
SELECT 1286, 322, 2, 6 UNION ALL 
SELECT 1287, 322, 3, 8 UNION ALL 
SELECT 1288, 322, 7, 10 UNION ALL 
SELECT 1289, 323, 1, 1 UNION ALL 
SELECT 1290, 323, 2, 6 UNION ALL 
SELECT 1291, 323, 3, 8 UNION ALL 
SELECT 1292, 323, 7, 10 UNION ALL 
SELECT 1293, 324, 1, 1 UNION ALL 
SELECT 1294, 324, 2, 6 UNION ALL 
SELECT 1295, 324, 3, 8 UNION ALL 
SELECT 1296, 324, 7, 10 UNION ALL 
SELECT 1297, 325, 1, 2 UNION ALL 
SELECT 1298, 325, 2, 6 UNION ALL 
SELECT 1299, 325, 3, 8 UNION ALL 
SELECT 1300, 325, 7, 10 UNION ALL 
SELECT 1301, 326, 1, 1 UNION ALL 
SELECT 1302, 326, 2, 6 UNION ALL 
SELECT 1303, 326, 3, 8 UNION ALL 
SELECT 1304, 326, 7, 10 UNION ALL 
SELECT 1305, 327, 1, 1 UNION ALL 
SELECT 1306, 327, 2, 6 UNION ALL 
SELECT 1307, 327, 3, 8 UNION ALL 
SELECT 1308, 327, 7, 10 UNION ALL 
SELECT 1309, 328, 1, 2 UNION ALL 
SELECT 1310, 328, 2, 6 UNION ALL 
SELECT 1311, 328, 3, 8 UNION ALL 
SELECT 1312, 328, 7, 10 UNION ALL 
SELECT 1313, 329, 1, 3 UNION ALL 
SELECT 1314, 329, 2, 4 UNION ALL 
SELECT 1315, 329, 3, 8 UNION ALL 
SELECT 1316, 329, 7, 10 UNION ALL 
SELECT 1317, 330, 1, 1 UNION ALL 
SELECT 1318, 330, 2, 6 UNION ALL 
SELECT 1319, 330, 3, 8 UNION ALL 
SELECT 1320, 330, 7, 10 UNION ALL 
SELECT 1321, 331, 1, 2 UNION ALL 
SELECT 1322, 331, 2, 6 UNION ALL 
SELECT 1323, 331, 3, 8 UNION ALL 
SELECT 1324, 331, 7, 10 UNION ALL 
SELECT 1325, 332, 1, 1 UNION ALL 
SELECT 1326, 332, 2, 6 UNION ALL 
SELECT 1327, 332, 3, 8 UNION ALL 
SELECT 1328, 332, 7, 10 UNION ALL 
SELECT 1329, 333, 1, 1 UNION ALL 
SELECT 1330, 333, 2, 6 UNION ALL 
SELECT 1331, 333, 3, 8 UNION ALL 
SELECT 1332, 333, 7, 10 UNION ALL 
SELECT 1333, 334, 1, 1 UNION ALL 
SELECT 1334, 334, 2, 6 UNION ALL 
SELECT 1335, 334, 3, 8 UNION ALL 
SELECT 1336, 334, 7, 10 UNION ALL 
SELECT 1337, 335, 1, 3 UNION ALL 
SELECT 1338, 335, 2, 6 UNION ALL 
SELECT 1339, 335, 3, 8 UNION ALL 
SELECT 1340, 335, 7, 10 UNION ALL 
SELECT 1341, 336, 1, 2 UNION ALL 
SELECT 1342, 336, 2, 6 UNION ALL 
SELECT 1343, 336, 3, 8 UNION ALL 
SELECT 1344, 336, 7, 9 UNION ALL 
SELECT 1345, 337, 1, 3 UNION ALL 
SELECT 1346, 337, 2, 6 UNION ALL 
SELECT 1347, 337, 3, 8 UNION ALL 
SELECT 1348, 337, 7, 9 UNION ALL 
SELECT 1349, 338, 1, 2 UNION ALL 
SELECT 1350, 338, 2, 6 UNION ALL 
SELECT 1351, 338, 3, 8 UNION ALL 
SELECT 1352, 338, 7, 10 UNION ALL 
SELECT 1353, 339, 1, 3 UNION ALL 
SELECT 1354, 339, 2, 6 UNION ALL 
SELECT 1355, 339, 3, 8 UNION ALL 
SELECT 1356, 339, 7, 10 UNION ALL 
SELECT 1357, 340, 1, 2 UNION ALL 
SELECT 1358, 340, 2, 6 UNION ALL 
SELECT 1359, 340, 3, 8 UNION ALL 
SELECT 1360, 340, 7, 10 UNION ALL 
SELECT 1361, 341, 1, 2 UNION ALL 
SELECT 1362, 341, 2, 6 UNION ALL 
SELECT 1363, 341, 3, 8 UNION ALL 
SELECT 1364, 341, 7, 10 UNION ALL 
SELECT 1365, 342, 1, 1 UNION ALL 
SELECT 1366, 342, 2, 6 UNION ALL 
SELECT 1367, 342, 3, 8 UNION ALL 
SELECT 1368, 342, 7, 10 UNION ALL 
SELECT 1369, 343, 1, 1 UNION ALL 
SELECT 1370, 343, 2, 6 UNION ALL 
SELECT 1371, 343, 3, 8 UNION ALL 
SELECT 1372, 343, 7, 9 UNION ALL 
SELECT 1373, 344, 1, 3 UNION ALL 
SELECT 1374, 344, 2, 4 UNION ALL 
SELECT 1375, 344, 3, 8 UNION ALL 
SELECT 1376, 344, 7, 10 UNION ALL 
SELECT 1377, 345, 1, 2 UNION ALL 
SELECT 1378, 345, 2, 6 UNION ALL 
SELECT 1379, 345, 3, 8 UNION ALL 
SELECT 1380, 345, 7, 10 UNION ALL 
SELECT 1381, 346, 1, 1 UNION ALL 
SELECT 1382, 346, 2, 6 UNION ALL 
SELECT 1383, 346, 3, 8 UNION ALL 
SELECT 1384, 346, 7, 10 UNION ALL 
SELECT 1385, 347, 1, 3 UNION ALL 
SELECT 1386, 347, 2, 6 UNION ALL 
SELECT 1387, 347, 3, 8 UNION ALL 
SELECT 1388, 347, 7, 10 UNION ALL 
SELECT 1389, 348, 1, 1 UNION ALL 
SELECT 1390, 348, 2, 6 UNION ALL 
SELECT 1391, 348, 3, 8 UNION ALL 
SELECT 1392, 348, 7, 10 UNION ALL 
SELECT 1393, 349, 1, 2 UNION ALL 
SELECT 1394, 349, 2, 6 UNION ALL 
SELECT 1395, 349, 3, 8 UNION ALL 
SELECT 1396, 349, 7, 10 UNION ALL 
SELECT 1397, 350, 1, 2 UNION ALL 
SELECT 1398, 350, 2, 6 UNION ALL 
SELECT 1399, 350, 3, 8 UNION ALL 
SELECT 1400, 350, 7, 10 UNION ALL 
SELECT 1401, 351, 1, 1 UNION ALL 
SELECT 1402, 351, 2, 6 UNION ALL 
SELECT 1403, 351, 3, 8 UNION ALL 
SELECT 1404, 351, 7, 10 UNION ALL 
SELECT 1405, 352, 1, 1 UNION ALL 
SELECT 1406, 352, 2, 6 UNION ALL 
SELECT 1407, 352, 3, 8 UNION ALL 
SELECT 1408, 352, 7, 10 UNION ALL 
SELECT 1409, 353, 1, 1 UNION ALL 
SELECT 1410, 353, 2, 6 UNION ALL 
SELECT 1411, 353, 3, 8 UNION ALL 
SELECT 1412, 353, 7, 10 UNION ALL 
SELECT 1413, 354, 1, 2 UNION ALL 
SELECT 1414, 354, 2, 6 UNION ALL 
SELECT 1415, 354, 3, 8 UNION ALL 
SELECT 1416, 354, 7, 10 UNION ALL 
SELECT 1417, 355, 1, 1 UNION ALL 
SELECT 1418, 355, 2, 6 UNION ALL 
SELECT 1419, 355, 3, 8 UNION ALL 
SELECT 1420, 355, 7, 10 UNION ALL 
SELECT 1421, 356, 1, 2 UNION ALL 
SELECT 1422, 356, 2, 5 UNION ALL 
SELECT 1423, 356, 3, 8 UNION ALL 
SELECT 1424, 356, 7, 10 UNION ALL 
SELECT 1425, 357, 1, 2 UNION ALL 
SELECT 1426, 357, 2, 6 UNION ALL 
SELECT 1427, 357, 3, 8 UNION ALL 
SELECT 1428, 357, 7, 10 UNION ALL 
SELECT 1429, 358, 1, 2 UNION ALL 
SELECT 1430, 358, 2, 6 UNION ALL 
SELECT 1431, 358, 3, 8 UNION ALL 
SELECT 1432, 358, 7, 10 UNION ALL 
SELECT 1433, 359, 1, 3 UNION ALL 
SELECT 1434, 359, 2, 6 UNION ALL 
SELECT 1435, 359, 3, 8 UNION ALL 
SELECT 1436, 359, 7, 9 UNION ALL 
SELECT 1437, 360, 1, 3 UNION ALL 
SELECT 1438, 360, 2, 6 UNION ALL 
SELECT 1439, 360, 3, 8 UNION ALL 
SELECT 1440, 360, 7, 10 UNION ALL 
SELECT 1441, 361, 1, 3 UNION ALL 
SELECT 1442, 361, 2, 6 UNION ALL 
SELECT 1443, 361, 3, 8 UNION ALL 
SELECT 1444, 361, 7, 10 UNION ALL 
SELECT 1445, 362, 1, 1 UNION ALL 
SELECT 1446, 362, 2, 6 UNION ALL 
SELECT 1447, 362, 3, 8 UNION ALL 
SELECT 1448, 362, 7, 10 UNION ALL 
SELECT 1449, 363, 1, 2 UNION ALL 
SELECT 1450, 363, 2, 6 UNION ALL 
SELECT 1451, 363, 3, 8 UNION ALL 
SELECT 1452, 363, 7, 10 UNION ALL 
SELECT 1453, 364, 1, 2 UNION ALL 
SELECT 1454, 364, 2, 6 UNION ALL 
SELECT 1455, 364, 3, 7 UNION ALL 
SELECT 1456, 364, 7, 10 UNION ALL 
SELECT 1457, 365, 1, 3 UNION ALL 
SELECT 1458, 365, 2, 6 UNION ALL 
SELECT 1459, 365, 3, 8 UNION ALL 
SELECT 1460, 365, 7, 10 UNION ALL 
SELECT 1461, 366, 1, 1 UNION ALL 
SELECT 1462, 366, 2, 6 UNION ALL 
SELECT 1463, 366, 3, 8 UNION ALL 
SELECT 1464, 366, 7, 10 UNION ALL 
SELECT 1465, 367, 1, 2 UNION ALL 
SELECT 1466, 367, 2, 6 UNION ALL 
SELECT 1467, 367, 3, 8 UNION ALL 
SELECT 1468, 367, 7, 10 UNION ALL 
SELECT 1469, 368, 1, 1 UNION ALL 
SELECT 1470, 368, 2, 6 UNION ALL 
SELECT 1471, 368, 3, 8 UNION ALL 
SELECT 1472, 368, 7, 10 UNION ALL 
SELECT 1473, 369, 1, 1 UNION ALL 
SELECT 1474, 369, 2, 6 UNION ALL 
SELECT 1475, 369, 3, 8 UNION ALL 
SELECT 1476, 369, 7, 10 UNION ALL 
SELECT 1477, 370, 1, 2 UNION ALL 
SELECT 1478, 370, 2, 6 UNION ALL 
SELECT 1479, 370, 3, 8 UNION ALL 
SELECT 1480, 370, 7, 10 UNION ALL 
SELECT 1481, 371, 1, 1 UNION ALL 
SELECT 1482, 371, 2, 6 UNION ALL 
SELECT 1483, 371, 3, 8 UNION ALL 
SELECT 1484, 371, 7, 10 UNION ALL 
SELECT 1485, 372, 1, 3 UNION ALL 
SELECT 1486, 372, 2, 6 UNION ALL 
SELECT 1487, 372, 3, 8 UNION ALL 
SELECT 1488, 372, 7, 10 UNION ALL 
SELECT 1489, 373, 1, 1 UNION ALL 
SELECT 1490, 373, 2, 6 UNION ALL 
SELECT 1491, 373, 3, 8 UNION ALL 
SELECT 1492, 373, 7, 10 UNION ALL 
SELECT 1493, 374, 1, 1 UNION ALL 
SELECT 1494, 374, 2, 6 UNION ALL 
SELECT 1495, 374, 3, 8 UNION ALL 
SELECT 1496, 374, 7, 10 UNION ALL 
SELECT 1497, 375, 1, 3 UNION ALL 
SELECT 1498, 375, 2, 6 UNION ALL 
SELECT 1499, 375, 3, 8 UNION ALL 
SELECT 1500, 375, 7, 10 UNION ALL 
SELECT 1501, 376, 1, 1 UNION ALL 
SELECT 1502, 376, 2, 6 UNION ALL 
SELECT 1503, 376, 3, 8 UNION ALL 
SELECT 1504, 376, 7, 10 UNION ALL 
SELECT 1505, 377, 1, 2 UNION ALL 
SELECT 1506, 377, 2, 6 UNION ALL 
SELECT 1507, 377, 3, 8 UNION ALL 
SELECT 1508, 377, 7, 10 UNION ALL 
SELECT 1509, 378, 1, 2 UNION ALL 
SELECT 1510, 378, 2, 4 UNION ALL 
SELECT 1511, 378, 3, 8 UNION ALL 
SELECT 1512, 378, 7, 10 UNION ALL 
SELECT 1513, 379, 1, 1 UNION ALL 
SELECT 1514, 379, 2, 6 UNION ALL 
SELECT 1515, 379, 3, 7 UNION ALL 
SELECT 1516, 379, 7, 10 UNION ALL 
SELECT 1517, 380, 1, 1 UNION ALL 
SELECT 1518, 380, 2, 6 UNION ALL 
SELECT 1519, 380, 3, 8 UNION ALL 
SELECT 1520, 380, 7, 9 UNION ALL 
SELECT 1521, 381, 1, 3 UNION ALL 
SELECT 1522, 381, 2, 6 UNION ALL 
SELECT 1523, 381, 3, 8 UNION ALL 
SELECT 1524, 381, 7, 9 UNION ALL 
SELECT 1525, 382, 1, 2 UNION ALL 
SELECT 1526, 382, 2, 6 UNION ALL 
SELECT 1527, 382, 3, 8 UNION ALL 
SELECT 1528, 382, 7, 10 UNION ALL 
SELECT 1529, 383, 1, 2 UNION ALL 
SELECT 1530, 383, 2, 6 UNION ALL 
SELECT 1531, 383, 3, 8 UNION ALL 
SELECT 1532, 383, 7, 10 UNION ALL 
SELECT 1533, 384, 1, 1 UNION ALL 
SELECT 1534, 384, 2, 6 UNION ALL 
SELECT 1535, 384, 3, 8 UNION ALL 
SELECT 1536, 384, 7, 10 UNION ALL 
SELECT 1537, 385, 1, 1 UNION ALL 
SELECT 1538, 385, 2, 6 UNION ALL 
SELECT 1539, 385, 3, 8 UNION ALL 
SELECT 1540, 385, 7, 10 UNION ALL 
SELECT 1541, 386, 1, 3 UNION ALL 
SELECT 1542, 386, 2, 6 UNION ALL 
SELECT 1543, 386, 3, 8 UNION ALL 
SELECT 1544, 386, 7, 10 UNION ALL 
SELECT 1545, 387, 1, 3 UNION ALL 
SELECT 1546, 387, 2, 6 UNION ALL 
SELECT 1547, 387, 3, 8 UNION ALL 
SELECT 1548, 387, 7, 10 UNION ALL 
SELECT 1549, 388, 1, 1 UNION ALL 
SELECT 1550, 388, 2, 6 UNION ALL 
SELECT 1551, 388, 3, 8 UNION ALL 
SELECT 1552, 388, 7, 10 UNION ALL 
SELECT 1553, 389, 1, 1 UNION ALL 
SELECT 1554, 389, 2, 6 UNION ALL 
SELECT 1555, 389, 3, 8 UNION ALL 
SELECT 1556, 389, 7, 10 UNION ALL 
SELECT 1557, 390, 1, 1 UNION ALL 
SELECT 1558, 390, 2, 6 UNION ALL 
SELECT 1559, 390, 3, 8 UNION ALL 
SELECT 1560, 390, 7, 10 UNION ALL 
SELECT 1561, 391, 1, 3 UNION ALL 
SELECT 1562, 391, 2, 6 UNION ALL 
SELECT 1563, 391, 3, 8 UNION ALL 
SELECT 1564, 391, 7, 10 UNION ALL 
SELECT 1565, 392, 1, 2 UNION ALL 
SELECT 1566, 392, 2, 6 UNION ALL 
SELECT 1567, 392, 3, 8 UNION ALL 
SELECT 1568, 392, 7, 10 UNION ALL 
SELECT 1569, 393, 1, 3 UNION ALL 
SELECT 1570, 393, 2, 5 UNION ALL 
SELECT 1571, 393, 3, 8 UNION ALL 
SELECT 1572, 393, 7, 10 UNION ALL 
SELECT 1573, 394, 1, 1 UNION ALL 
SELECT 1574, 394, 2, 6 UNION ALL 
SELECT 1575, 394, 3, 8 UNION ALL 
SELECT 1576, 394, 7, 10 UNION ALL 
SELECT 1577, 395, 1, 1 UNION ALL 
SELECT 1578, 395, 2, 6 UNION ALL 
SELECT 1579, 395, 3, 8 UNION ALL 
SELECT 1580, 395, 7, 10 UNION ALL 
SELECT 1581, 396, 1, 3 UNION ALL 
SELECT 1582, 396, 2, 6 UNION ALL 
SELECT 1583, 396, 3, 8 UNION ALL 
SELECT 1584, 396, 7, 10 UNION ALL 
SELECT 1585, 397, 1, 2 UNION ALL 
SELECT 1586, 397, 2, 6 UNION ALL 
SELECT 1587, 397, 3, 8 UNION ALL 
SELECT 1588, 397, 7, 10 UNION ALL 
SELECT 1589, 398, 1, 1 UNION ALL 
SELECT 1590, 398, 2, 6 UNION ALL 
SELECT 1591, 398, 3, 8 UNION ALL 
SELECT 1592, 398, 7, 10 UNION ALL 
SELECT 1593, 399, 1, 3 UNION ALL 
SELECT 1594, 399, 2, 6 UNION ALL 
SELECT 1595, 399, 3, 8 UNION ALL 
SELECT 1596, 399, 7, 10 UNION ALL 
SELECT 1597, 400, 1, 1 UNION ALL 
SELECT 1598, 400, 2, 6 UNION ALL 
SELECT 1599, 400, 3, 8 UNION ALL 
SELECT 1600, 400, 7, 10 UNION ALL 
SELECT 1601, 401, 1, 2 UNION ALL 
SELECT 1602, 401, 2, 6 UNION ALL 
SELECT 1603, 401, 3, 8 UNION ALL 
SELECT 1604, 401, 7, 10 UNION ALL 
SELECT 1605, 402, 1, 2 UNION ALL 
SELECT 1606, 402, 2, 6 UNION ALL 
SELECT 1607, 402, 3, 8 UNION ALL 
SELECT 1608, 402, 7, 10 UNION ALL 
SELECT 1609, 403, 1, 1 UNION ALL 
SELECT 1610, 403, 2, 6 UNION ALL 
SELECT 1611, 403, 3, 8 UNION ALL 
SELECT 1612, 403, 7, 10 UNION ALL 
SELECT 1613, 404, 1, 2 UNION ALL 
SELECT 1614, 404, 2, 6 UNION ALL 
SELECT 1615, 404, 3, 8 UNION ALL 
SELECT 1616, 404, 7, 10 UNION ALL 
SELECT 1617, 405, 1, 2 UNION ALL 
SELECT 1618, 405, 2, 6 UNION ALL 
SELECT 1619, 405, 3, 8 UNION ALL 
SELECT 1620, 405, 7, 10 UNION ALL 
SELECT 1621, 406, 1, 2 UNION ALL 
SELECT 1622, 406, 2, 6 UNION ALL 
SELECT 1623, 406, 3, 8 UNION ALL 
SELECT 1624, 406, 7, 10 UNION ALL 
SELECT 1625, 407, 1, 3 UNION ALL 
SELECT 1626, 407, 2, 6 UNION ALL 
SELECT 1627, 407, 3, 8 UNION ALL 
SELECT 1628, 407, 7, 10 UNION ALL 
SELECT 1629, 408, 1, 1 UNION ALL 
SELECT 1630, 408, 2, 6 UNION ALL 
SELECT 1631, 408, 3, 8 UNION ALL 
SELECT 1632, 408, 7, 10 UNION ALL 
SELECT 1633, 409, 1, 3 UNION ALL 
SELECT 1634, 409, 2, 6 UNION ALL 
SELECT 1635, 409, 3, 8 UNION ALL 
SELECT 1636, 409, 7, 10 UNION ALL 
SELECT 1637, 410, 1, 2 UNION ALL 
SELECT 1638, 410, 2, 6 UNION ALL 
SELECT 1639, 410, 3, 8 UNION ALL 
SELECT 1640, 410, 7, 10 UNION ALL 
SELECT 1641, 411, 1, 2 UNION ALL 
SELECT 1642, 411, 2, 4 UNION ALL 
SELECT 1643, 411, 3, 8 UNION ALL 
SELECT 1644, 411, 7, 10 UNION ALL 
SELECT 1645, 412, 1, 3 UNION ALL 
SELECT 1646, 412, 2, 6 UNION ALL 
SELECT 1647, 412, 3, 8 UNION ALL 
SELECT 1648, 412, 7, 10 UNION ALL 
SELECT 1649, 413, 1, 1 UNION ALL 
SELECT 1650, 413, 2, 6 UNION ALL 
SELECT 1651, 413, 3, 8 UNION ALL 
SELECT 1652, 413, 7, 10 UNION ALL 
SELECT 1653, 414, 1, 2 UNION ALL 
SELECT 1654, 414, 2, 4 UNION ALL 
SELECT 1655, 414, 3, 8 UNION ALL 
SELECT 1656, 414, 7, 9 UNION ALL 
SELECT 1657, 415, 1, 2 UNION ALL 
SELECT 1658, 415, 2, 4 UNION ALL 
SELECT 1659, 415, 3, 8 UNION ALL 
SELECT 1660, 415, 7, 9 UNION ALL 
SELECT 1661, 416, 1, 1 UNION ALL 
SELECT 1662, 416, 2, 4 UNION ALL 
SELECT 1663, 416, 3, 8 UNION ALL 
SELECT 1664, 416, 7, 9 UNION ALL 
SELECT 1665, 417, 1, 1 UNION ALL 
SELECT 1666, 417, 2, 4 UNION ALL 
SELECT 1667, 417, 3, 8 UNION ALL 
SELECT 1668, 417, 7, 9 UNION ALL 
SELECT 1669, 418, 1, 1 UNION ALL 
SELECT 1670, 418, 2, 4 UNION ALL 
SELECT 1671, 418, 3, 8 UNION ALL 
SELECT 1672, 418, 7, 9 UNION ALL 
SELECT 1673, 419, 1, 2 UNION ALL 
SELECT 1674, 419, 2, 6 UNION ALL 
SELECT 1675, 419, 3, 8 UNION ALL 
SELECT 1676, 419, 7, 10 UNION ALL 
SELECT 1677, 420, 1, 1 UNION ALL 
SELECT 1678, 420, 2, 6 UNION ALL 
SELECT 1679, 420, 3, 8 UNION ALL 
SELECT 1680, 420, 7, 10 UNION ALL 
SELECT 1681, 421, 1, 1 UNION ALL 
SELECT 1682, 421, 2, 5 UNION ALL 
SELECT 1683, 421, 3, 8 UNION ALL 
SELECT 1684, 421, 7, 9 UNION ALL 
SELECT 1685, 422, 1, 1 UNION ALL 
SELECT 1686, 422, 2, 6 UNION ALL 
SELECT 1687, 422, 3, 8 UNION ALL 
SELECT 1688, 422, 7, 10 UNION ALL 
SELECT 1689, 423, 4, 20 UNION ALL 
SELECT 1690, 423, 5, 21 UNION ALL 
SELECT 1691, 423, 6, 25 UNION ALL 
SELECT 1692, 423, 8, 26 UNION ALL 
SELECT 1693, 424, 4, 20 UNION ALL 
SELECT 1694, 424, 5, 23 UNION ALL 
SELECT 1695, 424, 6, 25 UNION ALL 
SELECT 1696, 424, 8, 27 UNION ALL 
SELECT 1697, 425, 4, 20 UNION ALL 
SELECT 1698, 425, 5, 21 UNION ALL 
SELECT 1699, 425, 6, 25 UNION ALL 
SELECT 1700, 425, 8, 26 UNION ALL 
SELECT 1701, 426, 4, 20 UNION ALL 
SELECT 1702, 426, 5, 21 UNION ALL 
SELECT 1703, 426, 6, 25 UNION ALL 
SELECT 1704, 426, 8, 26 UNION ALL 
SELECT 1705, 427, 4, 20 UNION ALL 
SELECT 1706, 427, 5, 21 UNION ALL 
SELECT 1707, 427, 6, 25 UNION ALL 
SELECT 1708, 427, 8, 26 UNION ALL 
SELECT 1709, 428, 4, 20 UNION ALL 
SELECT 1710, 428, 5, 21 UNION ALL 
SELECT 1711, 428, 6, 25 UNION ALL 
SELECT 1712, 428, 8, 26 UNION ALL 
SELECT 1713, 429, 4, 20 UNION ALL 
SELECT 1714, 429, 5, 21 UNION ALL 
SELECT 1715, 429, 6, 25 UNION ALL 
SELECT 1716, 429, 8, 26 UNION ALL 
SELECT 1717, 430, 4, 20 UNION ALL 
SELECT 1718, 430, 5, 21 UNION ALL 
SELECT 1719, 430, 6, 25 UNION ALL 
SELECT 1720, 430, 8, 26 UNION ALL 
SELECT 1721, 431, 4, 20 UNION ALL 
SELECT 1722, 431, 5, 21 UNION ALL 
SELECT 1723, 431, 6, 25 UNION ALL 
SELECT 1724, 431, 8, 26 UNION ALL 
SELECT 1725, 432, 4, 20 UNION ALL 
SELECT 1726, 432, 5, 21 UNION ALL 
SELECT 1727, 432, 6, 25 UNION ALL 
SELECT 1728, 432, 8, 26 UNION ALL 
SELECT 1729, 433, 4, 20 UNION ALL 
SELECT 1730, 433, 5, 21 UNION ALL 
SELECT 1731, 433, 6, 25 UNION ALL 
SELECT 1732, 433, 8, 26 UNION ALL 
SELECT 1733, 434, 4, 20 UNION ALL 
SELECT 1734, 434, 5, 21 UNION ALL 
SELECT 1735, 434, 6, 25 UNION ALL 
SELECT 1736, 434, 8, 26 UNION ALL 
SELECT 1737, 435, 4, 20 UNION ALL 
SELECT 1738, 435, 5, 21 UNION ALL 
SELECT 1739, 435, 6, 25 UNION ALL 
SELECT 1740, 435, 8, 26 UNION ALL 
SELECT 1741, 436, 4, 20 UNION ALL 
SELECT 1742, 436, 5, 21 UNION ALL 
SELECT 1743, 436, 6, 25 UNION ALL 
SELECT 1744, 436, 8, 26 UNION ALL 
SELECT 1745, 437, 4, 20 UNION ALL 
SELECT 1746, 437, 5, 21 UNION ALL 
SELECT 1747, 437, 6, 25 UNION ALL 
SELECT 1748, 437, 8, 26 UNION ALL 
SELECT 1749, 438, 4, 20 UNION ALL 
SELECT 1750, 438, 5, 21 UNION ALL 
SELECT 1751, 438, 6, 25 UNION ALL 
SELECT 1752, 438, 8, 26 UNION ALL 
SELECT 1753, 439, 4, 20 UNION ALL 
SELECT 1754, 439, 5, 21 UNION ALL 
SELECT 1755, 439, 6, 25 UNION ALL 
SELECT 1756, 439, 8, 26 UNION ALL 
SELECT 1757, 440, 4, 20 UNION ALL 
SELECT 1758, 440, 5, 21 UNION ALL 
SELECT 1759, 440, 6, 25 UNION ALL 
SELECT 1760, 440, 8, 26 UNION ALL 
SELECT 1761, 441, 4, 20 UNION ALL 
SELECT 1762, 441, 5, 21 UNION ALL 
SELECT 1763, 441, 6, 25 UNION ALL 
SELECT 1764, 441, 8, 26 UNION ALL 
SELECT 1765, 442, 4, 20 UNION ALL 
SELECT 1766, 442, 5, 21 UNION ALL 
SELECT 1767, 442, 6, 25 UNION ALL 
SELECT 1768, 442, 8, 26 UNION ALL 
SELECT 1769, 443, 4, 20 UNION ALL 
SELECT 1770, 443, 5, 21 UNION ALL 
SELECT 1771, 443, 6, 25 UNION ALL 
SELECT 1772, 443, 8, 26 UNION ALL 
SELECT 1773, 444, 4, 20 UNION ALL 
SELECT 1774, 444, 5, 21 UNION ALL 
SELECT 1775, 444, 6, 25 UNION ALL 
SELECT 1776, 444, 8, 26 UNION ALL 
SELECT 1777, 445, 4, 20 UNION ALL 
SELECT 1778, 445, 5, 21 UNION ALL 
SELECT 1779, 445, 6, 25 UNION ALL 
SELECT 1780, 445, 8, 26 UNION ALL 
SELECT 1781, 446, 4, 20 UNION ALL 
SELECT 1782, 446, 5, 21 UNION ALL 
SELECT 1783, 446, 6, 25 UNION ALL 
SELECT 1784, 446, 8, 26 UNION ALL 
SELECT 1785, 447, 4, 20 UNION ALL 
SELECT 1786, 447, 5, 21 UNION ALL 
SELECT 1787, 447, 6, 25 UNION ALL 
SELECT 1788, 447, 8, 26 UNION ALL 
SELECT 1789, 448, 4, 20 UNION ALL 
SELECT 1790, 448, 5, 21 UNION ALL 
SELECT 1791, 448, 6, 25 UNION ALL 
SELECT 1792, 448, 8, 26 UNION ALL 
SELECT 1793, 449, 4, 20 UNION ALL 
SELECT 1794, 449, 5, 21 UNION ALL 
SELECT 1795, 449, 6, 25 UNION ALL 
SELECT 1796, 449, 8, 26 UNION ALL 
SELECT 1797, 450, 4, 20 UNION ALL 
SELECT 1798, 450, 5, 21 UNION ALL 
SELECT 1799, 450, 6, 25 UNION ALL 
SELECT 1800, 450, 8, 26 UNION ALL 
SELECT 1801, 451, 4, 20 UNION ALL 
SELECT 1802, 451, 5, 21 UNION ALL 
SELECT 1803, 451, 6, 25 UNION ALL 
SELECT 1804, 451, 8, 26 UNION ALL 
SELECT 1805, 452, 4, 20 UNION ALL 
SELECT 1806, 452, 5, 21 UNION ALL 
SELECT 1807, 452, 6, 25 UNION ALL 
SELECT 1808, 452, 8, 26 UNION ALL 
SELECT 1809, 453, 4, 20 UNION ALL 
SELECT 1810, 453, 5, 21 UNION ALL 
SELECT 1811, 453, 6, 25 UNION ALL 
SELECT 1812, 453, 8, 26 UNION ALL 
SELECT 1813, 454, 4, 20 UNION ALL 
SELECT 1814, 454, 5, 21 UNION ALL 
SELECT 1815, 454, 6, 25 UNION ALL 
SELECT 1816, 454, 8, 26 UNION ALL 
SELECT 1817, 455, 4, 20 UNION ALL 
SELECT 1818, 455, 5, 21 UNION ALL 
SELECT 1819, 455, 6, 25 UNION ALL 
SELECT 1820, 455, 8, 26 UNION ALL 
SELECT 1821, 456, 4, 20 UNION ALL 
SELECT 1822, 456, 5, 21 UNION ALL 
SELECT 1823, 456, 6, 25 UNION ALL 
SELECT 1824, 456, 8, 26 UNION ALL 
SELECT 1825, 457, 4, 20 UNION ALL 
SELECT 1826, 457, 5, 21 UNION ALL 
SELECT 1827, 457, 6, 25 UNION ALL 
SELECT 1828, 457, 8, 26 UNION ALL 
SELECT 1829, 458, 4, 20 UNION ALL 
SELECT 1830, 458, 5, 21 UNION ALL 
SELECT 1831, 458, 6, 25 UNION ALL 
SELECT 1832, 458, 8, 26 UNION ALL 
SELECT 1833, 459, 4, 20 UNION ALL 
SELECT 1834, 459, 5, 21 UNION ALL 
SELECT 1835, 459, 6, 25 UNION ALL 
SELECT 1836, 459, 8, 26 UNION ALL 
SELECT 1837, 460, 4, 20 UNION ALL 
SELECT 1838, 460, 5, 21 UNION ALL 
SELECT 1839, 460, 6, 25 UNION ALL 
SELECT 1840, 460, 8, 26 UNION ALL 
SELECT 1841, 461, 4, 20 UNION ALL 
SELECT 1842, 461, 5, 22 UNION ALL 
SELECT 1843, 461, 6, 25 UNION ALL 
SELECT 1844, 461, 8, 26 UNION ALL 
SELECT 1845, 462, 4, 20 UNION ALL 
SELECT 1846, 462, 5, 21 UNION ALL 
SELECT 1847, 462, 6, 25 UNION ALL 
SELECT 1848, 462, 8, 26 UNION ALL 
SELECT 1849, 463, 4, 20 UNION ALL 
SELECT 1850, 463, 5, 21 UNION ALL 
SELECT 1851, 463, 6, 25 UNION ALL 
SELECT 1852, 463, 8, 26 UNION ALL 
SELECT 1853, 464, 4, 20 UNION ALL 
SELECT 1854, 464, 5, 21 UNION ALL 
SELECT 1855, 464, 6, 25 UNION ALL 
SELECT 1856, 464, 8, 26 UNION ALL 
SELECT 1857, 465, 4, 20 UNION ALL 
SELECT 1858, 465, 5, 21 UNION ALL 
SELECT 1859, 465, 6, 25 UNION ALL 
SELECT 1860, 465, 8, 26 UNION ALL 
SELECT 1861, 466, 4, 20 UNION ALL 
SELECT 1862, 466, 5, 21 UNION ALL 
SELECT 1863, 466, 6, 25 UNION ALL 
SELECT 1864, 466, 8, 26 UNION ALL 
SELECT 1865, 467, 4, 20 UNION ALL 
SELECT 1866, 467, 5, 21 UNION ALL 
SELECT 1867, 467, 6, 25 UNION ALL 
SELECT 1868, 467, 8, 26 UNION ALL 
SELECT 1869, 468, 4, 20 UNION ALL 
SELECT 1870, 468, 5, 21 UNION ALL 
SELECT 1871, 468, 6, 25 UNION ALL 
SELECT 1872, 468, 8, 26 UNION ALL 
SELECT 1873, 469, 4, 20 UNION ALL 
SELECT 1874, 469, 5, 21 UNION ALL 
SELECT 1875, 469, 6, 25 UNION ALL 
SELECT 1876, 469, 8, 26 UNION ALL 
SELECT 1877, 470, 4, 20 UNION ALL 
SELECT 1878, 470, 5, 21 UNION ALL 
SELECT 1879, 470, 6, 25 UNION ALL 
SELECT 1880, 470, 8, 26 UNION ALL 
SELECT 1881, 471, 4, 20 UNION ALL 
SELECT 1882, 471, 5, 21 UNION ALL 
SELECT 1883, 471, 6, 25 UNION ALL 
SELECT 1884, 471, 8, 26 UNION ALL 
SELECT 1885, 472, 4, 20 UNION ALL 
SELECT 1886, 472, 5, 21 UNION ALL 
SELECT 1887, 472, 6, 25 UNION ALL 
SELECT 1888, 472, 8, 26 UNION ALL 
SELECT 1889, 473, 4, 20 UNION ALL 
SELECT 1890, 473, 5, 21 UNION ALL 
SELECT 1891, 473, 6, 25 UNION ALL 
SELECT 1892, 473, 8, 26 UNION ALL 
SELECT 1893, 474, 4, 20 UNION ALL 
SELECT 1894, 474, 5, 21 UNION ALL 
SELECT 1895, 474, 6, 25 UNION ALL 
SELECT 1896, 474, 8, 26 UNION ALL 
SELECT 1897, 475, 4, 20 UNION ALL 
SELECT 1898, 475, 5, 21 UNION ALL 
SELECT 1899, 475, 6, 25 UNION ALL 
SELECT 1900, 475, 8, 26 UNION ALL 
SELECT 1901, 476, 4, 20 UNION ALL 
SELECT 1902, 476, 5, 21 UNION ALL 
SELECT 1903, 476, 6, 25 UNION ALL 
SELECT 1904, 476, 8, 26 UNION ALL 
SELECT 1905, 477, 4, 20 UNION ALL 
SELECT 1906, 477, 5, 21 UNION ALL 
SELECT 1907, 477, 6, 25 UNION ALL 
SELECT 1908, 477, 8, 26 UNION ALL 
SELECT 1909, 478, 4, 20 UNION ALL 
SELECT 1910, 478, 5, 21 UNION ALL 
SELECT 1911, 478, 6, 25 UNION ALL 
SELECT 1912, 478, 8, 26 UNION ALL 
SELECT 1913, 479, 4, 20 UNION ALL 
SELECT 1914, 479, 5, 21 UNION ALL 
SELECT 1915, 479, 6, 25 UNION ALL 
SELECT 1916, 479, 8, 26 UNION ALL 
SELECT 1917, 480, 4, 20 UNION ALL 
SELECT 1918, 480, 5, 21 UNION ALL 
SELECT 1919, 480, 6, 25 UNION ALL 
SELECT 1920, 480, 8, 26 UNION ALL 
SELECT 1921, 481, 4, 20 UNION ALL 
SELECT 1922, 481, 5, 21 UNION ALL 
SELECT 1923, 481, 6, 25 UNION ALL 
SELECT 1924, 481, 8, 26 UNION ALL 
SELECT 1925, 482, 4, 20 UNION ALL 
SELECT 1926, 482, 5, 21 UNION ALL 
SELECT 1927, 482, 6, 25 UNION ALL 
SELECT 1928, 482, 8, 26 UNION ALL 
SELECT 1929, 483, 4, 20 UNION ALL 
SELECT 1930, 483, 5, 21 UNION ALL 
SELECT 1931, 483, 6, 25 UNION ALL 
SELECT 1932, 483, 8, 26 UNION ALL 
SELECT 1933, 484, 4, 20 UNION ALL 
SELECT 1934, 484, 5, 21 UNION ALL 
SELECT 1935, 484, 6, 25 UNION ALL 
SELECT 1936, 484, 8, 26 UNION ALL 
SELECT 1937, 485, 4, 20 UNION ALL 
SELECT 1938, 485, 5, 21 UNION ALL 
SELECT 1939, 485, 6, 25 UNION ALL 
SELECT 1940, 485, 8, 26 UNION ALL 
SELECT 1941, 486, 4, 20 UNION ALL 
SELECT 1942, 486, 5, 21 UNION ALL 
SELECT 1943, 486, 6, 25 UNION ALL 
SELECT 1944, 486, 8, 26 UNION ALL 
SELECT 1945, 487, 4, 20 UNION ALL 
SELECT 1946, 487, 5, 21 UNION ALL 
SELECT 1947, 487, 6, 25 UNION ALL 
SELECT 1948, 487, 8, 26 UNION ALL 
SELECT 1949, 488, 4, 20 UNION ALL 
SELECT 1950, 488, 5, 21 UNION ALL 
SELECT 1951, 488, 6, 25 UNION ALL 
SELECT 1952, 488, 8, 26 UNION ALL 
SELECT 1953, 489, 4, 20 UNION ALL 
SELECT 1954, 489, 5, 21 UNION ALL 
SELECT 1955, 489, 6, 25 UNION ALL 
SELECT 1956, 489, 8, 26 UNION ALL 
SELECT 1957, 490, 4, 20 UNION ALL 
SELECT 1958, 490, 5, 21 UNION ALL 
SELECT 1959, 490, 6, 25 UNION ALL 
SELECT 1960, 490, 8, 26 UNION ALL 
SELECT 1961, 491, 4, 20 UNION ALL 
SELECT 1962, 491, 5, 21 UNION ALL 
SELECT 1963, 491, 6, 25 UNION ALL 
SELECT 1964, 491, 8, 26 UNION ALL 
SELECT 1965, 492, 4, 20 UNION ALL 
SELECT 1966, 492, 5, 21 UNION ALL 
SELECT 1967, 492, 6, 25 UNION ALL 
SELECT 1968, 492, 8, 26 UNION ALL 
SELECT 1969, 493, 4, 20 UNION ALL 
SELECT 1970, 493, 5, 21 UNION ALL 
SELECT 1971, 493, 6, 25 UNION ALL 
SELECT 1972, 493, 8, 26 UNION ALL 
SELECT 1973, 494, 4, 20 UNION ALL 
SELECT 1974, 494, 5, 21 UNION ALL 
SELECT 1975, 494, 6, 25 UNION ALL 
SELECT 1976, 494, 8, 26 UNION ALL 
SELECT 1977, 495, 4, 20 UNION ALL 
SELECT 1978, 495, 5, 21 UNION ALL 
SELECT 1979, 495, 6, 25 UNION ALL 
SELECT 1980, 495, 8, 26 UNION ALL 
SELECT 1981, 496, 4, 20 UNION ALL 
SELECT 1982, 496, 5, 22 UNION ALL 
SELECT 1983, 496, 6, 25 UNION ALL 
SELECT 1984, 496, 8, 26 UNION ALL 
SELECT 1985, 497, 4, 20 UNION ALL 
SELECT 1986, 497, 5, 21 UNION ALL 
SELECT 1987, 497, 6, 25 UNION ALL 
SELECT 1988, 497, 8, 26 UNION ALL 
SELECT 1989, 498, 4, 20 UNION ALL 
SELECT 1990, 498, 5, 21 UNION ALL 
SELECT 1991, 498, 6, 25 UNION ALL 
SELECT 1992, 498, 8, 26 UNION ALL 
SELECT 1993, 499, 4, 20 UNION ALL 
SELECT 1994, 499, 5, 21 UNION ALL 
SELECT 1995, 499, 6, 25 UNION ALL 
SELECT 1996, 499, 8, 26 UNION ALL 
SELECT 1997, 500, 4, 20 UNION ALL 
SELECT 1998, 500, 5, 21 UNION ALL 
SELECT 1999, 500, 6, 25 UNION ALL 
SELECT 2000, 500, 8, 26 UNION ALL 
SELECT 2001, 501, 4, 20 UNION ALL 
SELECT 2002, 501, 5, 21 UNION ALL 
SELECT 2003, 501, 6, 25 UNION ALL 
SELECT 2004, 501, 8, 26 UNION ALL 
SELECT 2005, 502, 4, 20 UNION ALL 
SELECT 2006, 502, 5, 21 UNION ALL 
SELECT 2007, 502, 6, 25 UNION ALL 
SELECT 2008, 502, 8, 26 UNION ALL 
SELECT 2009, 503, 4, 20 UNION ALL 
SELECT 2010, 503, 5, 21 UNION ALL 
SELECT 2011, 503, 6, 25 UNION ALL 
SELECT 2012, 503, 8, 26 UNION ALL 
SELECT 2013, 504, 4, 20 UNION ALL 
SELECT 2014, 504, 5, 21 UNION ALL 
SELECT 2015, 504, 6, 25 UNION ALL 
SELECT 2016, 504, 8, 26 UNION ALL 
SELECT 2017, 505, 4, 20 UNION ALL 
SELECT 2018, 505, 5, 21 UNION ALL 
SELECT 2019, 505, 6, 25 UNION ALL 
SELECT 2020, 505, 8, 26 UNION ALL 
SELECT 2021, 506, 4, 20 UNION ALL 
SELECT 2022, 506, 5, 21 UNION ALL 
SELECT 2023, 506, 6, 25 UNION ALL 
SELECT 2024, 506, 8, 26 UNION ALL 
SELECT 2025, 507, 4, 20 UNION ALL 
SELECT 2026, 507, 5, 21 UNION ALL 
SELECT 2027, 507, 6, 25 UNION ALL 
SELECT 2028, 507, 8, 26 UNION ALL 
SELECT 2029, 508, 4, 20 UNION ALL 
SELECT 2030, 508, 5, 21 UNION ALL 
SELECT 2031, 508, 6, 25 UNION ALL 
SELECT 2032, 508, 8, 26 UNION ALL 
SELECT 2033, 509, 4, 20 UNION ALL 
SELECT 2034, 509, 5, 21 UNION ALL 
SELECT 2035, 509, 6, 25 UNION ALL 
SELECT 2036, 509, 8, 26 UNION ALL 
SELECT 2037, 510, 4, 20 UNION ALL 
SELECT 2038, 510, 5, 21 UNION ALL 
SELECT 2039, 510, 6, 25 UNION ALL 
SELECT 2040, 510, 8, 26 UNION ALL 
SELECT 2041, 511, 4, 20 UNION ALL 
SELECT 2042, 511, 5, 21 UNION ALL 
SELECT 2043, 511, 6, 25 UNION ALL 
SELECT 2044, 511, 8, 26 UNION ALL 
SELECT 2045, 512, 4, 20 UNION ALL 
SELECT 2046, 512, 5, 21 UNION ALL 
SELECT 2047, 512, 6, 25 UNION ALL 
SELECT 2048, 512, 8, 26 UNION ALL 
SELECT 2049, 513, 4, 20 UNION ALL 
SELECT 2050, 513, 5, 21 UNION ALL 
SELECT 2051, 513, 6, 25 UNION ALL 
SELECT 2052, 513, 8, 26 UNION ALL 
SELECT 2053, 514, 4, 20 UNION ALL 
SELECT 2054, 514, 5, 21 UNION ALL 
SELECT 2055, 514, 6, 25 UNION ALL 
SELECT 2056, 514, 8, 26 UNION ALL 
SELECT 2057, 515, 4, 20 UNION ALL 
SELECT 2058, 515, 5, 21 UNION ALL 
SELECT 2059, 515, 6, 25 UNION ALL 
SELECT 2060, 515, 8, 26 UNION ALL 
SELECT 2061, 516, 4, 20 UNION ALL 
SELECT 2062, 516, 5, 21 UNION ALL 
SELECT 2063, 516, 6, 25 UNION ALL 
SELECT 2064, 516, 8, 26 UNION ALL 
SELECT 2065, 517, 4, 20 UNION ALL 
SELECT 2066, 517, 5, 21 UNION ALL 
SELECT 2067, 517, 6, 25 UNION ALL 
SELECT 2068, 517, 8, 26 UNION ALL 
SELECT 2069, 518, 4, 20 UNION ALL 
SELECT 2070, 518, 5, 21 UNION ALL 
SELECT 2071, 518, 6, 25 UNION ALL 
SELECT 2072, 518, 8, 26 UNION ALL 
SELECT 2073, 519, 4, 20 UNION ALL 
SELECT 2074, 519, 5, 21 UNION ALL 
SELECT 2075, 519, 6, 25 UNION ALL 
SELECT 2076, 519, 8, 26 UNION ALL 
SELECT 2077, 520, 4, 20 UNION ALL 
SELECT 2078, 520, 5, 21 UNION ALL 
SELECT 2079, 520, 6, 25 UNION ALL 
SELECT 2080, 520, 8, 26 UNION ALL 
SELECT 2081, 521, 4, 20 UNION ALL 
SELECT 2082, 521, 5, 22 UNION ALL 
SELECT 2083, 521, 6, 25 UNION ALL 
SELECT 2084, 521, 8, 26 UNION ALL 
SELECT 2085, 522, 4, 20 UNION ALL 
SELECT 2086, 522, 5, 21 UNION ALL 
SELECT 2087, 522, 6, 25 UNION ALL 
SELECT 2088, 522, 8, 26 UNION ALL 
SELECT 2089, 523, 4, 20 UNION ALL 
SELECT 2090, 523, 5, 21 UNION ALL 
SELECT 2091, 523, 6, 25 UNION ALL 
SELECT 2092, 523, 8, 26 UNION ALL 
SELECT 2093, 524, 4, 20 UNION ALL 
SELECT 2094, 524, 5, 21 UNION ALL 
SELECT 2095, 524, 6, 25 UNION ALL 
SELECT 2096, 524, 8, 26 UNION ALL 
SELECT 2097, 525, 4, 20 UNION ALL 
SELECT 2098, 525, 5, 21 UNION ALL 
SELECT 2099, 525, 6, 25 UNION ALL 
SELECT 2100, 525, 8, 26 UNION ALL 
SELECT 2101, 526, 4, 20 UNION ALL 
SELECT 2102, 526, 5, 21 UNION ALL 
SELECT 2103, 526, 6, 25 UNION ALL 
SELECT 2104, 526, 8, 26 UNION ALL 
SELECT 2105, 527, 4, 20 UNION ALL 
SELECT 2106, 527, 5, 21 UNION ALL 
SELECT 2107, 527, 6, 25 UNION ALL 
SELECT 2108, 527, 8, 26 UNION ALL 
SELECT 2109, 528, 4, 20 UNION ALL 
SELECT 2110, 528, 5, 21 UNION ALL 
SELECT 2111, 528, 6, 25 UNION ALL 
SELECT 2112, 528, 8, 26 UNION ALL 
SELECT 2113, 529, 4, 20 UNION ALL 
SELECT 2114, 529, 5, 21 UNION ALL 
SELECT 2115, 529, 6, 25 UNION ALL 
SELECT 2116, 529, 8, 26 UNION ALL 
SELECT 2117, 530, 4, 20 UNION ALL 
SELECT 2118, 530, 5, 21 UNION ALL 
SELECT 2119, 530, 6, 25 UNION ALL 
SELECT 2120, 530, 8, 26 UNION ALL 
SELECT 2121, 531, 4, 20 UNION ALL 
SELECT 2122, 531, 5, 21 UNION ALL 
SELECT 2123, 531, 6, 25 UNION ALL 
SELECT 2124, 531, 8, 26 UNION ALL 
SELECT 2125, 532, 4, 20 UNION ALL 
SELECT 2126, 532, 5, 21 UNION ALL 
SELECT 2127, 532, 6, 25 UNION ALL 
SELECT 2128, 532, 8, 26 UNION ALL 
SELECT 2129, 533, 4, 20 UNION ALL 
SELECT 2130, 533, 5, 21 UNION ALL 
SELECT 2131, 533, 6, 25 UNION ALL 
SELECT 2132, 533, 8, 26 UNION ALL 
SELECT 2133, 534, 4, 20 UNION ALL 
SELECT 2134, 534, 5, 21 UNION ALL 
SELECT 2135, 534, 6, 25 UNION ALL 
SELECT 2136, 534, 8, 26 UNION ALL 
SELECT 2137, 535, 4, 20 UNION ALL 
SELECT 2138, 535, 5, 21 UNION ALL 
SELECT 2139, 535, 6, 25 UNION ALL 
SELECT 2140, 535, 8, 26 UNION ALL 
SELECT 2141, 536, 4, 20 UNION ALL 
SELECT 2142, 536, 5, 21 UNION ALL 
SELECT 2143, 536, 6, 25 UNION ALL 
SELECT 2144, 536, 8, 26 UNION ALL 
SELECT 2145, 537, 4, 20 UNION ALL 
SELECT 2146, 537, 5, 21 UNION ALL 
SELECT 2147, 537, 6, 25 UNION ALL 
SELECT 2148, 537, 8, 26 UNION ALL 
SELECT 2149, 538, 4, 20 UNION ALL 
SELECT 2150, 538, 5, 21 UNION ALL 
SELECT 2151, 538, 6, 25 UNION ALL 
SELECT 2152, 538, 8, 26 UNION ALL 
SELECT 2153, 539, 4, 20 UNION ALL 
SELECT 2154, 539, 5, 21 UNION ALL 
SELECT 2155, 539, 6, 25 UNION ALL 
SELECT 2156, 539, 8, 26 UNION ALL 
SELECT 2157, 540, 4, 20 UNION ALL 
SELECT 2158, 540, 5, 21 UNION ALL 
SELECT 2159, 540, 6, 25 UNION ALL 
SELECT 2160, 540, 8, 26 UNION ALL 
SELECT 2161, 541, 4, 20 UNION ALL 
SELECT 2162, 541, 5, 21 UNION ALL 
SELECT 2163, 541, 6, 25 UNION ALL 
SELECT 2164, 541, 8, 26 UNION ALL 
SELECT 2165, 542, 4, 20 UNION ALL 
SELECT 2166, 542, 5, 21 UNION ALL 
SELECT 2167, 542, 6, 25 UNION ALL 
SELECT 2168, 542, 8, 26 UNION ALL 
SELECT 2169, 543, 4, 20 UNION ALL 
SELECT 2170, 543, 5, 21 UNION ALL 
SELECT 2171, 543, 6, 25 UNION ALL 
SELECT 2172, 543, 8, 26 UNION ALL 
SELECT 2173, 544, 4, 20 UNION ALL 
SELECT 2174, 544, 5, 21 UNION ALL 
SELECT 2175, 544, 6, 25 UNION ALL 
SELECT 2176, 544, 8, 26 UNION ALL 
SELECT 2177, 545, 4, 20 UNION ALL 
SELECT 2178, 545, 5, 21 UNION ALL 
SELECT 2179, 545, 6, 25 UNION ALL 
SELECT 2180, 545, 8, 26 UNION ALL 
SELECT 2181, 546, 4, 20 UNION ALL 
SELECT 2182, 546, 5, 21 UNION ALL 
SELECT 2183, 546, 6, 25 UNION ALL 
SELECT 2184, 546, 8, 26 UNION ALL 
SELECT 2185, 547, 4, 20 UNION ALL 
SELECT 2186, 547, 5, 21 UNION ALL 
SELECT 2187, 547, 6, 25 UNION ALL 
SELECT 2188, 547, 8, 26 UNION ALL 
SELECT 2189, 548, 4, 20 UNION ALL 
SELECT 2190, 548, 5, 21 UNION ALL 
SELECT 2191, 548, 6, 25 UNION ALL 
SELECT 2192, 548, 8, 26 UNION ALL 
SELECT 2193, 549, 4, 20 UNION ALL 
SELECT 2194, 549, 5, 21 UNION ALL 
SELECT 2195, 549, 6, 25 UNION ALL 
SELECT 2196, 549, 8, 26 UNION ALL 
SELECT 2197, 550, 4, 20 UNION ALL 
SELECT 2198, 550, 5, 21 UNION ALL 
SELECT 2199, 550, 6, 25 UNION ALL 
SELECT 2200, 550, 8, 26 UNION ALL 
SELECT 2201, 551, 4, 20 UNION ALL 
SELECT 2202, 551, 5, 21 UNION ALL 
SELECT 2203, 551, 6, 25 UNION ALL 
SELECT 2204, 551, 8, 26 UNION ALL 
SELECT 2205, 552, 4, 20 UNION ALL 
SELECT 2206, 552, 5, 21 UNION ALL 
SELECT 2207, 552, 6, 25 UNION ALL 
SELECT 2208, 552, 8, 26 UNION ALL 
SELECT 2209, 553, 4, 20 UNION ALL 
SELECT 2210, 553, 5, 21 UNION ALL 
SELECT 2211, 553, 6, 25 UNION ALL 
SELECT 2212, 553, 8, 26 UNION ALL 
SELECT 2213, 554, 4, 20 UNION ALL 
SELECT 2214, 554, 5, 21 UNION ALL 
SELECT 2215, 554, 6, 25 UNION ALL 
SELECT 2216, 554, 8, 26 UNION ALL 
SELECT 2217, 555, 4, 20 UNION ALL 
SELECT 2218, 555, 5, 21 UNION ALL 
SELECT 2219, 555, 6, 25 UNION ALL 
SELECT 2220, 555, 8, 26 UNION ALL 
SELECT 2221, 556, 4, 20 UNION ALL 
SELECT 2222, 556, 5, 21 UNION ALL 
SELECT 2223, 556, 6, 25 UNION ALL 
SELECT 2224, 556, 8, 26 UNION ALL 
SELECT 2225, 557, 4, 20 UNION ALL 
SELECT 2226, 557, 5, 21 UNION ALL 
SELECT 2227, 557, 6, 25 UNION ALL 
SELECT 2228, 557, 8, 26 UNION ALL 
SELECT 2229, 558, 4, 20 UNION ALL 
SELECT 2230, 558, 5, 21 UNION ALL 
SELECT 2231, 558, 6, 25 UNION ALL 
SELECT 2232, 558, 8, 26 UNION ALL 
SELECT 2233, 559, 4, 20 UNION ALL 
SELECT 2234, 559, 5, 21 UNION ALL 
SELECT 2235, 559, 6, 25 UNION ALL 
SELECT 2236, 559, 8, 26 UNION ALL 
SELECT 2237, 560, 4, 20 UNION ALL 
SELECT 2238, 560, 5, 21 UNION ALL 
SELECT 2239, 560, 6, 25 UNION ALL 
SELECT 2240, 560, 8, 26 UNION ALL 
SELECT 2241, 561, 4, 20 UNION ALL 
SELECT 2242, 561, 5, 21 UNION ALL 
SELECT 2243, 561, 6, 25 UNION ALL 
SELECT 2244, 561, 8, 26 UNION ALL 
SELECT 2245, 562, 4, 20 UNION ALL 
SELECT 2246, 562, 5, 21 UNION ALL 
SELECT 2247, 562, 6, 25 UNION ALL 
SELECT 2248, 562, 8, 26 UNION ALL 
SELECT 2249, 563, 4, 20 UNION ALL 
SELECT 2250, 563, 5, 21 UNION ALL 
SELECT 2251, 563, 6, 25 UNION ALL 
SELECT 2252, 563, 8, 26 UNION ALL 
SELECT 2253, 564, 4, 20 UNION ALL 
SELECT 2254, 564, 5, 21 UNION ALL 
SELECT 2255, 564, 6, 25 UNION ALL 
SELECT 2256, 564, 8, 26 UNION ALL 
SELECT 2257, 565, 4, 20 UNION ALL 
SELECT 2258, 565, 5, 21 UNION ALL 
SELECT 2259, 565, 6, 25 UNION ALL 
SELECT 2260, 565, 8, 26 UNION ALL 
SELECT 2261, 566, 4, 20 UNION ALL 
SELECT 2262, 566, 5, 21 UNION ALL 
SELECT 2263, 566, 6, 25 UNION ALL 
SELECT 2264, 566, 8, 26 UNION ALL 
SELECT 2265, 567, 4, 20 UNION ALL 
SELECT 2266, 567, 5, 21 UNION ALL 
SELECT 2267, 567, 6, 25 UNION ALL 
SELECT 2268, 567, 8, 26 UNION ALL 
SELECT 2269, 568, 4, 20 UNION ALL 
SELECT 2270, 568, 5, 21 UNION ALL 
SELECT 2271, 568, 6, 25 UNION ALL 
SELECT 2272, 568, 8, 26 UNION ALL 
SELECT 2273, 569, 4, 20 UNION ALL 
SELECT 2274, 569, 5, 22 UNION ALL 
SELECT 2275, 569, 6, 25 UNION ALL 
SELECT 2276, 569, 8, 26 UNION ALL 
SELECT 2277, 570, 4, 20 UNION ALL 
SELECT 2278, 570, 5, 21 UNION ALL 
SELECT 2279, 570, 6, 25 UNION ALL 
SELECT 2280, 570, 8, 26 UNION ALL 
SELECT 2281, 571, 4, 20 UNION ALL 
SELECT 2282, 571, 5, 22 UNION ALL 
SELECT 2283, 571, 6, 25 UNION ALL 
SELECT 2284, 571, 8, 26 UNION ALL 
SELECT 2285, 572, 4, 20 UNION ALL 
SELECT 2286, 572, 5, 21 UNION ALL 
SELECT 2287, 572, 6, 25 UNION ALL 
SELECT 2288, 572, 8, 26 UNION ALL 
SELECT 2289, 573, 4, 20 UNION ALL 
SELECT 2290, 573, 5, 21 UNION ALL 
SELECT 2291, 573, 6, 25 UNION ALL 
SELECT 2292, 573, 8, 26 UNION ALL 
SELECT 2293, 574, 4, 20 UNION ALL 
SELECT 2294, 574, 5, 21 UNION ALL 
SELECT 2295, 574, 6, 25 UNION ALL 
SELECT 2296, 574, 8, 26 UNION ALL 
SELECT 2297, 575, 4, 20 UNION ALL 
SELECT 2298, 575, 5, 21 UNION ALL 
SELECT 2299, 575, 6, 25 UNION ALL 
SELECT 2300, 575, 8, 26 UNION ALL 
SELECT 2301, 576, 4, 20 UNION ALL 
SELECT 2302, 576, 5, 21 UNION ALL 
SELECT 2303, 576, 6, 25 UNION ALL 
SELECT 2304, 576, 8, 26 UNION ALL 
SELECT 2305, 577, 4, 20 UNION ALL 
SELECT 2306, 577, 5, 21 UNION ALL 
SELECT 2307, 577, 6, 25 UNION ALL 
SELECT 2308, 577, 8, 26 UNION ALL 
SELECT 2309, 578, 4, 20 UNION ALL 
SELECT 2310, 578, 5, 21 UNION ALL 
SELECT 2311, 578, 6, 25 UNION ALL 
SELECT 2312, 578, 8, 26 UNION ALL 
SELECT 2313, 579, 4, 20 UNION ALL 
SELECT 2314, 579, 5, 21 UNION ALL 
SELECT 2315, 579, 6, 25 UNION ALL 
SELECT 2316, 579, 8, 26 UNION ALL 
SELECT 2317, 580, 4, 20 UNION ALL 
SELECT 2318, 580, 5, 21 UNION ALL 
SELECT 2319, 580, 6, 25 UNION ALL 
SELECT 2320, 580, 8, 26 UNION ALL 
SELECT 2321, 581, 4, 20 UNION ALL 
SELECT 2322, 581, 5, 21 UNION ALL 
SELECT 2323, 581, 6, 25 UNION ALL 
SELECT 2324, 581, 8, 26 UNION ALL 
SELECT 2325, 582, 4, 20 UNION ALL 
SELECT 2326, 582, 5, 21 UNION ALL 
SELECT 2327, 582, 6, 25 UNION ALL 
SELECT 2328, 582, 8, 26 UNION ALL 
SELECT 2329, 583, 4, 20 UNION ALL 
SELECT 2330, 583, 5, 21 UNION ALL 
SELECT 2331, 583, 6, 25 UNION ALL 
SELECT 2332, 583, 8, 26 UNION ALL 
SELECT 2333, 584, 4, 20 UNION ALL 
SELECT 2334, 584, 5, 21 UNION ALL 
SELECT 2335, 584, 6, 25 UNION ALL 
SELECT 2336, 584, 8, 26 UNION ALL 
SELECT 2337, 585, 4, 20 UNION ALL 
SELECT 2338, 585, 5, 21 UNION ALL 
SELECT 2339, 585, 6, 25 UNION ALL 
SELECT 2340, 585, 8, 26 UNION ALL 
SELECT 2341, 586, 4, 20 UNION ALL 
SELECT 2342, 586, 5, 21 UNION ALL 
SELECT 2343, 586, 6, 25 UNION ALL 
SELECT 2344, 586, 8, 26 UNION ALL 
SELECT 2345, 587, 4, 20 UNION ALL 
SELECT 2346, 587, 5, 22 UNION ALL 
SELECT 2347, 587, 6, 25 UNION ALL 
SELECT 2348, 587, 8, 26 UNION ALL 
SELECT 2349, 588, 4, 20 UNION ALL 
SELECT 2350, 588, 5, 21 UNION ALL 
SELECT 2351, 588, 6, 25 UNION ALL 
SELECT 2352, 588, 8, 26 UNION ALL 
SELECT 2353, 589, 4, 20 UNION ALL 
SELECT 2354, 589, 5, 21 UNION ALL 
SELECT 2355, 589, 6, 25 UNION ALL 
SELECT 2356, 589, 8, 26 UNION ALL 
SELECT 2357, 590, 4, 20 UNION ALL 
SELECT 2358, 590, 5, 21 UNION ALL 
SELECT 2359, 590, 6, 25 UNION ALL 
SELECT 2360, 590, 8, 26 UNION ALL 
SELECT 2361, 591, 4, 20 UNION ALL 
SELECT 2362, 591, 5, 21 UNION ALL 
SELECT 2363, 591, 6, 25 UNION ALL 
SELECT 2364, 591, 8, 26 UNION ALL 
SELECT 2365, 592, 4, 20 UNION ALL 
SELECT 2366, 592, 5, 21 UNION ALL 
SELECT 2367, 592, 6, 25 UNION ALL 
SELECT 2368, 592, 8, 26 UNION ALL 
SELECT 2369, 593, 4, 20 UNION ALL 
SELECT 2370, 593, 5, 21 UNION ALL 
SELECT 2371, 593, 6, 25 UNION ALL 
SELECT 2372, 593, 8, 26 UNION ALL 
SELECT 2373, 594, 4, 20 UNION ALL 
SELECT 2374, 594, 5, 21 UNION ALL 
SELECT 2375, 594, 6, 25 UNION ALL 
SELECT 2376, 594, 8, 26 UNION ALL 
SELECT 2377, 595, 4, 20 UNION ALL 
SELECT 2378, 595, 5, 21 UNION ALL 
SELECT 2379, 595, 6, 25 UNION ALL 
SELECT 2380, 595, 8, 26 UNION ALL 
SELECT 2381, 596, 4, 20 UNION ALL 
SELECT 2382, 596, 5, 22 UNION ALL 
SELECT 2383, 596, 6, 25 UNION ALL 
SELECT 2384, 596, 8, 26 UNION ALL 
SELECT 2385, 597, 4, 20 UNION ALL 
SELECT 2386, 597, 5, 23 UNION ALL 
SELECT 2387, 597, 6, 25 UNION ALL 
SELECT 2388, 597, 8, 27 UNION ALL 
SELECT 2389, 598, 4, 20 UNION ALL 
SELECT 2390, 598, 5, 23 UNION ALL 
SELECT 2391, 598, 6, 25 UNION ALL 
SELECT 2392, 598, 8, 27 UNION ALL 
SELECT 2393, 599, 4, 20 UNION ALL 
SELECT 2394, 599, 5, 23 UNION ALL 
SELECT 2395, 599, 6, 25 UNION ALL 
SELECT 2396, 599, 8, 27 UNION ALL 
SELECT 2397, 600, 4, 20 UNION ALL 
SELECT 2398, 600, 5, 23 UNION ALL 
SELECT 2399, 600, 6, 25 UNION ALL 
SELECT 2400, 600, 8, 27 UNION ALL 
SELECT 2401, 601, 4, 20 UNION ALL 
SELECT 2402, 601, 5, 23 UNION ALL 
SELECT 2403, 601, 6, 25 UNION ALL 
SELECT 2404, 601, 8, 27 UNION ALL 
SELECT 2405, 602, 4, 20 UNION ALL 
SELECT 2406, 602, 5, 23 UNION ALL 
SELECT 2407, 602, 6, 25 UNION ALL 
SELECT 2408, 602, 8, 27 UNION ALL 
SELECT 2409, 603, 4, 20 UNION ALL 
SELECT 2410, 603, 5, 23 UNION ALL 
SELECT 2411, 603, 6, 25 UNION ALL 
SELECT 2412, 603, 8, 27 UNION ALL 
SELECT 2413, 604, 4, 20 UNION ALL 
SELECT 2414, 604, 5, 23 UNION ALL 
SELECT 2415, 604, 6, 25 UNION ALL 
SELECT 2416, 604, 8, 27 UNION ALL 
SELECT 2417, 605, 4, 20 UNION ALL 
SELECT 2418, 605, 5, 23 UNION ALL 
SELECT 2419, 605, 6, 25 UNION ALL 
SELECT 2420, 605, 8, 27 UNION ALL 
SELECT 2421, 606, 4, 20 UNION ALL 
SELECT 2422, 606, 5, 23 UNION ALL 
SELECT 2423, 606, 6, 25 UNION ALL 
SELECT 2424, 606, 8, 27 UNION ALL 
SELECT 2425, 607, 4, 20 UNION ALL 
SELECT 2426, 607, 5, 23 UNION ALL 
SELECT 2427, 607, 6, 25 UNION ALL 
SELECT 2428, 607, 8, 27 UNION ALL 
SELECT 2429, 608, 4, 20 UNION ALL 
SELECT 2430, 608, 5, 23 UNION ALL 
SELECT 2431, 608, 6, 25 UNION ALL 
SELECT 2432, 608, 8, 27 UNION ALL 
SELECT 2433, 609, 4, 20 UNION ALL 
SELECT 2434, 609, 5, 23 UNION ALL 
SELECT 2435, 609, 6, 25 UNION ALL 
SELECT 2436, 609, 8, 27 UNION ALL 
SELECT 2437, 610, 4, 20 UNION ALL 
SELECT 2438, 610, 5, 23 UNION ALL 
SELECT 2439, 610, 6, 25 UNION ALL 
SELECT 2440, 610, 8, 27 UNION ALL 
SELECT 2441, 611, 4, 20 UNION ALL 
SELECT 2442, 611, 5, 23 UNION ALL 
SELECT 2443, 611, 6, 25 UNION ALL 
SELECT 2444, 611, 8, 27 UNION ALL 
SELECT 2445, 612, 4, 20 UNION ALL 
SELECT 2446, 612, 5, 23 UNION ALL 
SELECT 2447, 612, 6, 25 UNION ALL 
SELECT 2448, 612, 8, 27 UNION ALL 
SELECT 2449, 613, 4, 20 UNION ALL 
SELECT 2450, 613, 5, 23 UNION ALL 
SELECT 2451, 613, 6, 25 UNION ALL 
SELECT 2452, 613, 8, 27 UNION ALL 
SELECT 2453, 614, 4, 20 UNION ALL 
SELECT 2454, 614, 5, 23 UNION ALL 
SELECT 2455, 614, 6, 25 UNION ALL 
SELECT 2456, 614, 8, 27 UNION ALL 
SELECT 2457, 615, 4, 20 UNION ALL 
SELECT 2458, 615, 5, 23 UNION ALL 
SELECT 2459, 615, 6, 25 UNION ALL 
SELECT 2460, 615, 8, 27 UNION ALL 
SELECT 2461, 616, 4, 20 UNION ALL 
SELECT 2462, 616, 5, 23 UNION ALL 
SELECT 2463, 616, 6, 25 UNION ALL 
SELECT 2464, 616, 8, 27 UNION ALL 
SELECT 2465, 617, 4, 20 UNION ALL 
SELECT 2466, 617, 5, 23 UNION ALL 
SELECT 2467, 617, 6, 25 UNION ALL 
SELECT 2468, 617, 8, 27 UNION ALL 
SELECT 2469, 618, 4, 20 UNION ALL 
SELECT 2470, 618, 5, 23 UNION ALL 
SELECT 2471, 618, 6, 25 UNION ALL 
SELECT 2472, 618, 8, 27 UNION ALL 
SELECT 2473, 619, 4, 20 UNION ALL 
SELECT 2474, 619, 5, 23 UNION ALL 
SELECT 2475, 619, 6, 25 UNION ALL 
SELECT 2476, 619, 8, 27 UNION ALL 
SELECT 2477, 620, 4, 20 UNION ALL 
SELECT 2478, 620, 5, 23 UNION ALL 
SELECT 2479, 620, 6, 25 UNION ALL 
SELECT 2480, 620, 8, 27 UNION ALL 
SELECT 2481, 621, 4, 20 UNION ALL 
SELECT 2482, 621, 5, 23 UNION ALL 
SELECT 2483, 621, 6, 25 UNION ALL 
SELECT 2484, 621, 8, 27 UNION ALL 
SELECT 2485, 622, 4, 20 UNION ALL 
SELECT 2486, 622, 5, 23 UNION ALL 
SELECT 2487, 622, 6, 25 UNION ALL 
SELECT 2488, 622, 8, 27 UNION ALL 
SELECT 2489, 623, 4, 20 UNION ALL 
SELECT 2490, 623, 5, 23 UNION ALL 
SELECT 2491, 623, 6, 25 UNION ALL 
SELECT 2492, 623, 8, 27 UNION ALL 
SELECT 2493, 624, 4, 20 UNION ALL 
SELECT 2494, 624, 5, 23 UNION ALL 
SELECT 2495, 624, 6, 25 UNION ALL 
SELECT 2496, 624, 8, 27 UNION ALL 
SELECT 2497, 625, 4, 20 UNION ALL 
SELECT 2498, 625, 5, 23 UNION ALL 
SELECT 2499, 625, 6, 25 UNION ALL 
SELECT 2500, 625, 8, 27 UNION ALL 
SELECT 2501, 626, 4, 20 UNION ALL 
SELECT 2502, 626, 5, 22 UNION ALL 
SELECT 2503, 626, 6, 25 UNION ALL 
SELECT 2504, 626, 8, 26 UNION ALL 
SELECT 2505, 627, 4, 20 UNION ALL 
SELECT 2506, 627, 5, 22 UNION ALL 
SELECT 2507, 627, 6, 25 UNION ALL 
SELECT 2508, 627, 8, 26 UNION ALL 
SELECT 2509, 628, 4, 20 UNION ALL 
SELECT 2510, 628, 5, 22 UNION ALL 
SELECT 2511, 628, 6, 25 UNION ALL 
SELECT 2512, 628, 8, 26 UNION ALL 
SELECT 2513, 629, 4, 20 UNION ALL 
SELECT 2514, 629, 5, 21 UNION ALL 
SELECT 2515, 629, 6, 25 UNION ALL 
SELECT 2516, 629, 8, 26 UNION ALL 
SELECT 2517, 630, 4, 20 UNION ALL 
SELECT 2518, 630, 5, 21 UNION ALL 
SELECT 2519, 630, 6, 25 UNION ALL 
SELECT 2520, 630, 8, 26 UNION ALL 
SELECT 2521, 631, 4, 20 UNION ALL 
SELECT 2522, 631, 5, 21 UNION ALL 
SELECT 2523, 631, 6, 25 UNION ALL 
SELECT 2524, 631, 8, 26 UNION ALL 
SELECT 2525, 632, 4, 20 UNION ALL 
SELECT 2526, 632, 5, 21 UNION ALL 
SELECT 2527, 632, 6, 25 UNION ALL 
SELECT 2528, 632, 8, 26 UNION ALL 
SELECT 2529, 633, 4, 20 UNION ALL 
SELECT 2530, 633, 5, 21 UNION ALL 
SELECT 2531, 633, 6, 25 UNION ALL 
SELECT 2532, 633, 8, 26 UNION ALL 
SELECT 2533, 634, 4, 20 UNION ALL 
SELECT 2534, 634, 5, 21 UNION ALL 
SELECT 2535, 634, 6, 25 UNION ALL 
SELECT 2536, 634, 8, 26 UNION ALL 
SELECT 2537, 635, 4, 20 UNION ALL 
SELECT 2538, 635, 5, 21 UNION ALL 
SELECT 2539, 635, 6, 25 UNION ALL 
SELECT 2540, 635, 8, 26 UNION ALL 
SELECT 2541, 636, 4, 20 UNION ALL 
SELECT 2542, 636, 5, 21 UNION ALL 
SELECT 2543, 636, 6, 25 UNION ALL 
SELECT 2544, 636, 8, 26 UNION ALL 
SELECT 2545, 637, 4, 20 UNION ALL 
SELECT 2546, 637, 5, 23 UNION ALL 
SELECT 2547, 637, 6, 25 UNION ALL 
SELECT 2548, 637, 8, 27 UNION ALL 
SELECT 2549, 638, 4, 20 UNION ALL 
SELECT 2550, 638, 5, 23 UNION ALL 
SELECT 2551, 638, 6, 25 UNION ALL 
SELECT 2552, 638, 8, 27 UNION ALL 
SELECT 2553, 639, 4, 20 UNION ALL 
SELECT 2554, 639, 5, 23 UNION ALL 
SELECT 2555, 639, 6, 25 UNION ALL 
SELECT 2556, 639, 8, 27 UNION ALL 
SELECT 2557, 640, 4, 20 UNION ALL 
SELECT 2558, 640, 5, 23 UNION ALL 
SELECT 2559, 640, 6, 25 UNION ALL 
SELECT 2560, 640, 8, 27 UNION ALL 
SELECT 2561, 641, 4, 20 UNION ALL 
SELECT 2562, 641, 5, 23 UNION ALL 
SELECT 2563, 641, 6, 25 UNION ALL 
SELECT 2564, 641, 8, 27 UNION ALL 
SELECT 2565, 642, 4, 20 UNION ALL 
SELECT 2566, 642, 5, 23 UNION ALL 
SELECT 2567, 642, 6, 25 UNION ALL 
SELECT 2568, 642, 8, 27 UNION ALL 
SELECT 2569, 643, 4, 20 UNION ALL 
SELECT 2570, 643, 5, 23 UNION ALL 
SELECT 2571, 643, 6, 25 UNION ALL 
SELECT 2572, 643, 8, 27 UNION ALL 
SELECT 2573, 644, 4, 20 UNION ALL 
SELECT 2574, 644, 5, 23 UNION ALL 
SELECT 2575, 644, 6, 25 UNION ALL 
SELECT 2576, 644, 8, 27 UNION ALL 
SELECT 2577, 645, 4, 20 UNION ALL 
SELECT 2578, 645, 5, 23 UNION ALL 
SELECT 2579, 645, 6, 25 UNION ALL 
SELECT 2580, 645, 8, 27 UNION ALL 
SELECT 2581, 646, 4, 20 UNION ALL 
SELECT 2582, 646, 5, 23 UNION ALL 
SELECT 2583, 646, 6, 25 UNION ALL 
SELECT 2584, 646, 8, 27 UNION ALL 
SELECT 2585, 647, 4, 20 UNION ALL 
SELECT 2586, 647, 5, 23 UNION ALL 
SELECT 2587, 647, 6, 25 UNION ALL 
SELECT 2588, 647, 8, 27 UNION ALL 
SELECT 2589, 648, 4, 20 UNION ALL 
SELECT 2590, 648, 5, 23 UNION ALL 
SELECT 2591, 648, 6, 25 UNION ALL 
SELECT 2592, 648, 8, 27 UNION ALL 
SELECT 2593, 649, 4, 20 UNION ALL 
SELECT 2594, 649, 5, 23 UNION ALL 
SELECT 2595, 649, 6, 25 UNION ALL 
SELECT 2596, 649, 8, 27 UNION ALL 
SELECT 2597, 650, 4, 20 UNION ALL 
SELECT 2598, 650, 5, 23 UNION ALL 
SELECT 2599, 650, 6, 25 UNION ALL 
SELECT 2600, 650, 8, 27 UNION ALL 
SELECT 2601, 651, 4, 20 UNION ALL 
SELECT 2602, 651, 5, 23 UNION ALL 
SELECT 2603, 651, 6, 25 UNION ALL 
SELECT 2604, 651, 8, 27 UNION ALL 
SELECT 2605, 652, 4, 20 UNION ALL 
SELECT 2606, 652, 5, 23 UNION ALL 
SELECT 2607, 652, 6, 25 UNION ALL 
SELECT 2608, 652, 8, 27 UNION ALL 
SELECT 2609, 653, 4, 20 UNION ALL 
SELECT 2610, 653, 5, 23 UNION ALL 
SELECT 2611, 653, 6, 25 UNION ALL 
SELECT 2612, 653, 8, 27 UNION ALL 
SELECT 2613, 654, 4, 20 UNION ALL 
SELECT 2614, 654, 5, 23 UNION ALL 
SELECT 2615, 654, 6, 25 UNION ALL 
SELECT 2616, 654, 8, 27 UNION ALL 
SELECT 2617, 655, 4, 20 UNION ALL 
SELECT 2618, 655, 5, 23 UNION ALL 
SELECT 2619, 655, 6, 25 UNION ALL 
SELECT 2620, 655, 8, 27 UNION ALL 
SELECT 2621, 656, 4, 20 UNION ALL 
SELECT 2622, 656, 5, 23 UNION ALL 
SELECT 2623, 656, 6, 25 UNION ALL 
SELECT 2624, 656, 8, 27 UNION ALL 
SELECT 2625, 657, 4, 20 UNION ALL 
SELECT 2626, 657, 5, 23 UNION ALL 
SELECT 2627, 657, 6, 25 UNION ALL 
SELECT 2628, 657, 8, 27 UNION ALL 
SELECT 2629, 658, 4, 20 UNION ALL 
SELECT 2630, 658, 5, 23 UNION ALL 
SELECT 2631, 658, 6, 25 UNION ALL 
SELECT 2632, 658, 8, 27 UNION ALL 
SELECT 2633, 659, 4, 20 UNION ALL 
SELECT 2634, 659, 5, 23 UNION ALL 
SELECT 2635, 659, 6, 25 UNION ALL 
SELECT 2636, 659, 8, 27 UNION ALL 
SELECT 2637, 660, 4, 20 UNION ALL 
SELECT 2638, 660, 5, 23 UNION ALL 
SELECT 2639, 660, 6, 25 UNION ALL 
SELECT 2640, 660, 8, 27 UNION ALL 
SELECT 2641, 661, 4, 20 UNION ALL 
SELECT 2642, 661, 5, 23 UNION ALL 
SELECT 2643, 661, 6, 25 UNION ALL 
SELECT 2644, 661, 8, 27 UNION ALL 
SELECT 2645, 662, 4, 20 UNION ALL 
SELECT 2646, 662, 5, 23 UNION ALL 
SELECT 2647, 662, 6, 25 UNION ALL 
SELECT 2648, 662, 8, 27 UNION ALL 
SELECT 2649, 663, 4, 20 UNION ALL 
SELECT 2650, 663, 5, 23 UNION ALL 
SELECT 2651, 663, 6, 25 UNION ALL 
SELECT 2652, 663, 8, 27 UNION ALL 
SELECT 2653, 664, 4, 20 UNION ALL 
SELECT 2654, 664, 5, 21 UNION ALL 
SELECT 2655, 664, 6, 25 UNION ALL 
SELECT 2656, 664, 8, 27 UNION ALL 
SELECT 2657, 665, 4, 20 UNION ALL 
SELECT 2658, 665, 5, 21 UNION ALL 
SELECT 2659, 665, 6, 25 UNION ALL 
SELECT 2660, 665, 8, 27 UNION ALL 
SELECT 2661, 666, 4, 20 UNION ALL 
SELECT 2662, 666, 5, 21 UNION ALL 
SELECT 2663, 666, 6, 25 UNION ALL 
SELECT 2664, 666, 8, 27 UNION ALL 
SELECT 2665, 667, 4, 20 UNION ALL 
SELECT 2666, 667, 5, 23 UNION ALL 
SELECT 2667, 667, 6, 25 UNION ALL 
SELECT 2668, 667, 8, 27 UNION ALL 
SELECT 2669, 668, 4, 20 UNION ALL 
SELECT 2670, 668, 5, 23 UNION ALL 
SELECT 2671, 668, 6, 25 UNION ALL 
SELECT 2672, 668, 8, 27 UNION ALL 
SELECT 2673, 669, 4, 20 UNION ALL 
SELECT 2674, 669, 5, 23 UNION ALL 
SELECT 2675, 669, 6, 25 UNION ALL 
SELECT 2676, 669, 8, 27 UNION ALL 
SELECT 2677, 670, 4, 20 UNION ALL 
SELECT 2678, 670, 5, 23 UNION ALL 
SELECT 2679, 670, 6, 25 UNION ALL 
SELECT 2680, 670, 8, 27 UNION ALL 
SELECT 2681, 671, 4, 20 UNION ALL 
SELECT 2682, 671, 5, 23 UNION ALL 
SELECT 2683, 671, 6, 25 UNION ALL 
SELECT 2684, 671, 8, 27 UNION ALL 
SELECT 2685, 672, 4, 20 UNION ALL 
SELECT 2686, 672, 5, 23 UNION ALL 
SELECT 2687, 672, 6, 25 UNION ALL 
SELECT 2688, 672, 8, 27 UNION ALL 
SELECT 2689, 673, 4, 20 UNION ALL 
SELECT 2690, 673, 5, 23 UNION ALL 
SELECT 2691, 673, 6, 25 UNION ALL 
SELECT 2692, 673, 8, 27 UNION ALL 
SELECT 2693, 674, 4, 20 UNION ALL 
SELECT 2694, 674, 5, 23 UNION ALL 
SELECT 2695, 674, 6, 25 UNION ALL 
SELECT 2696, 674, 8, 27 UNION ALL 
SELECT 2697, 675, 4, 20 UNION ALL 
SELECT 2698, 675, 5, 23 UNION ALL 
SELECT 2699, 675, 6, 25 UNION ALL 
SELECT 2700, 675, 8, 27 UNION ALL 
SELECT 2701, 676, 4, 20 UNION ALL 
SELECT 2702, 676, 5, 23 UNION ALL 
SELECT 2703, 676, 6, 25 UNION ALL 
SELECT 2704, 676, 8, 27 UNION ALL 
SELECT 2705, 677, 4, 20 UNION ALL 
SELECT 2706, 677, 5, 23 UNION ALL 
SELECT 2707, 677, 6, 25 UNION ALL 
SELECT 2708, 677, 8, 27 UNION ALL 
SELECT 2709, 678, 4, 20 UNION ALL 
SELECT 2710, 678, 5, 23 UNION ALL 
SELECT 2711, 678, 6, 25 UNION ALL 
SELECT 2712, 678, 8, 27 UNION ALL 
SELECT 2713, 679, 4, 20 UNION ALL 
SELECT 2714, 679, 5, 23 UNION ALL 
SELECT 2715, 679, 6, 25 UNION ALL 
SELECT 2716, 679, 8, 27 UNION ALL 
SELECT 2717, 680, 4, 20 UNION ALL 
SELECT 2718, 680, 5, 23 UNION ALL 
SELECT 2719, 680, 6, 25 UNION ALL 
SELECT 2720, 680, 8, 27 UNION ALL 
SELECT 2721, 681, 4, 20 UNION ALL 
SELECT 2722, 681, 5, 23 UNION ALL 
SELECT 2723, 681, 6, 25 UNION ALL 
SELECT 2724, 681, 8, 27 UNION ALL 
SELECT 2725, 682, 4, 20 UNION ALL 
SELECT 2726, 682, 5, 23 UNION ALL 
SELECT 2727, 682, 6, 25 UNION ALL 
SELECT 2728, 682, 8, 27 UNION ALL 
SELECT 2729, 683, 4, 20 UNION ALL 
SELECT 2730, 683, 5, 23 UNION ALL 
SELECT 2731, 683, 6, 25 UNION ALL 
SELECT 2732, 683, 8, 27 UNION ALL 
SELECT 2733, 684, 4, 20 UNION ALL 
SELECT 2734, 684, 5, 23 UNION ALL 
SELECT 2735, 684, 6, 25 UNION ALL 
SELECT 2736, 684, 8, 27 UNION ALL 
SELECT 2737, 685, 4, 20 UNION ALL 
SELECT 2738, 685, 5, 23 UNION ALL 
SELECT 2739, 685, 6, 25 UNION ALL 
SELECT 2740, 685, 8, 27 UNION ALL 
SELECT 2741, 686, 4, 20 UNION ALL 
SELECT 2742, 686, 5, 23 UNION ALL 
SELECT 2743, 686, 6, 25 UNION ALL 
SELECT 2744, 686, 8, 27 UNION ALL 
SELECT 2745, 687, 4, 20 UNION ALL 
SELECT 2746, 687, 5, 23 UNION ALL 
SELECT 2747, 687, 6, 25 UNION ALL 
SELECT 2748, 687, 8, 27 UNION ALL 
SELECT 2749, 688, 4, 20 UNION ALL 
SELECT 2750, 688, 5, 23 UNION ALL 
SELECT 2751, 688, 6, 25 UNION ALL 
SELECT 2752, 688, 8, 27 UNION ALL 
SELECT 2753, 689, 4, 20 UNION ALL 
SELECT 2754, 689, 5, 23 UNION ALL 
SELECT 2755, 689, 6, 25 UNION ALL 
SELECT 2756, 689, 8, 27 UNION ALL 
SELECT 2757, 690, 4, 20 UNION ALL 
SELECT 2758, 690, 5, 21 UNION ALL 
SELECT 2759, 690, 6, 25 UNION ALL 
SELECT 2760, 690, 8, 27 UNION ALL 
SELECT 2761, 691, 4, 20 UNION ALL 
SELECT 2762, 691, 5, 21 UNION ALL 
SELECT 2763, 691, 6, 25 UNION ALL 
SELECT 2764, 691, 8, 27 UNION ALL 
SELECT 2765, 692, 4, 20 UNION ALL 
SELECT 2766, 692, 5, 21 UNION ALL 
SELECT 2767, 692, 6, 25 UNION ALL 
SELECT 2768, 692, 8, 27 UNION ALL 
SELECT 2769, 693, 4, 20 UNION ALL 
SELECT 2770, 693, 5, 21 UNION ALL 
SELECT 2771, 693, 6, 25 UNION ALL 
SELECT 2772, 693, 8, 27 UNION ALL 
SELECT 2773, 694, 4, 20 UNION ALL 
SELECT 2774, 694, 5, 23 UNION ALL 
SELECT 2775, 694, 6, 25 UNION ALL 
SELECT 2776, 694, 8, 26 UNION ALL 
SELECT 2777, 695, 4, 20 UNION ALL 
SELECT 2778, 695, 5, 21 UNION ALL 
SELECT 2779, 695, 6, 25 UNION ALL 
SELECT 2780, 695, 8, 27 UNION ALL 
SELECT 2781, 696, 4, 20 UNION ALL 
SELECT 2782, 696, 5, 23 UNION ALL 
SELECT 2783, 696, 6, 25 UNION ALL 
SELECT 2784, 696, 8, 27 UNION ALL 
SELECT 2785, 697, 4, 20 UNION ALL 
SELECT 2786, 697, 5, 21 UNION ALL 
SELECT 2787, 697, 6, 25 UNION ALL 
SELECT 2788, 697, 8, 27 UNION ALL 
SELECT 2789, 698, 4, 20 UNION ALL 
SELECT 2790, 698, 5, 21 UNION ALL 
SELECT 2791, 698, 6, 25 UNION ALL 
SELECT 2792, 698, 8, 27 UNION ALL 
SELECT 2793, 699, 4, 20 UNION ALL 
SELECT 2794, 699, 5, 21 UNION ALL 
SELECT 2795, 699, 6, 25 UNION ALL 
SELECT 2796, 699, 8, 27 UNION ALL 
SELECT 2797, 700, 4, 20 UNION ALL 
SELECT 2798, 700, 5, 23 UNION ALL 
SELECT 2799, 700, 6, 25 UNION ALL 
SELECT 2800, 700, 8, 27 UNION ALL 
SELECT 2801, 701, 4, 20 UNION ALL 
SELECT 2802, 701, 5, 23 UNION ALL 
SELECT 2803, 701, 6, 25 UNION ALL 
SELECT 2804, 701, 8, 27 UNION ALL 
SELECT 2805, 702, 4, 20 UNION ALL 
SELECT 2806, 702, 5, 23 UNION ALL 
SELECT 2807, 702, 6, 25 UNION ALL 
SELECT 2808, 702, 8, 27 UNION ALL 
SELECT 2809, 703, 4, 20 UNION ALL 
SELECT 2810, 703, 5, 23 UNION ALL 
SELECT 2811, 703, 6, 25 UNION ALL 
SELECT 2812, 703, 8, 27 UNION ALL 
SELECT 2813, 704, 4, 20 UNION ALL 
SELECT 2814, 704, 5, 23 UNION ALL 
SELECT 2815, 704, 6, 25 UNION ALL 
SELECT 2816, 704, 8, 26 UNION ALL 
SELECT 2817, 705, 4, 20 UNION ALL 
SELECT 2818, 705, 5, 23 UNION ALL 
SELECT 2819, 705, 6, 25 UNION ALL 
SELECT 2820, 705, 8, 26 UNION ALL 
SELECT 2821, 706, 4, 20 UNION ALL 
SELECT 2822, 706, 5, 23 UNION ALL 
SELECT 2823, 706, 6, 25 UNION ALL 
SELECT 2824, 706, 8, 26 UNION ALL 
SELECT 2825, 707, 4, 20 UNION ALL 
SELECT 2826, 707, 5, 23 UNION ALL 
SELECT 2827, 707, 6, 25 UNION ALL 
SELECT 2828, 707, 8, 27 UNION ALL 
SELECT 2829, 708, 4, 20 UNION ALL 
SELECT 2830, 708, 5, 23 UNION ALL 
SELECT 2831, 708, 6, 25 UNION ALL 
SELECT 2832, 708, 8, 27 UNION ALL 
SELECT 2833, 709, 4, 20 UNION ALL 
SELECT 2834, 709, 5, 23 UNION ALL 
SELECT 2835, 709, 6, 25 UNION ALL 
SELECT 2836, 709, 8, 27 UNION ALL 
SELECT 2837, 710, 4, 20 UNION ALL 
SELECT 2838, 710, 5, 21 UNION ALL 
SELECT 2839, 710, 6, 25 UNION ALL 
SELECT 2840, 710, 8, 27 UNION ALL 
SELECT 2841, 711, 4, 20 UNION ALL 
SELECT 2842, 711, 5, 23 UNION ALL 
SELECT 2843, 711, 6, 25 UNION ALL 
SELECT 2844, 711, 8, 27 UNION ALL 
SELECT 2845, 712, 4, 20 UNION ALL 
SELECT 2846, 712, 5, 23 UNION ALL 
SELECT 2847, 712, 6, 25 UNION ALL 
SELECT 2848, 712, 8, 27 UNION ALL 
SELECT 2849, 713, 4, 20 UNION ALL 
SELECT 2850, 713, 5, 23 UNION ALL 
SELECT 2851, 713, 6, 24 UNION ALL 
SELECT 2852, 713, 8, 27 UNION ALL 
SELECT 2853, 714, 4, 20 UNION ALL 
SELECT 2854, 714, 5, 23 UNION ALL 
SELECT 2855, 714, 6, 24 UNION ALL 
SELECT 2856, 714, 8, 27 UNION ALL 
SELECT 2857, 715, 4, 20 UNION ALL 
SELECT 2858, 715, 5, 23 UNION ALL 
SELECT 2859, 715, 6, 24 UNION ALL 
SELECT 2860, 715, 8, 27 UNION ALL 
SELECT 2861, 716, 4, 20 UNION ALL 
SELECT 2862, 716, 5, 23 UNION ALL 
SELECT 2863, 716, 6, 24 UNION ALL 
SELECT 2864, 716, 8, 27 UNION ALL 
SELECT 2865, 717, 4, 20 UNION ALL 
SELECT 2866, 717, 5, 23 UNION ALL 
SELECT 2867, 717, 6, 24 UNION ALL 
SELECT 2868, 717, 8, 27 UNION ALL 
SELECT 2869, 718, 4, 20 UNION ALL 
SELECT 2870, 718, 5, 23 UNION ALL 
SELECT 2871, 718, 6, 24 UNION ALL 
SELECT 2872, 718, 8, 27 UNION ALL 
SELECT 2873, 719, 4, 20 UNION ALL 
SELECT 2874, 719, 5, 23 UNION ALL 
SELECT 2875, 719, 6, 25 UNION ALL 
SELECT 2876, 719, 8, 27 UNION ALL 
SELECT 2877, 720, 4, 20 UNION ALL 
SELECT 2878, 720, 5, 23 UNION ALL 
SELECT 2879, 720, 6, 25 UNION ALL 
SELECT 2880, 720, 8, 27 UNION ALL 
SELECT 2881, 721, 4, 20 UNION ALL 
SELECT 2882, 721, 5, 23 UNION ALL 
SELECT 2883, 721, 6, 25 UNION ALL 
SELECT 2884, 721, 8, 27 UNION ALL 
SELECT 2885, 722, 4, 20 UNION ALL 
SELECT 2886, 722, 5, 23 UNION ALL 
SELECT 2887, 722, 6, 25 UNION ALL 
SELECT 2888, 722, 8, 27 UNION ALL 
SELECT 2889, 723, 4, 20 UNION ALL 
SELECT 2890, 723, 5, 23 UNION ALL 
SELECT 2891, 723, 6, 25 UNION ALL 
SELECT 2892, 723, 8, 27 UNION ALL 
SELECT 2893, 724, 4, 20 UNION ALL 
SELECT 2894, 724, 5, 23 UNION ALL 
SELECT 2895, 724, 6, 25 UNION ALL 
SELECT 2896, 724, 8, 27 UNION ALL 
SELECT 2897, 725, 4, 20 UNION ALL 
SELECT 2898, 725, 5, 23 UNION ALL 
SELECT 2899, 725, 6, 25 UNION ALL 
SELECT 2900, 725, 8, 27 UNION ALL 
SELECT 2901, 726, 4, 20 UNION ALL 
SELECT 2902, 726, 5, 23 UNION ALL 
SELECT 2903, 726, 6, 25 UNION ALL 
SELECT 2904, 726, 8, 27 UNION ALL 
SELECT 2905, 727, 4, 20 UNION ALL 
SELECT 2906, 727, 5, 23 UNION ALL 
SELECT 2907, 727, 6, 25 UNION ALL 
SELECT 2908, 727, 8, 27 UNION ALL 
SELECT 2909, 728, 4, 20 UNION ALL 
SELECT 2910, 728, 5, 23 UNION ALL 
SELECT 2911, 728, 6, 25 UNION ALL 
SELECT 2912, 728, 8, 27 UNION ALL 
SELECT 2913, 729, 4, 20 UNION ALL 
SELECT 2914, 729, 5, 23 UNION ALL 
SELECT 2915, 729, 6, 25 UNION ALL 
SELECT 2916, 729, 8, 27 UNION ALL 
SELECT 2917, 730, 4, 20 UNION ALL 
SELECT 2918, 730, 5, 23 UNION ALL 
SELECT 2919, 730, 6, 25 UNION ALL 
SELECT 2920, 730, 8, 27 UNION ALL 
SELECT 2921, 731, 4, 20 UNION ALL 
SELECT 2922, 731, 5, 23 UNION ALL 
SELECT 2923, 731, 6, 25 UNION ALL 
SELECT 2924, 731, 8, 27 UNION ALL 
SELECT 2925, 732, 4, 20 UNION ALL 
SELECT 2926, 732, 5, 23 UNION ALL 
SELECT 2927, 732, 6, 25 UNION ALL 
SELECT 2928, 732, 8, 27 UNION ALL 
SELECT 2929, 733, 4, 20 UNION ALL 
SELECT 2930, 733, 5, 23 UNION ALL 
SELECT 2931, 733, 6, 25 UNION ALL 
SELECT 2932, 733, 8, 27 UNION ALL 
SELECT 2933, 734, 4, 20 UNION ALL 
SELECT 2934, 734, 5, 23 UNION ALL 
SELECT 2935, 734, 6, 25 UNION ALL 
SELECT 2936, 734, 8, 27 UNION ALL 
SELECT 2937, 735, 4, 20 UNION ALL 
SELECT 2938, 735, 5, 23 UNION ALL 
SELECT 2939, 735, 6, 25 UNION ALL 
SELECT 2940, 735, 8, 27 UNION ALL 
SELECT 2941, 736, 4, 20 UNION ALL 
SELECT 2942, 736, 5, 23 UNION ALL 
SELECT 2943, 736, 6, 25 UNION ALL 
SELECT 2944, 736, 8, 27 UNION ALL 
SELECT 2945, 737, 4, 20 UNION ALL 
SELECT 2946, 737, 5, 23 UNION ALL 
SELECT 2947, 737, 6, 25 UNION ALL 
SELECT 2948, 737, 8, 27 UNION ALL 
SELECT 2949, 738, 4, 20 UNION ALL 
SELECT 2950, 738, 5, 23 UNION ALL 
SELECT 2951, 738, 6, 25 UNION ALL 
SELECT 2952, 738, 8, 27 UNION ALL 
SELECT 2953, 739, 4, 20 UNION ALL 
SELECT 2954, 739, 5, 23 UNION ALL 
SELECT 2955, 739, 6, 25 UNION ALL 
SELECT 2956, 739, 8, 27 UNION ALL 
SELECT 2957, 740, 4, 20 UNION ALL 
SELECT 2958, 740, 5, 23 UNION ALL 
SELECT 2959, 740, 6, 25 UNION ALL 
SELECT 2960, 740, 8, 27 UNION ALL 
SELECT 2961, 741, 4, 20 UNION ALL 
SELECT 2962, 741, 5, 23 UNION ALL 
SELECT 2963, 741, 6, 25 UNION ALL 
SELECT 2964, 741, 8, 27 UNION ALL 
SELECT 2965, 742, 4, 20 UNION ALL 
SELECT 2966, 742, 5, 23 UNION ALL 
SELECT 2967, 742, 6, 25 UNION ALL 
SELECT 2968, 742, 8, 27 UNION ALL 
SELECT 2969, 743, 4, 20 UNION ALL 
SELECT 2970, 743, 5, 23 UNION ALL 
SELECT 2971, 743, 6, 25 UNION ALL 
SELECT 2972, 743, 8, 27 UNION ALL 
SELECT 2973, 744, 4, 20 UNION ALL 
SELECT 2974, 744, 5, 23 UNION ALL 
SELECT 2975, 744, 6, 25 UNION ALL 
SELECT 2976, 744, 8, 27 UNION ALL 
SELECT 2977, 745, 4, 20 UNION ALL 
SELECT 2978, 745, 5, 23 UNION ALL 
SELECT 2979, 745, 6, 25 UNION ALL 
SELECT 2980, 745, 8, 27 UNION ALL 
SELECT 2981, 746, 4, 20 UNION ALL 
SELECT 2982, 746, 5, 23 UNION ALL 
SELECT 2983, 746, 6, 25 UNION ALL 
SELECT 2984, 746, 8, 27 UNION ALL 
SELECT 2985, 747, 4, 20 UNION ALL 
SELECT 2986, 747, 5, 23 UNION ALL 
SELECT 2987, 747, 6, 25 UNION ALL 
SELECT 2988, 747, 8, 27 UNION ALL 
SELECT 2989, 748, 4, 20 UNION ALL 
SELECT 2990, 748, 5, 23 UNION ALL 
SELECT 2991, 748, 6, 25 UNION ALL 
SELECT 2992, 748, 8, 27 UNION ALL 
SELECT 2993, 749, 4, 20 UNION ALL 
SELECT 2994, 749, 5, 23 UNION ALL 
SELECT 2995, 749, 6, 25 UNION ALL 
SELECT 2996, 749, 8, 27 UNION ALL 
SELECT 2997, 750, 4, 20 UNION ALL 
SELECT 2998, 750, 5, 23 UNION ALL 
SELECT 2999, 750, 6, 25 UNION ALL 
SELECT 3000, 750, 8, 27 UNION ALL 
SELECT 3001, 751, 4, 20 UNION ALL 
SELECT 3002, 751, 5, 23 UNION ALL 
SELECT 3003, 751, 6, 25 UNION ALL 
SELECT 3004, 751, 8, 27 UNION ALL 
SELECT 3005, 752, 4, 20 UNION ALL 
SELECT 3006, 752, 5, 23 UNION ALL 
SELECT 3007, 752, 6, 25 UNION ALL 
SELECT 3008, 752, 8, 27 UNION ALL 
SELECT 3009, 753, 4, 20 UNION ALL 
SELECT 3010, 753, 5, 23 UNION ALL 
SELECT 3011, 753, 6, 25 UNION ALL 
SELECT 3012, 753, 8, 27 UNION ALL 
SELECT 3013, 754, 4, 20 UNION ALL 
SELECT 3014, 754, 5, 23 UNION ALL 
SELECT 3015, 754, 6, 25 UNION ALL 
SELECT 3016, 754, 8, 27 UNION ALL 
SELECT 3017, 755, 4, 20 UNION ALL 
SELECT 3018, 755, 5, 23 UNION ALL 
SELECT 3019, 755, 6, 25 UNION ALL 
SELECT 3020, 755, 8, 27 UNION ALL 
SELECT 3021, 756, 4, 20 UNION ALL 
SELECT 3022, 756, 5, 23 UNION ALL 
SELECT 3023, 756, 6, 25 UNION ALL 
SELECT 3024, 756, 8, 27 UNION ALL 
SELECT 3025, 757, 4, 20 UNION ALL 
SELECT 3026, 757, 5, 23 UNION ALL 
SELECT 3027, 757, 6, 25 UNION ALL 
SELECT 3028, 757, 8, 27 UNION ALL 
SELECT 3029, 758, 4, 20 UNION ALL 
SELECT 3030, 758, 5, 23 UNION ALL 
SELECT 3031, 758, 6, 25 UNION ALL 
SELECT 3032, 758, 8, 27 UNION ALL 
SELECT 3033, 759, 4, 20 UNION ALL 
SELECT 3034, 759, 5, 23 UNION ALL 
SELECT 3035, 759, 6, 25 UNION ALL 
SELECT 3036, 759, 8, 27 UNION ALL 
SELECT 3037, 760, 4, 20 UNION ALL 
SELECT 3038, 760, 5, 23 UNION ALL 
SELECT 3039, 760, 6, 25 UNION ALL 
SELECT 3040, 760, 8, 27 UNION ALL 
SELECT 3041, 761, 4, 20 UNION ALL 
SELECT 3042, 761, 5, 23 UNION ALL 
SELECT 3043, 761, 6, 25 UNION ALL 
SELECT 3044, 761, 8, 27 UNION ALL 
SELECT 3045, 762, 4, 20 UNION ALL 
SELECT 3046, 762, 5, 23 UNION ALL 
SELECT 3047, 762, 6, 25 UNION ALL 
SELECT 3048, 762, 8, 27 UNION ALL 
SELECT 3049, 763, 4, 20 UNION ALL 
SELECT 3050, 763, 5, 23 UNION ALL 
SELECT 3051, 763, 6, 25 UNION ALL 
SELECT 3052, 763, 8, 27 UNION ALL 
SELECT 3053, 764, 4, 20 UNION ALL 
SELECT 3054, 764, 5, 23 UNION ALL 
SELECT 3055, 764, 6, 25 UNION ALL 
SELECT 3056, 764, 8, 27 UNION ALL 
SELECT 3057, 765, 4, 20 UNION ALL 
SELECT 3058, 765, 5, 23 UNION ALL 
SELECT 3059, 765, 6, 25 UNION ALL 
SELECT 3060, 765, 8, 27 UNION ALL 
SELECT 3061, 766, 4, 20 UNION ALL 
SELECT 3062, 766, 5, 23 UNION ALL 
SELECT 3063, 766, 6, 25 UNION ALL 
SELECT 3064, 766, 8, 27 UNION ALL 
SELECT 3065, 767, 4, 20 UNION ALL 
SELECT 3066, 767, 5, 23 UNION ALL 
SELECT 3067, 767, 6, 25 UNION ALL 
SELECT 3068, 767, 8, 27 UNION ALL 
SELECT 3069, 768, 4, 20 UNION ALL 
SELECT 3070, 768, 5, 23 UNION ALL 
SELECT 3071, 768, 6, 25 UNION ALL 
SELECT 3072, 768, 8, 27 UNION ALL 
SELECT 3073, 769, 4, 20 UNION ALL 
SELECT 3074, 769, 5, 23 UNION ALL 
SELECT 3075, 769, 6, 25 UNION ALL 
SELECT 3076, 769, 8, 27 UNION ALL 
SELECT 3077, 770, 4, 20 UNION ALL 
SELECT 3078, 770, 5, 23 UNION ALL 
SELECT 3079, 770, 6, 25 UNION ALL 
SELECT 3080, 770, 8, 27 UNION ALL 
SELECT 3081, 771, 4, 20 UNION ALL 
SELECT 3082, 771, 5, 23 UNION ALL 
SELECT 3083, 771, 6, 25 UNION ALL 
SELECT 3084, 771, 8, 27 UNION ALL 
SELECT 3085, 772, 4, 20 UNION ALL 
SELECT 3086, 772, 5, 23 UNION ALL 
SELECT 3087, 772, 6, 25 UNION ALL 
SELECT 3088, 772, 8, 27 UNION ALL 
SELECT 3089, 773, 4, 20 UNION ALL 
SELECT 3090, 773, 5, 23 UNION ALL 
SELECT 3091, 773, 6, 25 UNION ALL 
SELECT 3092, 773, 8, 27 UNION ALL 
SELECT 3093, 774, 4, 20 UNION ALL 
SELECT 3094, 774, 5, 23 UNION ALL 
SELECT 3095, 774, 6, 25 UNION ALL 
SELECT 3096, 774, 8, 27 UNION ALL 
SELECT 3097, 775, 4, 20 UNION ALL 
SELECT 3098, 775, 5, 23 UNION ALL 
SELECT 3099, 775, 6, 25 UNION ALL 
SELECT 3100, 775, 8, 27 UNION ALL 
SELECT 3101, 776, 4, 20 UNION ALL 
SELECT 3102, 776, 5, 23 UNION ALL 
SELECT 3103, 776, 6, 25 UNION ALL 
SELECT 3104, 776, 8, 27 UNION ALL 
SELECT 3105, 777, 4, 20 UNION ALL 
SELECT 3106, 777, 5, 23 UNION ALL 
SELECT 3107, 777, 6, 25 UNION ALL 
SELECT 3108, 777, 8, 27 UNION ALL 
SELECT 3109, 778, 4, 20 UNION ALL 
SELECT 3110, 778, 5, 23 UNION ALL 
SELECT 3111, 778, 6, 25 UNION ALL 
SELECT 3112, 778, 8, 27 UNION ALL 
SELECT 3113, 779, 4, 20 UNION ALL 
SELECT 3114, 779, 5, 23 UNION ALL 
SELECT 3115, 779, 6, 25 UNION ALL 
SELECT 3116, 779, 8, 27 UNION ALL 
SELECT 3117, 780, 4, 20 UNION ALL 
SELECT 3118, 780, 5, 23 UNION ALL 
SELECT 3119, 780, 6, 25 UNION ALL 
SELECT 3120, 780, 8, 27 UNION ALL 
SELECT 3121, 781, 4, 20 UNION ALL 
SELECT 3122, 781, 5, 23 UNION ALL 
SELECT 3123, 781, 6, 25 UNION ALL 
SELECT 3124, 781, 8, 27 UNION ALL 
SELECT 3125, 782, 4, 20 UNION ALL 
SELECT 3126, 782, 5, 23 UNION ALL 
SELECT 3127, 782, 6, 25 UNION ALL 
SELECT 3128, 782, 8, 27 UNION ALL 
SELECT 3129, 783, 4, 20 UNION ALL 
SELECT 3130, 783, 5, 23 UNION ALL 
SELECT 3131, 783, 6, 25 UNION ALL 
SELECT 3132, 783, 8, 27 UNION ALL 
SELECT 3133, 784, 4, 20 UNION ALL 
SELECT 3134, 784, 5, 23 UNION ALL 
SELECT 3135, 784, 6, 25 UNION ALL 
SELECT 3136, 784, 8, 27 UNION ALL 
SELECT 3137, 785, 4, 20 UNION ALL 
SELECT 3138, 785, 5, 23 UNION ALL 
SELECT 3139, 785, 6, 25 UNION ALL 
SELECT 3140, 785, 8, 27 UNION ALL 
SELECT 3141, 786, 4, 20 UNION ALL 
SELECT 3142, 786, 5, 23 UNION ALL 
SELECT 3143, 786, 6, 25 UNION ALL 
SELECT 3144, 786, 8, 27 UNION ALL 
SELECT 3145, 787, 4, 20 UNION ALL 
SELECT 3146, 787, 5, 23 UNION ALL 
SELECT 3147, 787, 6, 25 UNION ALL 
SELECT 3148, 787, 8, 27 UNION ALL 
SELECT 3149, 788, 4, 20 UNION ALL 
SELECT 3150, 788, 5, 23 UNION ALL 
SELECT 3151, 788, 6, 25 UNION ALL 
SELECT 3152, 788, 8, 27 UNION ALL 
SELECT 3153, 789, 4, 20 UNION ALL 
SELECT 3154, 789, 5, 23 UNION ALL 
SELECT 3155, 789, 6, 25 UNION ALL 
SELECT 3156, 789, 8, 27 UNION ALL 
SELECT 3157, 790, 4, 20 UNION ALL 
SELECT 3158, 790, 5, 23 UNION ALL 
SELECT 3159, 790, 6, 25 UNION ALL 
SELECT 3160, 790, 8, 27 UNION ALL 
SELECT 3161, 791, 4, 20 UNION ALL 
SELECT 3162, 791, 5, 23 UNION ALL 
SELECT 3163, 791, 6, 25 UNION ALL 
SELECT 3164, 791, 8, 27 UNION ALL 
SELECT 3165, 792, 4, 20 UNION ALL 
SELECT 3166, 792, 5, 23 UNION ALL 
SELECT 3167, 792, 6, 25 UNION ALL 
SELECT 3168, 792, 8, 27 UNION ALL 
SELECT 3169, 793, 4, 20 UNION ALL 
SELECT 3170, 793, 5, 23 UNION ALL 
SELECT 3171, 793, 6, 25 UNION ALL 
SELECT 3172, 793, 8, 27 UNION ALL 
SELECT 3173, 794, 4, 20 UNION ALL 
SELECT 3174, 794, 5, 23 UNION ALL 
SELECT 3175, 794, 6, 25 UNION ALL 
SELECT 3176, 794, 8, 27 UNION ALL 
SELECT 3177, 795, 4, 20 UNION ALL 
SELECT 3178, 795, 5, 23 UNION ALL 
SELECT 3179, 795, 6, 25 UNION ALL 
SELECT 3180, 795, 8, 27 UNION ALL 
SELECT 3181, 796, 4, 20 UNION ALL 
SELECT 3182, 796, 5, 23 UNION ALL 
SELECT 3183, 796, 6, 25 UNION ALL 
SELECT 3184, 796, 8, 27 UNION ALL 
SELECT 3185, 797, 4, 20 UNION ALL 
SELECT 3186, 797, 5, 23 UNION ALL 
SELECT 3187, 797, 6, 25 UNION ALL 
SELECT 3188, 797, 8, 27 UNION ALL 
SELECT 3189, 798, 4, 20 UNION ALL 
SELECT 3190, 798, 5, 23 UNION ALL 
SELECT 3191, 798, 6, 25 UNION ALL 
SELECT 3192, 798, 8, 27 UNION ALL 
SELECT 3193, 799, 4, 20 UNION ALL 
SELECT 3194, 799, 5, 23 UNION ALL 
SELECT 3195, 799, 6, 25 UNION ALL 
SELECT 3196, 799, 8, 27 UNION ALL 
SELECT 3197, 800, 4, 20 UNION ALL 
SELECT 3198, 800, 5, 23 UNION ALL 
SELECT 3199, 800, 6, 25 UNION ALL 
SELECT 3200, 800, 8, 27 UNION ALL 
SELECT 3201, 801, 4, 20 UNION ALL 
SELECT 3202, 801, 5, 23 UNION ALL 
SELECT 3203, 801, 6, 25 UNION ALL 
SELECT 3204, 801, 8, 27 UNION ALL 
SELECT 3205, 802, 4, 20 UNION ALL 
SELECT 3206, 802, 5, 23 UNION ALL 
SELECT 3207, 802, 6, 25 UNION ALL 
SELECT 3208, 802, 8, 27 UNION ALL 
SELECT 3209, 803, 4, 20 UNION ALL 
SELECT 3210, 803, 5, 23 UNION ALL 
SELECT 3211, 803, 6, 25 UNION ALL 
SELECT 3212, 803, 8, 27 UNION ALL 
SELECT 3213, 804, 4, 20 UNION ALL 
SELECT 3214, 804, 5, 23 UNION ALL 
SELECT 3215, 804, 6, 25 UNION ALL 
SELECT 3216, 804, 8, 27 UNION ALL 
SELECT 3217, 805, 4, 20 UNION ALL 
SELECT 3218, 805, 5, 23 UNION ALL 
SELECT 3219, 805, 6, 25 UNION ALL 
SELECT 3220, 805, 8, 27 UNION ALL 
SELECT 3221, 806, 4, 20 UNION ALL 
SELECT 3222, 806, 5, 23 UNION ALL 
SELECT 3223, 806, 6, 25 UNION ALL 
SELECT 3224, 806, 8, 27 UNION ALL 
SELECT 3225, 807, 4, 20 UNION ALL 
SELECT 3226, 807, 5, 23 UNION ALL 
SELECT 3227, 807, 6, 25 UNION ALL 
SELECT 3228, 807, 8, 27 UNION ALL 
SELECT 3229, 808, 4, 20 UNION ALL 
SELECT 3230, 808, 5, 23 UNION ALL 
SELECT 3231, 808, 6, 25 UNION ALL 
SELECT 3232, 808, 8, 27 UNION ALL 
SELECT 3233, 809, 4, 20 UNION ALL 
SELECT 3234, 809, 5, 23 UNION ALL 
SELECT 3235, 809, 6, 25 UNION ALL 
SELECT 3236, 809, 8, 27 UNION ALL 
SELECT 3237, 810, 4, 20 UNION ALL 
SELECT 3238, 810, 5, 23 UNION ALL 
SELECT 3239, 810, 6, 25 UNION ALL 
SELECT 3240, 810, 8, 27 UNION ALL 
SELECT 3241, 811, 4, 20 UNION ALL 
SELECT 3242, 811, 5, 23 UNION ALL 
SELECT 3243, 811, 6, 25 UNION ALL 
SELECT 3244, 811, 8, 27 UNION ALL 
SELECT 3245, 812, 4, 20 UNION ALL 
SELECT 3246, 812, 5, 23 UNION ALL 
SELECT 3247, 812, 6, 25 UNION ALL 
SELECT 3248, 812, 8, 27 UNION ALL 
SELECT 3249, 813, 4, 20 UNION ALL 
SELECT 3250, 813, 5, 23 UNION ALL 
SELECT 3251, 813, 6, 25 UNION ALL 
SELECT 3252, 813, 8, 27 UNION ALL 
SELECT 3253, 814, 4, 20 UNION ALL 
SELECT 3254, 814, 5, 23 UNION ALL 
SELECT 3255, 814, 6, 25 UNION ALL 
SELECT 3256, 814, 8, 27 UNION ALL 
SELECT 3257, 815, 4, 20 UNION ALL 
SELECT 3258, 815, 5, 23 UNION ALL 
SELECT 3259, 815, 6, 25 UNION ALL 
SELECT 3260, 815, 8, 27 UNION ALL 
SELECT 3261, 816, 4, 20 UNION ALL 
SELECT 3262, 816, 5, 23 UNION ALL 
SELECT 3263, 816, 6, 25 UNION ALL 
SELECT 3264, 816, 8, 27 UNION ALL 
SELECT 3265, 817, 4, 20 UNION ALL 
SELECT 3266, 817, 5, 23 UNION ALL 
SELECT 3267, 817, 6, 25 UNION ALL 
SELECT 3268, 817, 8, 27 UNION ALL 
SELECT 3269, 818, 4, 20 UNION ALL 
SELECT 3270, 818, 5, 23 UNION ALL 
SELECT 3271, 818, 6, 25 UNION ALL 
SELECT 3272, 818, 8, 27 UNION ALL 
SELECT 3273, 819, 4, 20 UNION ALL 
SELECT 3274, 819, 5, 23 UNION ALL 
SELECT 3275, 819, 6, 25 UNION ALL 
SELECT 3276, 819, 8, 27 UNION ALL 
SELECT 3277, 820, 4, 20 UNION ALL 
SELECT 3278, 820, 5, 23 UNION ALL 
SELECT 3279, 820, 6, 25 UNION ALL 
SELECT 3280, 820, 8, 27 UNION ALL 
SELECT 3281, 821, 4, 20 UNION ALL 
SELECT 3282, 821, 5, 23 UNION ALL 
SELECT 3283, 821, 6, 25 UNION ALL 
SELECT 3284, 821, 8, 27 UNION ALL 
SELECT 3285, 822, 4, 20 UNION ALL 
SELECT 3286, 822, 5, 21 UNION ALL 
SELECT 3287, 822, 6, 25 UNION ALL 
SELECT 3288, 822, 8, 27 UNION ALL 
SELECT 3289, 823, 4, 20 UNION ALL 
SELECT 3290, 823, 5, 23 UNION ALL 
SELECT 3291, 823, 6, 25 UNION ALL 
SELECT 3292, 823, 8, 27 UNION ALL 
SELECT 3293, 824, 4, 20 UNION ALL 
SELECT 3294, 824, 5, 23 UNION ALL 
SELECT 3295, 824, 6, 25 UNION ALL 
SELECT 3296, 824, 8, 27 UNION ALL 
SELECT 3297, 825, 4, 20 UNION ALL 
SELECT 3298, 825, 5, 21 UNION ALL 
SELECT 3299, 825, 6, 25 UNION ALL 
SELECT 3300, 825, 8, 26 UNION ALL 
SELECT 3301, 826, 4, 20 UNION ALL 
SELECT 3302, 826, 5, 21 UNION ALL 
SELECT 3303, 826, 6, 25 UNION ALL 
SELECT 3304, 826, 8, 26 UNION ALL 
SELECT 3305, 827, 4, 20 UNION ALL 
SELECT 3306, 827, 5, 21 UNION ALL 
SELECT 3307, 827, 6, 25 UNION ALL 
SELECT 3308, 827, 8, 26 UNION ALL 
SELECT 3309, 828, 4, 20 UNION ALL 
SELECT 3310, 828, 5, 21 UNION ALL 
SELECT 3311, 828, 6, 25 UNION ALL 
SELECT 3312, 828, 8, 26 UNION ALL 
SELECT 3313, 829, 4, 20 UNION ALL 
SELECT 3314, 829, 5, 21 UNION ALL 
SELECT 3315, 829, 6, 25 UNION ALL 
SELECT 3316, 829, 8, 26 UNION ALL 
SELECT 3317, 830, 4, 20 UNION ALL 
SELECT 3318, 830, 5, 22 UNION ALL 
SELECT 3319, 830, 6, 25 UNION ALL 
SELECT 3320, 830, 8, 26 UNION ALL 
SELECT 3321, 831, 4, 20 UNION ALL 
SELECT 3322, 831, 5, 22 UNION ALL 
SELECT 3323, 831, 6, 25 UNION ALL 
SELECT 3324, 831, 8, 26 UNION ALL 
SELECT 3325, 832, 4, 20 UNION ALL 
SELECT 3326, 832, 5, 21 UNION ALL 
SELECT 3327, 832, 6, 25 UNION ALL 
SELECT 3328, 832, 8, 26 UNION ALL 
SELECT 3329, 833, 4, 20 UNION ALL 
SELECT 3330, 833, 5, 21 UNION ALL 
SELECT 3331, 833, 6, 25 UNION ALL 
SELECT 3332, 833, 8, 26 UNION ALL 
SELECT 3333, 834, 4, 20 UNION ALL 
SELECT 3334, 834, 5, 21 UNION ALL 
SELECT 3335, 834, 6, 25 UNION ALL 
SELECT 3336, 834, 8, 26 UNION ALL 
SELECT 3337, 835, 4, 20 UNION ALL 
SELECT 3338, 835, 5, 21 UNION ALL 
SELECT 3339, 835, 6, 25 UNION ALL 
SELECT 3340, 835, 8, 26 UNION ALL 
SELECT 3341, 836, 4, 20 UNION ALL 
SELECT 3342, 836, 5, 21 UNION ALL 
SELECT 3343, 836, 6, 25 UNION ALL 
SELECT 3344, 836, 8, 26 UNION ALL 
SELECT 3345, 837, 4, 20 UNION ALL 
SELECT 3346, 837, 5, 21 UNION ALL 
SELECT 3347, 837, 6, 25 UNION ALL 
SELECT 3348, 837, 8, 26 UNION ALL 
SELECT 3349, 838, 4, 20 UNION ALL 
SELECT 3350, 838, 5, 22 UNION ALL 
SELECT 3351, 838, 6, 25 UNION ALL 
SELECT 3352, 838, 8, 26 UNION ALL 
SELECT 3353, 839, 4, 20 UNION ALL 
SELECT 3354, 839, 5, 23 UNION ALL 
SELECT 3355, 839, 6, 25 UNION ALL 
SELECT 3356, 839, 8, 27 UNION ALL 
SELECT 3357, 840, 4, 20 UNION ALL 
SELECT 3358, 840, 5, 23 UNION ALL 
SELECT 3359, 840, 6, 25 UNION ALL 
SELECT 3360, 840, 8, 27 UNION ALL 
SELECT 3361, 841, 4, 20 UNION ALL 
SELECT 3362, 841, 5, 23 UNION ALL 
SELECT 3363, 841, 6, 25 UNION ALL 
SELECT 3364, 841, 8, 27 UNION ALL 
SELECT 3365, 842, 4, 20 UNION ALL 
SELECT 3366, 842, 5, 21 UNION ALL 
SELECT 3367, 842, 6, 25 UNION ALL 
SELECT 3368, 842, 8, 26 UNION ALL 
SELECT 3369, 843, 4, 20 UNION ALL 
SELECT 3370, 843, 5, 21 UNION ALL 
SELECT 3371, 843, 6, 25 UNION ALL 
SELECT 3372, 843, 8, 26 UNION ALL 
SELECT 3373, 844, 4, 20 UNION ALL 
SELECT 3374, 844, 5, 21 UNION ALL 
SELECT 3375, 844, 6, 25 UNION ALL 
SELECT 3376, 844, 8, 26 UNION ALL 
SELECT 3377, 845, 4, 20 UNION ALL 
SELECT 3378, 845, 5, 22 UNION ALL 
SELECT 3379, 845, 6, 25 UNION ALL 
SELECT 3380, 845, 8, 26 UNION ALL 
SELECT 3381, 846, 4, 20 UNION ALL 
SELECT 3382, 846, 5, 23 UNION ALL 
SELECT 3383, 846, 6, 25 UNION ALL 
SELECT 3384, 846, 8, 27 UNION ALL 
SELECT 3385, 847, 4, 20 UNION ALL 
SELECT 3386, 847, 5, 23 UNION ALL 
SELECT 3387, 847, 6, 25 UNION ALL 
SELECT 3388, 847, 8, 27 UNION ALL 
SELECT 3389, 848, 4, 20 UNION ALL 
SELECT 3390, 848, 5, 21 UNION ALL 
SELECT 3391, 848, 6, 25 UNION ALL 
SELECT 3392, 848, 8, 27 UNION ALL 
SELECT 3393, 849, 4, 20 UNION ALL 
SELECT 3394, 849, 5, 23 UNION ALL 
SELECT 3395, 849, 6, 25 UNION ALL 
SELECT 3396, 849, 8, 27 UNION ALL 
SELECT 3397, 850, 4, 20 UNION ALL 
SELECT 3398, 850, 5, 23 UNION ALL 
SELECT 3399, 850, 6, 25 UNION ALL 
SELECT 3400, 850, 8, 27 UNION ALL 
SELECT 3401, 851, 4, 20 UNION ALL 
SELECT 3402, 851, 5, 23 UNION ALL 
SELECT 3403, 851, 6, 25 UNION ALL 
SELECT 3404, 851, 8, 27 
COMMIT;
SET IDENTITY_INSERT [dbo].[WordsProperties] OFF


GO


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

SET IDENTITY_INSERT [dbo].[GrammarForms] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[GrammarForms] ([Id], [WordId], [FormId], [Content])
SELECT 1, 1, 10, N'Polska' UNION ALL 
SELECT 2, 1, 11, N'Polski' UNION ALL 
SELECT 3, 1, 12, N'Polsce' UNION ALL 
SELECT 4, 1, 13, N'Polskę' UNION ALL 
SELECT 5, 1, 14, N'z Polską' UNION ALL 
SELECT 6, 1, 15, N'Polsce' UNION ALL 
SELECT 7, 1, 16, N'Polsko' UNION ALL 
SELECT 8, 1, 17, N'do Polski' UNION ALL 
SELECT 9, 1, 18, N'w Polsce' UNION ALL 
SELECT 10, 2, 10, N'pies' UNION ALL 
SELECT 11, 2, 11, N'psa' UNION ALL 
SELECT 12, 2, 12, N'psu' UNION ALL 
SELECT 13, 2, 13, N'psa' UNION ALL 
SELECT 14, 2, 14, N'z psem' UNION ALL 
SELECT 15, 2, 15, N'psie' UNION ALL 
SELECT 16, 2, 16, N'psie' UNION ALL 
SELECT 17, 2, 19, N'psy' UNION ALL 
SELECT 18, 2, 20, N'psów' UNION ALL 
SELECT 19, 2, 21, N'psom' UNION ALL 
SELECT 20, 2, 22, N'psy' UNION ALL 
SELECT 21, 2, 23, N'z psami' UNION ALL 
SELECT 22, 2, 24, N'o psach' UNION ALL 
SELECT 23, 2, 25, N'psy' UNION ALL 
SELECT 24, 3, 17, N'do Włoch' UNION ALL 
SELECT 25, 3, 18, N'we Włoszech' UNION ALL 
SELECT 26, 3, 19, N'Włochy' UNION ALL 
SELECT 27, 3, 20, N'Włoch' UNION ALL 
SELECT 28, 3, 21, N'Włochom' UNION ALL 
SELECT 29, 3, 22, N'Włochy' UNION ALL 
SELECT 30, 3, 23, N'z Włochami' UNION ALL 
SELECT 31, 3, 24, N'Włoszech' UNION ALL 
SELECT 32, 3, 25, N'Włochy' UNION ALL 
SELECT 33, 4, 10, N'Hiszpania' UNION ALL 
SELECT 34, 4, 11, N'Hiszpanii' UNION ALL 
SELECT 35, 4, 12, N'Hiszpanii' UNION ALL 
SELECT 36, 4, 13, N'Hiszpanię' UNION ALL 
SELECT 37, 4, 14, N'z Hiszpanią' UNION ALL 
SELECT 38, 4, 15, N'Hiszpanii' UNION ALL 
SELECT 39, 4, 16, N'Hiszpanio' UNION ALL 
SELECT 40, 4, 17, N'do Hiszpanii' UNION ALL 
SELECT 41, 4, 18, N'w Hiszpanii' UNION ALL 
SELECT 42, 5, 10, N'Francja' UNION ALL 
SELECT 43, 5, 11, N'Francji' UNION ALL 
SELECT 44, 5, 12, N'Francji' UNION ALL 
SELECT 45, 5, 13, N'Francję' UNION ALL 
SELECT 46, 5, 14, N'z Francją' UNION ALL 
SELECT 47, 5, 15, N'Francji' UNION ALL 
SELECT 48, 5, 16, N'Francjo' UNION ALL 
SELECT 49, 5, 17, N'do Francji' UNION ALL 
SELECT 50, 5, 18, N'we Francji' UNION ALL 
SELECT 51, 6, 17, N'do Niemiec' UNION ALL 
SELECT 52, 6, 18, N'w Niemczech' UNION ALL 
SELECT 53, 6, 19, N'Niemcy' UNION ALL 
SELECT 54, 6, 20, N'Niemiec' UNION ALL 
SELECT 55, 6, 21, N'Niemcom' UNION ALL 
SELECT 56, 6, 22, N'Niemcy' UNION ALL 
SELECT 57, 6, 23, N'z Niemcami' UNION ALL 
SELECT 58, 6, 24, N'Niemczech' UNION ALL 
SELECT 59, 6, 25, N'Niemcy' UNION ALL 
SELECT 60, 7, 10, N'Anglia' UNION ALL 
SELECT 61, 7, 11, N'Anglii' UNION ALL 
SELECT 62, 7, 12, N'Anglii' UNION ALL 
SELECT 63, 7, 13, N'Anglię' UNION ALL 
SELECT 64, 7, 14, N'z Anglią' UNION ALL 
SELECT 65, 7, 15, N'Anglii' UNION ALL 
SELECT 66, 7, 16, N'Anglio' UNION ALL 
SELECT 67, 7, 17, N'do Anglii' UNION ALL 
SELECT 68, 7, 18, N'w Anglii' UNION ALL 
SELECT 69, 8, 10, N'Rosja' UNION ALL 
SELECT 70, 8, 11, N'Rosji' UNION ALL 
SELECT 71, 8, 12, N'Rosji' UNION ALL 
SELECT 72, 8, 13, N'Rosję' UNION ALL 
SELECT 73, 8, 14, N'z Rosją' UNION ALL 
SELECT 74, 8, 15, N'Rosji' UNION ALL 
SELECT 75, 8, 16, N'Rosjo' UNION ALL 
SELECT 76, 8, 17, N'do Rosji' UNION ALL 
SELECT 77, 8, 18, N'w Rosji' UNION ALL 
SELECT 78, 9, 10, N'Albania' UNION ALL 
SELECT 79, 9, 11, N'Albanii' UNION ALL 
SELECT 80, 9, 12, N'Albanii' UNION ALL 
SELECT 81, 9, 13, N'Albanię' UNION ALL 
SELECT 82, 9, 14, N'z Albanią' UNION ALL 
SELECT 83, 9, 15, N'Albanii' UNION ALL 
SELECT 84, 9, 16, N'Albanio' UNION ALL 
SELECT 85, 9, 17, N'do Albanii' UNION ALL 
SELECT 86, 9, 18, N'w Albanii' UNION ALL 
SELECT 87, 10, 10, N'Andora' UNION ALL 
SELECT 88, 10, 11, N'Andory' UNION ALL 
SELECT 89, 10, 12, N'Andorze' UNION ALL 
SELECT 90, 10, 13, N'Andorę' UNION ALL 
SELECT 91, 10, 14, N'z Andorą' UNION ALL 
SELECT 92, 10, 15, N'Andorze' UNION ALL 
SELECT 93, 10, 16, N'Andoro' UNION ALL 
SELECT 94, 10, 17, N'do Andory' UNION ALL 
SELECT 95, 10, 18, N'w Andorze' UNION ALL 
SELECT 96, 11, 10, N'Armenia' UNION ALL 
SELECT 97, 11, 11, N'Armenii' UNION ALL 
SELECT 98, 11, 12, N'Armenii' UNION ALL 
SELECT 99, 11, 13, N'Armenię' UNION ALL 
SELECT 100, 11, 14, N'z Armenią' UNION ALL 
SELECT 101, 11, 15, N'Armenii' UNION ALL 
SELECT 102, 11, 16, N'Armenio' UNION ALL 
SELECT 103, 11, 17, N'do Armenii' UNION ALL 
SELECT 104, 11, 18, N'w Armenii' UNION ALL 
SELECT 105, 12, 10, N'Austria' UNION ALL 
SELECT 106, 12, 11, N'Austrii' UNION ALL 
SELECT 107, 12, 12, N'Austrii' UNION ALL 
SELECT 108, 12, 13, N'Austrię' UNION ALL 
SELECT 109, 12, 14, N'z Austrią' UNION ALL 
SELECT 110, 12, 15, N'Austrii' UNION ALL 
SELECT 111, 12, 16, N'Austrio' UNION ALL 
SELECT 112, 12, 17, N'do Austrii' UNION ALL 
SELECT 113, 12, 18, N'w Austrii' UNION ALL 
SELECT 114, 13, 10, N'Azerbejdżan' UNION ALL 
SELECT 115, 13, 11, N'Azerbejdżanu' UNION ALL 
SELECT 116, 13, 12, N'Azerbejdżanowi' UNION ALL 
SELECT 117, 13, 13, N'Azerbejdżan' UNION ALL 
SELECT 118, 13, 14, N'z Azerbejdżanem' UNION ALL 
SELECT 119, 13, 15, N'Azerbejdżanie' UNION ALL 
SELECT 120, 13, 16, N'Azerbejdżanie' UNION ALL 
SELECT 121, 13, 17, N'do Azerbejdżanu' UNION ALL 
SELECT 122, 13, 18, N'w Azerbejdżanie' UNION ALL 
SELECT 123, 14, 10, N'Białoruś' UNION ALL 
SELECT 124, 14, 11, N'Białorusi' UNION ALL 
SELECT 125, 14, 12, N'Białorusi' UNION ALL 
SELECT 126, 14, 13, N'Białoruś' UNION ALL 
SELECT 127, 14, 14, N'z Białorusią' UNION ALL 
SELECT 128, 14, 15, N'Białorusi' UNION ALL 
SELECT 129, 14, 16, N'Białoruś' UNION ALL 
SELECT 130, 14, 17, N'na Białoruś' UNION ALL 
SELECT 131, 14, 18, N'na Białorusi' UNION ALL 
SELECT 132, 15, 10, N'Belgia' UNION ALL 
SELECT 133, 15, 11, N'Belgii' UNION ALL 
SELECT 134, 15, 12, N'Belgii' UNION ALL 
SELECT 135, 15, 13, N'Belgię' UNION ALL 
SELECT 136, 15, 14, N'z Belgią' UNION ALL 
SELECT 137, 15, 15, N'Belgii' UNION ALL 
SELECT 138, 15, 16, N'Belgio' UNION ALL 
SELECT 139, 15, 17, N'do Belgii' UNION ALL 
SELECT 140, 15, 18, N'w Belgii' UNION ALL 
SELECT 141, 16, 10, N'Bośnia i Hercegowina' UNION ALL 
SELECT 142, 16, 11, N'Bośni i Hercegowiny' UNION ALL 
SELECT 143, 16, 12, N'Bośni i Hercegowinie' UNION ALL 
SELECT 144, 16, 13, N'Bośnię i Hercegowinę' UNION ALL 
SELECT 145, 16, 14, N'z Bośnią i Hercegowiną' UNION ALL 
SELECT 146, 16, 15, N'Bośni i Hercegowinie' UNION ALL 
SELECT 147, 16, 16, N'Bośnio i Hercegowino' UNION ALL 
SELECT 148, 16, 17, N'do Bośni i Hercegowiny' UNION ALL 
SELECT 149, 16, 18, N'w Bośni i Hercegowinie' UNION ALL 
SELECT 150, 17, 10, N'Bułgaria' UNION ALL 
SELECT 151, 17, 11, N'Bułgarii' UNION ALL 
SELECT 152, 17, 12, N'Bułgarii' UNION ALL 
SELECT 153, 17, 13, N'Bułgarię' UNION ALL 
SELECT 154, 17, 14, N'z Bułgarią' UNION ALL 
SELECT 155, 17, 15, N'Bułgarii' UNION ALL 
SELECT 156, 17, 16, N'Bułgario' UNION ALL 
SELECT 157, 17, 17, N'do Bułgarii' UNION ALL 
SELECT 158, 17, 18, N'w Bułgarii' UNION ALL 
SELECT 159, 18, 10, N'Chorwacja' UNION ALL 
SELECT 160, 18, 11, N'Chorwacji' UNION ALL 
SELECT 161, 18, 12, N'Chorwacji' UNION ALL 
SELECT 162, 18, 13, N'Chorwację' UNION ALL 
SELECT 163, 18, 14, N'z Chorwacją' UNION ALL 
SELECT 164, 18, 15, N'Chorwacji' UNION ALL 
SELECT 165, 18, 16, N'Chorwacjo' UNION ALL 
SELECT 166, 18, 17, N'do Chorwacji' UNION ALL 
SELECT 167, 18, 18, N'w Chorwacji' UNION ALL 
SELECT 168, 19, 10, N'Cypr' UNION ALL 
SELECT 169, 19, 11, N'Cypru' UNION ALL 
SELECT 170, 19, 12, N'Cyprowi' UNION ALL 
SELECT 171, 19, 13, N'Cypr' UNION ALL 
SELECT 172, 19, 14, N'z Cyprem' UNION ALL 
SELECT 173, 19, 15, N'Cyprze' UNION ALL 
SELECT 174, 19, 16, N'Cyprze' UNION ALL 
SELECT 175, 19, 17, N'na Cypr' UNION ALL 
SELECT 176, 19, 18, N'na Cyprze' UNION ALL 
SELECT 177, 20, 17, N'do Czech' UNION ALL 
SELECT 178, 20, 18, N'w Czechach' UNION ALL 
SELECT 179, 20, 19, N'Czechy' UNION ALL 
SELECT 180, 20, 20, N'Czech' UNION ALL 
SELECT 181, 20, 21, N'Czechom' UNION ALL 
SELECT 182, 20, 22, N'Czechy' UNION ALL 
SELECT 183, 20, 23, N'z Czechami' UNION ALL 
SELECT 184, 20, 24, N'Czechach' UNION ALL 
SELECT 185, 20, 25, N'Czechy' UNION ALL 
SELECT 186, 21, 10, N'Dania' UNION ALL 
SELECT 187, 21, 11, N'Danii' UNION ALL 
SELECT 188, 21, 12, N'Danii' UNION ALL 
SELECT 189, 21, 13, N'Danię' UNION ALL 
SELECT 190, 21, 14, N'z Danią' UNION ALL 
SELECT 191, 21, 15, N'Danii' UNION ALL 
SELECT 192, 21, 16, N'Danio' UNION ALL 
SELECT 193, 21, 17, N'do Danii' UNION ALL 
SELECT 194, 21, 18, N'w Danii' UNION ALL 
SELECT 195, 22, 10, N'Estonia' UNION ALL 
SELECT 196, 22, 11, N'Estonii' UNION ALL 
SELECT 197, 22, 12, N'Estonii' UNION ALL 
SELECT 198, 22, 13, N'Estonię' UNION ALL 
SELECT 199, 22, 14, N'z Estonią' UNION ALL 
SELECT 200, 22, 15, N'Estonii' UNION ALL 
SELECT 201, 22, 16, N'Estonio' UNION ALL 
SELECT 202, 22, 17, N'do Estonii' UNION ALL 
SELECT 203, 22, 18, N'w Estonii' UNION ALL 
SELECT 204, 23, 10, N'Finlandia' UNION ALL 
SELECT 205, 23, 11, N'Finlandii' UNION ALL 
SELECT 206, 23, 12, N'Finlandii' UNION ALL 
SELECT 207, 23, 13, N'Finlandię' UNION ALL 
SELECT 208, 23, 14, N'z Finlandią' UNION ALL 
SELECT 209, 23, 15, N'Finlandii' UNION ALL 
SELECT 210, 23, 16, N'Finlandio' UNION ALL 
SELECT 211, 23, 17, N'do Finlandii' UNION ALL 
SELECT 212, 23, 18, N'w Finlandii' UNION ALL 
SELECT 213, 24, 10, N'Gruzja' UNION ALL 
SELECT 214, 24, 11, N'Gruzji' UNION ALL 
SELECT 215, 24, 12, N'Gruzji' UNION ALL 
SELECT 216, 24, 13, N'Gruzję' UNION ALL 
SELECT 217, 24, 14, N'z Gruzją' UNION ALL 
SELECT 218, 24, 15, N'Gruzji' UNION ALL 
SELECT 219, 24, 16, N'Gruzjo' UNION ALL 
SELECT 220, 24, 17, N'do Gruzji' UNION ALL 
SELECT 221, 24, 18, N'w Gruzji' UNION ALL 
SELECT 222, 25, 10, N'Grecja' UNION ALL 
SELECT 223, 25, 11, N'Grecji' UNION ALL 
SELECT 224, 25, 12, N'Grecji' UNION ALL 
SELECT 225, 25, 13, N'Grecję' UNION ALL 
SELECT 226, 25, 14, N'z Grecją' UNION ALL 
SELECT 227, 25, 15, N'Grecji' UNION ALL 
SELECT 228, 25, 16, N'Grecjo' UNION ALL 
SELECT 229, 25, 17, N'do Grecji' UNION ALL 
SELECT 230, 25, 18, N'w Grecji' UNION ALL 
SELECT 231, 26, 17, N'na Węgry' UNION ALL 
SELECT 232, 26, 18, N'na Węgrzech' UNION ALL 
SELECT 233, 26, 19, N'Węgry' UNION ALL 
SELECT 234, 26, 20, N'Węgier' UNION ALL 
SELECT 235, 26, 21, N'Węgrom' UNION ALL 
SELECT 236, 26, 22, N'Węgry' UNION ALL 
SELECT 237, 26, 23, N'z Węgrami' UNION ALL 
SELECT 238, 26, 24, N'Węgrach' UNION ALL 
SELECT 239, 26, 25, N'Węgry' UNION ALL 
SELECT 240, 27, 10, N'Islandia' UNION ALL 
SELECT 241, 27, 11, N'Islandii' UNION ALL 
SELECT 242, 27, 12, N'Islandii' UNION ALL 
SELECT 243, 27, 13, N'Islandię' UNION ALL 
SELECT 244, 27, 14, N'z Islandią' UNION ALL 
SELECT 245, 27, 15, N'Islandii' UNION ALL 
SELECT 246, 27, 16, N'Islandio' UNION ALL 
SELECT 247, 27, 17, N'do Islandii' UNION ALL 
SELECT 248, 27, 18, N'w Islandii' UNION ALL 
SELECT 249, 28, 10, N'Irlandia' UNION ALL 
SELECT 250, 28, 11, N'Irlandii' UNION ALL 
SELECT 251, 28, 12, N'Irlandii' UNION ALL 
SELECT 252, 28, 13, N'Irlandię' UNION ALL 
SELECT 253, 28, 14, N'z Irlandią' UNION ALL 
SELECT 254, 28, 15, N'Irlandii' UNION ALL 
SELECT 255, 28, 16, N'Irlandio' UNION ALL 
SELECT 256, 28, 17, N'do Irlandii' UNION ALL 
SELECT 257, 28, 18, N'w Irlandii' UNION ALL 
SELECT 258, 29, 10, N'Kazachstan' UNION ALL 
SELECT 259, 29, 11, N'Kazachstanu' UNION ALL 
SELECT 260, 29, 12, N'Kazachstanowi' UNION ALL 
SELECT 261, 29, 13, N'Kazachstan' UNION ALL 
SELECT 262, 29, 14, N'z Kazachstanem' UNION ALL 
SELECT 263, 29, 15, N'Kazachstanie' UNION ALL 
SELECT 264, 29, 16, N'Kazachstanie' UNION ALL 
SELECT 265, 29, 17, N'do Kazachstanu' UNION ALL 
SELECT 266, 29, 18, N'w Kazachstanie' UNION ALL 
SELECT 267, 30, 10, N'Łotwa' UNION ALL 
SELECT 268, 30, 11, N'Łotwy' UNION ALL 
SELECT 269, 30, 12, N'Łotwie' UNION ALL 
SELECT 270, 30, 13, N'Łotwę' UNION ALL 
SELECT 271, 30, 14, N'z Łotwą' UNION ALL 
SELECT 272, 30, 15, N'Łotwie' UNION ALL 
SELECT 273, 30, 16, N'Łotwo' UNION ALL 
SELECT 274, 30, 17, N'na Łotwę' UNION ALL 
SELECT 275, 30, 18, N'na Łotwie' UNION ALL 
SELECT 276, 31, 10, N'Liechtenstein' UNION ALL 
SELECT 277, 31, 11, N'Liechtensteinu' UNION ALL 
SELECT 278, 31, 12, N'Liechtensteinowi' UNION ALL 
SELECT 279, 31, 13, N'Liechtenstein' UNION ALL 
SELECT 280, 31, 14, N'z Liechtensteinem' UNION ALL 
SELECT 281, 31, 15, N'Liechtensteinie' UNION ALL 
SELECT 282, 31, 16, N'Liechtensteinie' UNION ALL 
SELECT 283, 31, 17, N'do Liechtensteinu' UNION ALL 
SELECT 284, 31, 18, N'w Liechtensteinie' UNION ALL 
SELECT 285, 32, 10, N'Litwa' UNION ALL 
SELECT 286, 32, 11, N'Litwy' UNION ALL 
SELECT 287, 32, 12, N'Litwie' UNION ALL 
SELECT 288, 32, 13, N'Litwę' UNION ALL 
SELECT 289, 32, 14, N'z Litwą' UNION ALL 
SELECT 290, 32, 15, N'Litwie' UNION ALL 
SELECT 291, 32, 16, N'Litwo' UNION ALL 
SELECT 292, 32, 17, N'na Litwę' UNION ALL 
SELECT 293, 32, 18, N'na Litwie' UNION ALL 
SELECT 294, 33, 10, N'Luksemburg' UNION ALL 
SELECT 295, 33, 11, N'Luksemburga' UNION ALL 
SELECT 296, 33, 12, N'Luksemburgowi' UNION ALL 
SELECT 297, 33, 13, N'Luksemburg' UNION ALL 
SELECT 298, 33, 14, N'z Luksemburgiem' UNION ALL 
SELECT 299, 33, 15, N'Luksemburgu' UNION ALL 
SELECT 300, 33, 16, N'Luksemburgu' UNION ALL 
SELECT 301, 33, 17, N'do Luksemburga' UNION ALL 
SELECT 302, 33, 18, N'w Luksemburgu' UNION ALL 
SELECT 303, 34, 10, N'Macedonia' UNION ALL 
SELECT 304, 34, 11, N'Macedonii' UNION ALL 
SELECT 305, 34, 12, N'Macedonii' UNION ALL 
SELECT 306, 34, 13, N'Macedonię' UNION ALL 
SELECT 307, 34, 14, N'z Macedonią' UNION ALL 
SELECT 308, 34, 15, N'Macedonii' UNION ALL 
SELECT 309, 34, 16, N'Macedonio' UNION ALL 
SELECT 310, 34, 17, N'do Macedonii' UNION ALL 
SELECT 311, 34, 18, N'w Macedonii' UNION ALL 
SELECT 312, 35, 10, N'Malta' UNION ALL 
SELECT 313, 35, 11, N'Malty' UNION ALL 
SELECT 314, 35, 12, N'Malcie' UNION ALL 
SELECT 315, 35, 13, N'Maltę' UNION ALL 
SELECT 316, 35, 14, N'z Maltą' UNION ALL 
SELECT 317, 35, 15, N'Malcie' UNION ALL 
SELECT 318, 35, 16, N'Malto' UNION ALL 
SELECT 319, 35, 17, N'na Maltę' UNION ALL 
SELECT 320, 35, 18, N'na Malcie' UNION ALL 
SELECT 321, 36, 10, N'Mołdawia' UNION ALL 
SELECT 322, 36, 11, N'Mołdawii' UNION ALL 
SELECT 323, 36, 12, N'Mołdawii' UNION ALL 
SELECT 324, 36, 13, N'Mołdawię' UNION ALL 
SELECT 325, 36, 14, N'z Mołdawią' UNION ALL 
SELECT 326, 36, 15, N'Mołdawii' UNION ALL 
SELECT 327, 36, 16, N'Mołdawio' UNION ALL 
SELECT 328, 36, 17, N'do Mołdawii' UNION ALL 
SELECT 329, 36, 18, N'w Mołdawii' UNION ALL 
SELECT 330, 37, 10, N'Monako' UNION ALL 
SELECT 331, 37, 11, N'Monako' UNION ALL 
SELECT 332, 37, 12, N'Monako' UNION ALL 
SELECT 333, 37, 13, N'Monako' UNION ALL 
SELECT 334, 37, 14, N'z Monako' UNION ALL 
SELECT 335, 37, 15, N'Monako' UNION ALL 
SELECT 336, 37, 16, N'Monako' UNION ALL 
SELECT 337, 37, 17, N'do Monako' UNION ALL 
SELECT 338, 37, 18, N'w Monako' UNION ALL 
SELECT 339, 38, 10, N'Czarnogóra' UNION ALL 
SELECT 340, 38, 11, N'Czarnogóry' UNION ALL 
SELECT 341, 38, 12, N'Czarnogórze' UNION ALL 
SELECT 342, 38, 13, N'Czarnogórę' UNION ALL 
SELECT 343, 38, 14, N'z Czarnogórą' UNION ALL 
SELECT 344, 38, 15, N'Czarnogórze' UNION ALL 
SELECT 345, 38, 16, N'Czarnogóro' UNION ALL 
SELECT 346, 38, 17, N'do Czarnogóry' UNION ALL 
SELECT 347, 38, 18, N'w Czarnogórze' UNION ALL 
SELECT 348, 39, 10, N'Holandia' UNION ALL 
SELECT 349, 39, 11, N'Holandii' UNION ALL 
SELECT 350, 39, 12, N'Holandii' UNION ALL 
SELECT 351, 39, 13, N'Holandię' UNION ALL 
SELECT 352, 39, 14, N'z Holandią' UNION ALL 
SELECT 353, 39, 15, N'Holandii' UNION ALL 
SELECT 354, 39, 16, N'Holandio' UNION ALL 
SELECT 355, 39, 17, N'do Holandii' UNION ALL 
SELECT 356, 39, 18, N'w Holandii' UNION ALL 
SELECT 357, 40, 10, N'Norwegia' UNION ALL 
SELECT 358, 40, 11, N'Norwegii' UNION ALL 
SELECT 359, 40, 12, N'Norwegii' UNION ALL 
SELECT 360, 40, 13, N'Norwegię' UNION ALL 
SELECT 361, 40, 14, N'z Norwegią' UNION ALL 
SELECT 362, 40, 15, N'Norwegii' UNION ALL 
SELECT 363, 40, 16, N'Norwegio' UNION ALL 
SELECT 364, 40, 17, N'do Norwegii' UNION ALL 
SELECT 365, 40, 18, N'w Norwegii' UNION ALL 
SELECT 366, 41, 10, N'Portugalia' UNION ALL 
SELECT 367, 41, 11, N'Portugalii' UNION ALL 
SELECT 368, 41, 12, N'Portugalii' UNION ALL 
SELECT 369, 41, 13, N'Portugalię' UNION ALL 
SELECT 370, 41, 14, N'z Portugalią' UNION ALL 
SELECT 371, 41, 15, N'Portugalii' UNION ALL 
SELECT 372, 41, 16, N'Portugalio' UNION ALL 
SELECT 373, 41, 17, N'do Portugalii' UNION ALL 
SELECT 374, 41, 18, N'w Portugalii' UNION ALL 
SELECT 375, 42, 10, N'Rumunia' UNION ALL 
SELECT 376, 42, 11, N'Rumunii' UNION ALL 
SELECT 377, 42, 12, N'Rumunii' UNION ALL 
SELECT 378, 42, 13, N'Rumunię' UNION ALL 
SELECT 379, 42, 14, N'z Rumunią' UNION ALL 
SELECT 380, 42, 15, N'Rumunii' UNION ALL 
SELECT 381, 42, 16, N'Rumunio' UNION ALL 
SELECT 382, 42, 17, N'do Rumunii' UNION ALL 
SELECT 383, 42, 18, N'w Rumunii' UNION ALL 
SELECT 384, 43, 10, N'San Marino' UNION ALL 
SELECT 385, 43, 11, N'San Marino' UNION ALL 
SELECT 386, 43, 12, N'San Marino' UNION ALL 
SELECT 387, 43, 13, N'San Marino' UNION ALL 
SELECT 388, 43, 14, N'z San Marino' UNION ALL 
SELECT 389, 43, 15, N'San Marino' UNION ALL 
SELECT 390, 43, 16, N'San Marino' UNION ALL 
SELECT 391, 43, 17, N'do San Marino' UNION ALL 
SELECT 392, 43, 18, N'w San Marino' UNION ALL 
SELECT 393, 44, 10, N'Serbia' UNION ALL 
SELECT 394, 44, 11, N'Serbii' UNION ALL 
SELECT 395, 44, 12, N'Serbii' UNION ALL 
SELECT 396, 44, 13, N'Serbię' UNION ALL 
SELECT 397, 44, 14, N'z Serbią' UNION ALL 
SELECT 398, 44, 15, N'Serbii' UNION ALL 
SELECT 399, 44, 16, N'Serbio' UNION ALL 
SELECT 400, 44, 17, N'do Serbii' UNION ALL 
SELECT 401, 44, 18, N'w Serbii' UNION ALL 
SELECT 402, 45, 10, N'Słowacja' UNION ALL 
SELECT 403, 45, 11, N'Słowacji' UNION ALL 
SELECT 404, 45, 12, N'Słowacji' UNION ALL 
SELECT 405, 45, 13, N'Słowację' UNION ALL 
SELECT 406, 45, 14, N'z Słowacją' UNION ALL 
SELECT 407, 45, 15, N'Słowacji' UNION ALL 
SELECT 408, 45, 16, N'Słowacjo' UNION ALL 
SELECT 409, 45, 17, N'na Słowację' UNION ALL 
SELECT 410, 45, 18, N'na Słowację' UNION ALL 
SELECT 411, 46, 10, N'Słowenia' UNION ALL 
SELECT 412, 46, 11, N'Słowenii' UNION ALL 
SELECT 413, 46, 12, N'Słowenii' UNION ALL 
SELECT 414, 46, 13, N'Słowenię' UNION ALL 
SELECT 415, 46, 14, N'z Słowenią' UNION ALL 
SELECT 416, 46, 15, N'Słowenii' UNION ALL 
SELECT 417, 46, 16, N'Słowenio' UNION ALL 
SELECT 418, 46, 17, N'do Słowenii' UNION ALL 
SELECT 419, 46, 18, N'w Słowenii' UNION ALL 
SELECT 420, 47, 10, N'Szwecja' UNION ALL 
SELECT 421, 47, 11, N'Szwecji' UNION ALL 
SELECT 422, 47, 12, N'Szwecji' UNION ALL 
SELECT 423, 47, 13, N'Szwecję' UNION ALL 
SELECT 424, 47, 14, N'z Szwecją' UNION ALL 
SELECT 425, 47, 15, N'Szwecji' UNION ALL 
SELECT 426, 47, 16, N'Szwecjo' UNION ALL 
SELECT 427, 47, 17, N'do Szwecji' UNION ALL 
SELECT 428, 47, 18, N'w Szwecji' UNION ALL 
SELECT 429, 48, 10, N'Szwajcaria' UNION ALL 
SELECT 430, 48, 11, N'Szwajcarii' UNION ALL 
SELECT 431, 48, 12, N'Szwajcarii' UNION ALL 
SELECT 432, 48, 13, N'Szwajcarię' UNION ALL 
SELECT 433, 48, 14, N'z Szwajcarią' UNION ALL 
SELECT 434, 48, 15, N'Szwajcarii' UNION ALL 
SELECT 435, 48, 16, N'Szwajcario' UNION ALL 
SELECT 436, 48, 17, N'do Szwajcarii' UNION ALL 
SELECT 437, 48, 18, N'w Szwajcarii' UNION ALL 
SELECT 438, 49, 10, N'Turcja' UNION ALL 
SELECT 439, 49, 11, N'Turcji' UNION ALL 
SELECT 440, 49, 12, N'Turcji' UNION ALL 
SELECT 441, 49, 13, N'Turcję' UNION ALL 
SELECT 442, 49, 14, N'z Turcją' UNION ALL 
SELECT 443, 49, 15, N'Turcji' UNION ALL 
SELECT 444, 49, 16, N'Turcjo' UNION ALL 
SELECT 445, 49, 17, N'do Turcji' UNION ALL 
SELECT 446, 49, 18, N'w Turcji' UNION ALL 
SELECT 447, 50, 10, N'Ukraina' UNION ALL 
SELECT 448, 50, 11, N'Ukrainy' UNION ALL 
SELECT 449, 50, 12, N'Ukrainie' UNION ALL 
SELECT 450, 50, 13, N'Ukrainę' UNION ALL 
SELECT 451, 50, 14, N'z Ukrainą' UNION ALL 
SELECT 452, 50, 15, N'Ukrainie' UNION ALL 
SELECT 453, 50, 16, N'Ukraino' UNION ALL 
SELECT 454, 50, 17, N'na Ukrainę' UNION ALL 
SELECT 455, 50, 18, N'na Ukrainie' UNION ALL 
SELECT 456, 51, 10, N'Wielka Brytania' UNION ALL 
SELECT 457, 51, 11, N'Wielkiej Brytanii' UNION ALL 
SELECT 458, 51, 12, N'Wielkiej Brytanii' UNION ALL 
SELECT 459, 51, 13, N'Wielką Brytanię' UNION ALL 
SELECT 460, 51, 14, N'z Wielką Brytanią' UNION ALL 
SELECT 461, 51, 15, N'Wielkiej Brytanii' UNION ALL 
SELECT 462, 51, 16, N'Wielka Brytanio' UNION ALL 
SELECT 463, 51, 17, N'do Wielkiej Brytanii' UNION ALL 
SELECT 464, 51, 18, N'w Wielkiej Brytanii' UNION ALL 
SELECT 465, 52, 10, N'Watykan' UNION ALL 
SELECT 466, 52, 11, N'Watykanu' UNION ALL 
SELECT 467, 52, 12, N'Watykanowi' UNION ALL 
SELECT 468, 52, 13, N'Watykan' UNION ALL 
SELECT 469, 52, 14, N'z Watykanem' UNION ALL 
SELECT 470, 52, 15, N'Watykanie' UNION ALL 
SELECT 471, 52, 16, N'Watykanie' UNION ALL 
SELECT 472, 52, 17, N'do Watykanu' UNION ALL 
SELECT 473, 52, 18, N'w Watykanie' UNION ALL 
SELECT 474, 53, 10, N'Szkocja' UNION ALL 
SELECT 475, 53, 11, N'Szkocji' UNION ALL 
SELECT 476, 53, 12, N'Szkocji' UNION ALL 
SELECT 477, 53, 13, N'Szkocję' UNION ALL 
SELECT 478, 53, 14, N'z Szkocją' UNION ALL 
SELECT 479, 53, 15, N'Szkocji' UNION ALL 
SELECT 480, 53, 16, N'Szkocjo' UNION ALL 
SELECT 481, 53, 17, N'do Szkocji' UNION ALL 
SELECT 482, 53, 18, N'w Szkocji' UNION ALL 
SELECT 483, 54, 10, N'Brazylia' UNION ALL 
SELECT 484, 54, 11, N'Brazylii' UNION ALL 
SELECT 485, 54, 12, N'Brazylii' UNION ALL 
SELECT 486, 54, 13, N'Brazylię' UNION ALL 
SELECT 487, 54, 14, N'z Brazylią' UNION ALL 
SELECT 488, 54, 15, N'Brazylii' UNION ALL 
SELECT 489, 54, 16, N'Brazylio' UNION ALL 
SELECT 490, 54, 17, N'do Brazylii' UNION ALL 
SELECT 491, 54, 18, N'w Brazylii' UNION ALL 
SELECT 492, 55, 10, N'Argentyna' UNION ALL 
SELECT 493, 55, 11, N'Argentyny' UNION ALL 
SELECT 494, 55, 12, N'Argentynie' UNION ALL 
SELECT 495, 55, 13, N'Argentynę' UNION ALL 
SELECT 496, 55, 14, N'z Argentyną' UNION ALL 
SELECT 497, 55, 15, N'Argentynie' UNION ALL 
SELECT 498, 55, 16, N'Argentyno' UNION ALL 
SELECT 499, 55, 17, N'do Argentyny' UNION ALL 
SELECT 500, 55, 18, N'w Argentynie' UNION ALL 
SELECT 501, 56, 10, N'Ekwador' UNION ALL 
SELECT 502, 56, 11, N'Ekwadoru' UNION ALL 
SELECT 503, 56, 12, N'Ekwadorowi' UNION ALL 
SELECT 504, 56, 13, N'Ekwador' UNION ALL 
SELECT 505, 56, 14, N'z Ekwadorem' UNION ALL 
SELECT 506, 56, 15, N'Ekwadorze' UNION ALL 
SELECT 507, 56, 16, N'Ekwadorze' UNION ALL 
SELECT 508, 56, 17, N'do Ekwadoru' UNION ALL 
SELECT 509, 56, 18, N'w Ekwadorze' UNION ALL 
SELECT 510, 57, 10, N'Paragwaj' UNION ALL 
SELECT 511, 57, 11, N'Paragwaju' UNION ALL 
SELECT 512, 57, 12, N'Paragwajowi' UNION ALL 
SELECT 513, 57, 13, N'Paragwaj' UNION ALL 
SELECT 514, 57, 14, N'z Paragwajem' UNION ALL 
SELECT 515, 57, 15, N'Paragwaju' UNION ALL 
SELECT 516, 57, 16, N'Paragwaju' UNION ALL 
SELECT 517, 57, 17, N'do Paragwaju' UNION ALL 
SELECT 518, 57, 18, N'w Paragwaju' UNION ALL 
SELECT 519, 58, 10, N'Urugwaj' UNION ALL 
SELECT 520, 58, 11, N'Urugwaju' UNION ALL 
SELECT 521, 58, 12, N'Urugwajowi' UNION ALL 
SELECT 522, 58, 13, N'Urugwaj' UNION ALL 
SELECT 523, 58, 14, N'z Urugwajem' UNION ALL 
SELECT 524, 58, 15, N'Urugwaju' UNION ALL 
SELECT 525, 58, 16, N'Urugwaju' UNION ALL 
SELECT 526, 58, 17, N'do Urugwaju' UNION ALL 
SELECT 527, 58, 18, N'w Urugwaju' UNION ALL 
SELECT 528, 59, 10, N'Wenezuela' UNION ALL 
SELECT 529, 59, 11, N'Wenezueli' UNION ALL 
SELECT 530, 59, 12, N'Wenezueli' UNION ALL 
SELECT 531, 59, 13, N'Wenezuelę' UNION ALL 
SELECT 532, 59, 14, N'z Wenezuelą' UNION ALL 
SELECT 533, 59, 15, N'Wenezueli' UNION ALL 
SELECT 534, 59, 16, N'Wenezuelo' UNION ALL 
SELECT 535, 59, 17, N'do Wenezueli' UNION ALL 
SELECT 536, 59, 18, N'w Wenezueli' UNION ALL 
SELECT 537, 60, 10, N'Kolumbia' UNION ALL 
SELECT 538, 60, 11, N'Kolumbii' UNION ALL 
SELECT 539, 60, 12, N'Kolumbii' UNION ALL 
SELECT 540, 60, 13, N'Kolumbię' UNION ALL 
SELECT 541, 60, 14, N'z Kolumbią' UNION ALL 
SELECT 542, 60, 15, N'Kolumbii' UNION ALL 
SELECT 543, 60, 16, N'Kolumbio' UNION ALL 
SELECT 544, 60, 17, N'do Kolumbii' UNION ALL 
SELECT 545, 60, 18, N'w Kolumbii' UNION ALL 
SELECT 546, 61, 10, N'Chile' UNION ALL 
SELECT 547, 61, 11, N'Chile' UNION ALL 
SELECT 548, 61, 12, N'Chile' UNION ALL 
SELECT 549, 61, 13, N'Chile' UNION ALL 
SELECT 550, 61, 14, N'z Chile' UNION ALL 
SELECT 551, 61, 15, N'Chile' UNION ALL 
SELECT 552, 61, 16, N'Chile' UNION ALL 
SELECT 553, 61, 17, N'do Chile' UNION ALL 
SELECT 554, 61, 18, N'w Chile' UNION ALL 
SELECT 555, 62, 10, N'Boliwia' UNION ALL 
SELECT 556, 62, 11, N'Boliwii' UNION ALL 
SELECT 557, 62, 12, N'Boliwii' UNION ALL 
SELECT 558, 62, 13, N'Boliwię' UNION ALL 
SELECT 559, 62, 14, N'z Boliwią' UNION ALL 
SELECT 560, 62, 15, N'Boliwii' UNION ALL 
SELECT 561, 62, 16, N'Boliwio' UNION ALL 
SELECT 562, 62, 17, N'do Boliwii' UNION ALL 
SELECT 563, 62, 18, N'w Boliwii' UNION ALL 
SELECT 564, 63, 10, N'Peru' UNION ALL 
SELECT 565, 63, 11, N'Peru' UNION ALL 
SELECT 566, 63, 12, N'Peru' UNION ALL 
SELECT 567, 63, 13, N'Peru' UNION ALL 
SELECT 568, 63, 14, N'z Peru' UNION ALL 
SELECT 569, 63, 15, N'Peru' UNION ALL 
SELECT 570, 63, 16, N'Peru' UNION ALL 
SELECT 571, 63, 17, N'do Peru' UNION ALL 
SELECT 572, 63, 18, N'w Peru' UNION ALL 
SELECT 573, 64, 17, N'do Chin' UNION ALL 
SELECT 574, 64, 18, N'w Chinach' UNION ALL 
SELECT 575, 64, 19, N'Chiny' UNION ALL 
SELECT 576, 64, 20, N'Chin' UNION ALL 
SELECT 577, 64, 21, N'Chinom' UNION ALL 
SELECT 578, 64, 22, N'Chiny' UNION ALL 
SELECT 579, 64, 23, N'z Chinami' UNION ALL 
SELECT 580, 64, 24, N'Chinach' UNION ALL 
SELECT 581, 64, 25, N'Chiny' UNION ALL 
SELECT 582, 65, 10, N'Japonia' UNION ALL 
SELECT 583, 65, 11, N'Japonii' UNION ALL 
SELECT 584, 65, 12, N'Japonii' UNION ALL 
SELECT 585, 65, 13, N'Japonię' UNION ALL 
SELECT 586, 65, 14, N'z Japonią' UNION ALL 
SELECT 587, 65, 15, N'Japonii' UNION ALL 
SELECT 588, 65, 16, N'Japonio' UNION ALL 
SELECT 589, 65, 17, N'do Japonii' UNION ALL 
SELECT 590, 65, 18, N'w Japonii' UNION ALL 
SELECT 591, 66, 17, N'do Indii' UNION ALL 
SELECT 592, 66, 18, N'w Indiach' UNION ALL 
SELECT 593, 66, 19, N'Indie' UNION ALL 
SELECT 594, 66, 20, N'Indii' UNION ALL 
SELECT 595, 66, 21, N'Indiom' UNION ALL 
SELECT 596, 66, 22, N'Indie' UNION ALL 
SELECT 597, 66, 23, N'z Indiami' UNION ALL 
SELECT 598, 66, 24, N'Indiach' UNION ALL 
SELECT 599, 66, 25, N'Indie' UNION ALL 
SELECT 600, 67, 10, N'Kanada' UNION ALL 
SELECT 601, 67, 11, N'Kanady' UNION ALL 
SELECT 602, 67, 12, N'Kanadzie' UNION ALL 
SELECT 603, 67, 13, N'Kanadę' UNION ALL 
SELECT 604, 67, 14, N'z Kanadą' UNION ALL 
SELECT 605, 67, 15, N'Kanadzie' UNION ALL 
SELECT 606, 67, 16, N'Kanado' UNION ALL 
SELECT 607, 67, 17, N'do Kanady' UNION ALL 
SELECT 608, 67, 18, N'w Kanadzie' UNION ALL 
SELECT 609, 68, 17, N'na Bahamy' UNION ALL 
SELECT 610, 68, 18, N'na Bahamach' UNION ALL 
SELECT 611, 68, 19, N'Bahamy' UNION ALL 
SELECT 612, 68, 20, N'Bahamów' UNION ALL 
SELECT 613, 68, 21, N'Bahamom' UNION ALL 
SELECT 614, 68, 22, N'Bahamy' UNION ALL 
SELECT 615, 68, 23, N'z Bahamami' UNION ALL 
SELECT 616, 68, 24, N'Bahamach' UNION ALL 
SELECT 617, 68, 25, N'Bahamy' UNION ALL 
SELECT 618, 69, 10, N'Belize' UNION ALL 
SELECT 619, 69, 11, N'Belize' UNION ALL 
SELECT 620, 69, 12, N'Belize' UNION ALL 
SELECT 621, 69, 13, N'Belize' UNION ALL 
SELECT 622, 69, 14, N'z Belize' UNION ALL 
SELECT 623, 69, 15, N'Belize' UNION ALL 
SELECT 624, 69, 16, N'Belize' UNION ALL 
SELECT 625, 69, 17, N'do Belize' UNION ALL 
SELECT 626, 69, 18, N'w Belize' UNION ALL 
SELECT 627, 70, 10, N'Tajlandia' UNION ALL 
SELECT 628, 70, 11, N'Tajlandii' UNION ALL 
SELECT 629, 70, 12, N'Tajlandii' UNION ALL 
SELECT 630, 70, 13, N'Tajlandię' UNION ALL 
SELECT 631, 70, 14, N'z Tajlandią' UNION ALL 
SELECT 632, 70, 15, N'Tajlandii' UNION ALL 
SELECT 633, 70, 16, N'Tajlandio' UNION ALL 
SELECT 634, 70, 17, N'do Tajlandii' UNION ALL 
SELECT 635, 70, 18, N'w Tajlandii' UNION ALL 
SELECT 636, 71, 10, N'Izrael' UNION ALL 
SELECT 637, 71, 11, N'Izraela' UNION ALL 
SELECT 638, 71, 12, N'Izraelowi' UNION ALL 
SELECT 639, 71, 13, N'Izrael' UNION ALL 
SELECT 640, 71, 14, N'z Izraelem' UNION ALL 
SELECT 641, 71, 15, N'Izraelu' UNION ALL 
SELECT 642, 71, 16, N'Izraelu' UNION ALL 
SELECT 643, 71, 17, N'do Izraela' UNION ALL 
SELECT 644, 71, 18, N'w Izraelu' UNION ALL 
SELECT 645, 72, 10, N'Liban' UNION ALL 
SELECT 646, 72, 11, N'Libanu' UNION ALL 
SELECT 647, 72, 12, N'Libanowi' UNION ALL 
SELECT 648, 72, 13, N'Liban' UNION ALL 
SELECT 649, 72, 14, N'z Libanem' UNION ALL 
SELECT 650, 72, 15, N'Libanie' UNION ALL 
SELECT 651, 72, 16, N'Libanie' UNION ALL 
SELECT 652, 72, 17, N'do Libanu' UNION ALL 
SELECT 653, 72, 18, N'w Libanie' UNION ALL 
SELECT 654, 73, 10, N'Jordania' UNION ALL 
SELECT 655, 73, 11, N'Jordanii' UNION ALL 
SELECT 656, 73, 12, N'Jordanii' UNION ALL 
SELECT 657, 73, 13, N'Jordanię' UNION ALL 
SELECT 658, 73, 14, N'z Jordanią' UNION ALL 
SELECT 659, 73, 15, N'Jordanii' UNION ALL 
SELECT 660, 73, 16, N'Jordanio' UNION ALL 
SELECT 661, 73, 17, N'do Jordanii' UNION ALL 
SELECT 662, 73, 18, N'w Jordanii' UNION ALL 
SELECT 663, 74, 10, N'Syria' UNION ALL 
SELECT 664, 74, 11, N'Syrii' UNION ALL 
SELECT 665, 74, 12, N'Syrii' UNION ALL 
SELECT 666, 74, 13, N'Syrię' UNION ALL 
SELECT 667, 74, 14, N'z Syrią' UNION ALL 
SELECT 668, 74, 15, N'Syrii' UNION ALL 
SELECT 669, 74, 16, N'Syrio' UNION ALL 
SELECT 670, 74, 17, N'do Syrii' UNION ALL 
SELECT 671, 74, 18, N'w Syrii' UNION ALL 
SELECT 672, 75, 10, N'Arabia Saudyjska' UNION ALL 
SELECT 673, 75, 11, N'Arabii Saudyjskiej' UNION ALL 
SELECT 674, 75, 12, N'Arabii Saudyjskiej' UNION ALL 
SELECT 675, 75, 13, N'Arabię Saudyjską' UNION ALL 
SELECT 676, 75, 14, N'z Arabią Saudyjską' UNION ALL 
SELECT 677, 75, 15, N'Arabii Saudyjskiej' UNION ALL 
SELECT 678, 75, 16, N'Arabio Saudyjska' UNION ALL 
SELECT 679, 75, 17, N'do Arabii Saudyjskiej' UNION ALL 
SELECT 680, 75, 18, N'w Arabii Saudyjskiej' UNION ALL 
SELECT 681, 76, 10, N'Jemen' UNION ALL 
SELECT 682, 76, 11, N'Jemenu' UNION ALL 
SELECT 683, 76, 12, N'Jemenowi' UNION ALL 
SELECT 684, 76, 13, N'Jemen' UNION ALL 
SELECT 685, 76, 14, N'z Jemenem' UNION ALL 
SELECT 686, 76, 15, N'Jemenie' UNION ALL 
SELECT 687, 76, 16, N'Jemenie' UNION ALL 
SELECT 688, 76, 17, N'do Jemenu' UNION ALL 
SELECT 689, 76, 18, N'w Jemenie' UNION ALL 
SELECT 690, 77, 10, N'Oman' UNION ALL 
SELECT 691, 77, 11, N'Omanu' UNION ALL 
SELECT 692, 77, 12, N'Omanowi' UNION ALL 
SELECT 693, 77, 13, N'Oman' UNION ALL 
SELECT 694, 77, 14, N'z Omanem' UNION ALL 
SELECT 695, 77, 15, N'Omanie' UNION ALL 
SELECT 696, 77, 16, N'Omanie' UNION ALL 
SELECT 697, 77, 17, N'do Omanu' UNION ALL 
SELECT 698, 77, 18, N'w Omanie' UNION ALL 
SELECT 699, 78, 17, N'do Zjednoczonych Emiratów Arabskich' UNION ALL 
SELECT 700, 78, 18, N'w Zjednoczonych Emiratach Arabskich' UNION ALL 
SELECT 701, 78, 19, N'Zjednoczone Emiraty Arabskie' UNION ALL 
SELECT 702, 78, 20, N'Zjednoczonych Emiratów Arabskich' UNION ALL 
SELECT 703, 78, 21, N'Zjednoczonym Emiratom Arabskim' UNION ALL 
SELECT 704, 78, 22, N'Zjednoczone Emiraty Arabskie' UNION ALL 
SELECT 705, 78, 23, N'ze Zjednoczonymi Emiratami Arabskimi' UNION ALL 
SELECT 706, 78, 24, N'Zjednoczonych Emiratach Arabskich' UNION ALL 
SELECT 707, 78, 25, N'Zjednoczone Emiraty Arabskie' UNION ALL 
SELECT 708, 79, 10, N'Kuwejt' UNION ALL 
SELECT 709, 79, 11, N'Kuwejtu' UNION ALL 
SELECT 710, 79, 12, N'Kuwejtowi' UNION ALL 
SELECT 711, 79, 13, N'Kuwejt' UNION ALL 
SELECT 712, 79, 14, N'z Kuwejtem' UNION ALL 
SELECT 713, 79, 15, N'Kuwejcie' UNION ALL 
SELECT 714, 79, 16, N'Kuwejcie' UNION ALL 
SELECT 715, 79, 17, N'do Kuwejtu' UNION ALL 
SELECT 716, 79, 18, N'w Kuwejcie' UNION ALL 
SELECT 717, 80, 10, N'Dominikana' UNION ALL 
SELECT 718, 80, 11, N'Dominikany' UNION ALL 
SELECT 719, 80, 12, N'Dominikanie' UNION ALL 
SELECT 720, 80, 13, N'Dominikanę' UNION ALL 
SELECT 721, 80, 14, N'z Dominikaną' UNION ALL 
SELECT 722, 80, 15, N'Dominikanie' UNION ALL 
SELECT 723, 80, 16, N'Dominikano' UNION ALL 
SELECT 724, 80, 17, N'na Dominikanę' UNION ALL 
SELECT 725, 80, 18, N'na Dominikanie' UNION ALL 
SELECT 726, 81, 10, N'RPA' UNION ALL 
SELECT 727, 81, 11, N'RPA' UNION ALL 
SELECT 728, 81, 12, N'RPA' UNION ALL 
SELECT 729, 81, 13, N'RPA' UNION ALL 
SELECT 730, 81, 14, N'z RPA' UNION ALL 
SELECT 731, 81, 15, N'RPA' UNION ALL 
SELECT 732, 81, 16, N'RPA' UNION ALL 
SELECT 733, 81, 17, N'do RPA' UNION ALL 
SELECT 734, 81, 18, N'w RPA' UNION ALL 
SELECT 735, 82, 10, N'Republika Południowej Afryki' UNION ALL 
SELECT 736, 82, 11, N'Republiki Południowej Afryki' UNION ALL 
SELECT 737, 82, 12, N'Republice Południowej Afryki' UNION ALL 
SELECT 738, 82, 13, N'Republikę Południowej Afryki' UNION ALL 
SELECT 739, 82, 14, N'z Republiką Południowej Afryki' UNION ALL 
SELECT 740, 82, 15, N'Republice Południowej Afryki' UNION ALL 
SELECT 741, 82, 16, N'Republiko Południowej Afryki' UNION ALL 
SELECT 742, 82, 17, N'do Republiki Południowej Afryki' UNION ALL 
SELECT 743, 82, 18, N'w Republice Południowej Afryki' UNION ALL 
SELECT 744, 83, 10, N'Południowa Afryka' UNION ALL 
SELECT 745, 83, 11, N'Południowej Afryki' UNION ALL 
SELECT 746, 83, 12, N'Południowej Afryce' UNION ALL 
SELECT 747, 83, 13, N'Południową Afrykę' UNION ALL 
SELECT 748, 83, 14, N'z Południową Afryką' UNION ALL 
SELECT 749, 83, 15, N'Południowej Afryce' UNION ALL 
SELECT 750, 83, 16, N'Południowa Afryko' UNION ALL 
SELECT 751, 83, 17, N'do Południowej Afryki' UNION ALL 
SELECT 752, 83, 18, N'w Południowej Afryce' UNION ALL 
SELECT 753, 84, 10, N'Kenia' UNION ALL 
SELECT 754, 84, 11, N'Kenii' UNION ALL 
SELECT 755, 84, 12, N'Kenii' UNION ALL 
SELECT 756, 84, 13, N'Kenię' UNION ALL 
SELECT 757, 84, 14, N'z Kenią' UNION ALL 
SELECT 758, 84, 15, N'Kenii' UNION ALL 
SELECT 759, 84, 16, N'Kenio' UNION ALL 
SELECT 760, 84, 17, N'do Kenii' UNION ALL 
SELECT 761, 84, 18, N'w Kenii' UNION ALL 
SELECT 762, 85, 10, N'Kamerun' UNION ALL 
SELECT 763, 85, 11, N'Kamerunu' UNION ALL 
SELECT 764, 85, 12, N'Kamerunowi' UNION ALL 
SELECT 765, 85, 13, N'Kamerun' UNION ALL 
SELECT 766, 85, 14, N'z Kamerunem' UNION ALL 
SELECT 767, 85, 15, N'Kamerunie' UNION ALL 
SELECT 768, 85, 16, N'Kamerunie' UNION ALL 
SELECT 769, 85, 17, N'do Kamerunu' UNION ALL 
SELECT 770, 85, 18, N'w Kamerunie' UNION ALL 
SELECT 771, 86, 10, N'Nigeria' UNION ALL 
SELECT 772, 86, 11, N'Nigerii' UNION ALL 
SELECT 773, 86, 12, N'Nigerii' UNION ALL 
SELECT 774, 86, 13, N'Nigerię' UNION ALL 
SELECT 775, 86, 14, N'z Nigerią' UNION ALL 
SELECT 776, 86, 15, N'Nigerii' UNION ALL 
SELECT 777, 86, 16, N'Nigerio' UNION ALL 
SELECT 778, 86, 17, N'do Nigerii' UNION ALL 
SELECT 779, 86, 18, N'w Nigerii' UNION ALL 
SELECT 780, 87, 10, N'Algieria' UNION ALL 
SELECT 781, 87, 11, N'Algierii' UNION ALL 
SELECT 782, 87, 12, N'Algierii' UNION ALL 
SELECT 783, 87, 13, N'Algierię' UNION ALL 
SELECT 784, 87, 14, N'z Algierią' UNION ALL 
SELECT 785, 87, 15, N'Algierii' UNION ALL 
SELECT 786, 87, 16, N'Algierio' UNION ALL 
SELECT 787, 87, 17, N'do Algierii' UNION ALL 
SELECT 788, 87, 18, N'w Algierii' UNION ALL 
SELECT 789, 88, 10, N'Grenlandia' UNION ALL 
SELECT 790, 88, 11, N'Grenlandii' UNION ALL 
SELECT 791, 88, 12, N'Grenlandii' UNION ALL 
SELECT 792, 88, 13, N'Grenlandię' UNION ALL 
SELECT 793, 88, 14, N'z Grenlandią' UNION ALL 
SELECT 794, 88, 15, N'Grenlandii' UNION ALL 
SELECT 795, 88, 16, N'Grenlandio' UNION ALL 
SELECT 796, 88, 17, N'na Grenlandię' UNION ALL 
SELECT 797, 88, 18, N'na Grenlandii' UNION ALL 
SELECT 798, 89, 10, N'Tanzania' UNION ALL 
SELECT 799, 89, 11, N'Tanzanii' UNION ALL 
SELECT 800, 89, 12, N'Tanzanii' UNION ALL 
SELECT 801, 89, 13, N'Tanzanię' UNION ALL 
SELECT 802, 89, 14, N'z Tanzanią' UNION ALL 
SELECT 803, 89, 15, N'Tanzanii' UNION ALL 
SELECT 804, 89, 16, N'Tanzanio' UNION ALL 
SELECT 805, 89, 17, N'do Tanzanii' UNION ALL 
SELECT 806, 89, 18, N'w Tanzanii' UNION ALL 
SELECT 807, 90, 10, N'Somalia' UNION ALL 
SELECT 808, 90, 11, N'Somalii' UNION ALL 
SELECT 809, 90, 12, N'Somalii' UNION ALL 
SELECT 810, 90, 13, N'Somalię' UNION ALL 
SELECT 811, 90, 14, N'z Somalią' UNION ALL 
SELECT 812, 90, 15, N'Somalii' UNION ALL 
SELECT 813, 90, 16, N'Somalio' UNION ALL 
SELECT 814, 90, 17, N'do Somalii' UNION ALL 
SELECT 815, 90, 18, N'w Somalii' UNION ALL 
SELECT 816, 91, 10, N'Gambia' UNION ALL 
SELECT 817, 91, 11, N'Gambii' UNION ALL 
SELECT 818, 91, 12, N'Gambii' UNION ALL 
SELECT 819, 91, 13, N'Gambię' UNION ALL 
SELECT 820, 91, 14, N'z Gambią' UNION ALL 
SELECT 821, 91, 15, N'Gambii' UNION ALL 
SELECT 822, 91, 16, N'Gambio' UNION ALL 
SELECT 823, 91, 17, N'do Gambii' UNION ALL 
SELECT 824, 91, 18, N'w Gambii' UNION ALL 
SELECT 825, 92, 10, N'Australia' UNION ALL 
SELECT 826, 92, 11, N'Australii' UNION ALL 
SELECT 827, 92, 12, N'Australii' UNION ALL 
SELECT 828, 92, 13, N'Australię' UNION ALL 
SELECT 829, 92, 14, N'z Australią' UNION ALL 
SELECT 830, 92, 15, N'Australii' UNION ALL 
SELECT 831, 92, 16, N'Australio' UNION ALL 
SELECT 832, 92, 17, N'do Australii' UNION ALL 
SELECT 833, 92, 18, N'w Australii' UNION ALL 
SELECT 834, 93, 10, N'Haiti' UNION ALL 
SELECT 835, 93, 11, N'Haiti' UNION ALL 
SELECT 836, 93, 12, N'Haiti' UNION ALL 
SELECT 837, 93, 13, N'Haiti' UNION ALL 
SELECT 838, 93, 14, N'z Haiti' UNION ALL 
SELECT 839, 93, 15, N'Haiti' UNION ALL 
SELECT 840, 93, 16, N'Haiti' UNION ALL 
SELECT 841, 93, 17, N'na Haiti' UNION ALL 
SELECT 842, 93, 18, N'na Haiti' UNION ALL 
SELECT 843, 94, 10, N'Portoryko' UNION ALL 
SELECT 844, 94, 11, N'Portoryko' UNION ALL 
SELECT 845, 94, 12, N'Portoryko' UNION ALL 
SELECT 846, 94, 13, N'Portoryko' UNION ALL 
SELECT 847, 94, 14, N'z Portoryko' UNION ALL 
SELECT 848, 94, 15, N'Portoryko' UNION ALL 
SELECT 849, 94, 16, N'Portoryko' UNION ALL 
SELECT 850, 94, 17, N'do Portoryko' UNION ALL 
SELECT 851, 94, 18, N'w Portoryko' UNION ALL 
SELECT 852, 95, 10, N'Puerto Rico' UNION ALL 
SELECT 853, 95, 11, N'Puerto Rico' UNION ALL 
SELECT 854, 95, 12, N'Puerto Rico' UNION ALL 
SELECT 855, 95, 13, N'Puerto Rico' UNION ALL 
SELECT 856, 95, 14, N'z Puerto Rico' UNION ALL 
SELECT 857, 95, 15, N'Puerto Rico' UNION ALL 
SELECT 858, 95, 16, N'Puerto Rico' UNION ALL 
SELECT 859, 95, 17, N'do Puerto Rico' UNION ALL 
SELECT 860, 95, 18, N'w Puerto Rico' UNION ALL 
SELECT 861, 96, 10, N'Kostaryka' UNION ALL 
SELECT 862, 96, 11, N'Kostaryki' UNION ALL 
SELECT 863, 96, 12, N'Kostaryce' UNION ALL 
SELECT 864, 96, 13, N'Kostarykę' UNION ALL 
SELECT 865, 96, 14, N'z Kostaryką' UNION ALL 
SELECT 866, 96, 15, N'Kostaryce' UNION ALL 
SELECT 867, 96, 16, N'Kostaryko' UNION ALL 
SELECT 868, 96, 17, N'do Kostaryki' UNION ALL 
SELECT 869, 96, 18, N'w Kostaryce' UNION ALL 
SELECT 870, 97, 10, N'Namibia' UNION ALL 
SELECT 871, 97, 11, N'Namibii' UNION ALL 
SELECT 872, 97, 12, N'Namibii' UNION ALL 
SELECT 873, 97, 13, N'Namibię' UNION ALL 
SELECT 874, 97, 14, N'z Namibią' UNION ALL 
SELECT 875, 97, 15, N'Namibii' UNION ALL 
SELECT 876, 97, 16, N'Namibio' UNION ALL 
SELECT 877, 97, 17, N'do Namibii' UNION ALL 
SELECT 878, 97, 18, N'w Namibii' UNION ALL 
SELECT 879, 98, 10, N'Panama' UNION ALL 
SELECT 880, 98, 11, N'Panamy' UNION ALL 
SELECT 881, 98, 12, N'Panamie' UNION ALL 
SELECT 882, 98, 13, N'Panamę' UNION ALL 
SELECT 883, 98, 14, N'z Panamą' UNION ALL 
SELECT 884, 98, 15, N'Panamie' UNION ALL 
SELECT 885, 98, 16, N'Panamo' UNION ALL 
SELECT 886, 98, 17, N'do Panamę' UNION ALL 
SELECT 887, 98, 18, N'do Panamie' UNION ALL 
SELECT 888, 99, 10, N'Nikaragua' UNION ALL 
SELECT 889, 99, 11, N'Nikaragui' UNION ALL 
SELECT 890, 99, 12, N'Nikaraguie' UNION ALL 
SELECT 891, 99, 13, N'Nikaraguę' UNION ALL 
SELECT 892, 99, 14, N'z Nikaraguą' UNION ALL 
SELECT 893, 99, 15, N'Nikaraguie' UNION ALL 
SELECT 894, 99, 16, N'Nikaraguo' UNION ALL 
SELECT 895, 99, 17, N'do Nikaragui' UNION ALL 
SELECT 896, 99, 18, N'w Nikaragui' UNION ALL 
SELECT 897, 100, 10, N'Zambia' UNION ALL 
SELECT 898, 100, 11, N'Zambii' UNION ALL 
SELECT 899, 100, 12, N'Zambii' UNION ALL 
SELECT 900, 100, 13, N'Zambię' UNION ALL 
SELECT 901, 100, 14, N'z Zambią' UNION ALL 
SELECT 902, 100, 15, N'Zambii' UNION ALL 
SELECT 903, 100, 16, N'Zambio' UNION ALL 
SELECT 904, 100, 17, N'do Zambii' UNION ALL 
SELECT 905, 100, 18, N'w Zambii' UNION ALL 
SELECT 906, 101, 10, N'Botswana' UNION ALL 
SELECT 907, 101, 11, N'Botswany' UNION ALL 
SELECT 908, 101, 12, N'Botswanie' UNION ALL 
SELECT 909, 101, 13, N'Botswanę' UNION ALL 
SELECT 910, 101, 14, N'z Botswaną' UNION ALL 
SELECT 911, 101, 15, N'Botswanie' UNION ALL 
SELECT 912, 101, 16, N'Botswano' UNION ALL 
SELECT 913, 101, 17, N'do Botswanę' UNION ALL 
SELECT 914, 101, 18, N'do Botswanie' UNION ALL 
SELECT 915, 102, 10, N'Bahrajn' UNION ALL 
SELECT 916, 102, 11, N'Bahrajnu' UNION ALL 
SELECT 917, 102, 12, N'Bahrajnowi' UNION ALL 
SELECT 918, 102, 13, N'Bahrajn' UNION ALL 
SELECT 919, 102, 14, N'z Bahrajnem' UNION ALL 
SELECT 920, 102, 15, N'Bahrajnie' UNION ALL 
SELECT 921, 102, 16, N'Bahrajnie' UNION ALL 
SELECT 922, 102, 17, N'do Bahrajnu' UNION ALL 
SELECT 923, 102, 18, N'w Bahrajnie' UNION ALL 
SELECT 924, 103, 10, N'Katar' UNION ALL 
SELECT 925, 103, 11, N'Kataru' UNION ALL 
SELECT 926, 103, 12, N'Katarowi' UNION ALL 
SELECT 927, 103, 13, N'Katar' UNION ALL 
SELECT 928, 103, 14, N'z Katarem' UNION ALL 
SELECT 929, 103, 15, N'Katarze' UNION ALL 
SELECT 930, 103, 16, N'Katarze' UNION ALL 
SELECT 931, 103, 17, N'do Kataru' UNION ALL 
SELECT 932, 103, 18, N'w Katarze' UNION ALL 
SELECT 933, 104, 10, N'Irak' UNION ALL 
SELECT 934, 104, 11, N'Iraku' UNION ALL 
SELECT 935, 104, 12, N'Irakowi' UNION ALL 
SELECT 936, 104, 13, N'Irak' UNION ALL 
SELECT 937, 104, 14, N'z Irakiem' UNION ALL 
SELECT 938, 104, 15, N'Iraku' UNION ALL 
SELECT 939, 104, 16, N'Iraku' UNION ALL 
SELECT 940, 104, 17, N'do Iraku' UNION ALL 
SELECT 941, 104, 18, N'w Iraku' UNION ALL 
SELECT 942, 105, 10, N'Iran' UNION ALL 
SELECT 943, 105, 11, N'Iranu' UNION ALL 
SELECT 944, 105, 12, N'Iranowi' UNION ALL 
SELECT 945, 105, 13, N'Iran' UNION ALL 
SELECT 946, 105, 14, N'z Iranem' UNION ALL 
SELECT 947, 105, 15, N'Iranie' UNION ALL 
SELECT 948, 105, 16, N'Iranie' UNION ALL 
SELECT 949, 105, 17, N'do Iranu' UNION ALL 
SELECT 950, 105, 18, N'w Iranie' UNION ALL 
SELECT 951, 106, 10, N'Afganistan' UNION ALL 
SELECT 952, 106, 11, N'Afganistanu' UNION ALL 
SELECT 953, 106, 12, N'Afganistanowi' UNION ALL 
SELECT 954, 106, 13, N'Afganistan' UNION ALL 
SELECT 955, 106, 14, N'z Afganistanem' UNION ALL 
SELECT 956, 106, 15, N'Afganistanie' UNION ALL 
SELECT 957, 106, 16, N'Afganistanie' UNION ALL 
SELECT 958, 106, 17, N'do Afganistanu' UNION ALL 
SELECT 959, 106, 18, N'w Afganistanie' UNION ALL 
SELECT 960, 107, 10, N'Pakistan' UNION ALL 
SELECT 961, 107, 11, N'Pakistanu' UNION ALL 
SELECT 962, 107, 12, N'Pakistanowi' UNION ALL 
SELECT 963, 107, 13, N'Pakistan' UNION ALL 
SELECT 964, 107, 14, N'z Pakistanem' UNION ALL 
SELECT 965, 107, 15, N'Pakistanie' UNION ALL 
SELECT 966, 107, 16, N'Pakistanie' UNION ALL 
SELECT 967, 107, 17, N'do Pakistanu' UNION ALL 
SELECT 968, 107, 18, N'w Pakistanie' UNION ALL 
SELECT 969, 108, 10, N'Uzbekistan' UNION ALL 
SELECT 970, 108, 11, N'Uzbekistanu' UNION ALL 
SELECT 971, 108, 12, N'Uzbekistanowi' UNION ALL 
SELECT 972, 108, 13, N'Uzbekistan' UNION ALL 
SELECT 973, 108, 14, N'z Uzbekistanem' UNION ALL 
SELECT 974, 108, 15, N'Uzbekistanie' UNION ALL 
SELECT 975, 108, 16, N'Uzbekistanie' UNION ALL 
SELECT 976, 108, 17, N'do Uzbekistanu' UNION ALL 
SELECT 977, 108, 18, N'w Uzbekistanie' UNION ALL 
SELECT 978, 109, 10, N'Turkmenistan' UNION ALL 
SELECT 979, 109, 11, N'Turkmenistanu' UNION ALL 
SELECT 980, 109, 12, N'Turkmenistanowi' UNION ALL 
SELECT 981, 109, 13, N'Turkmenistan' UNION ALL 
SELECT 982, 109, 14, N'z Turkmenistanem' UNION ALL 
SELECT 983, 109, 15, N'Turkmenistanie' UNION ALL 
SELECT 984, 109, 16, N'Turkmenistanie' UNION ALL 
SELECT 985, 109, 17, N'do Turkmenistanu' UNION ALL 
SELECT 986, 109, 18, N'w Turkmenistanie' UNION ALL 
SELECT 987, 110, 10, N'Tadżykistan' UNION ALL 
SELECT 988, 110, 11, N'Tadżykistanu' UNION ALL 
SELECT 989, 110, 12, N'Tadżykistanowi' UNION ALL 
SELECT 990, 110, 13, N'Tadżykistan' UNION ALL 
SELECT 991, 110, 14, N'z Tadżykistanem' UNION ALL 
SELECT 992, 110, 15, N'Tadżykistanie' UNION ALL 
SELECT 993, 110, 16, N'Tadżykistanie' UNION ALL 
SELECT 994, 110, 17, N'do Tadżykistanu' UNION ALL 
SELECT 995, 110, 18, N'w Tadżykistanie' UNION ALL 
SELECT 996, 111, 10, N'Kirgistan' UNION ALL 
SELECT 997, 111, 11, N'Kirgistanu' UNION ALL 
SELECT 998, 111, 12, N'Kirgistanowi' UNION ALL 
SELECT 999, 111, 13, N'Kirgistan' UNION ALL 
SELECT 1000, 111, 14, N'z Kirgistanem' UNION ALL 
SELECT 1001, 111, 15, N'Kirgistanie' UNION ALL 
SELECT 1002, 111, 16, N'Kirgistanie' UNION ALL 
SELECT 1003, 111, 17, N'do Kirgistanu' UNION ALL 
SELECT 1004, 111, 18, N'w Kirgistanie' UNION ALL 
SELECT 1005, 112, 10, N'Nepal' UNION ALL 
SELECT 1006, 112, 11, N'Nepalu' UNION ALL 
SELECT 1007, 112, 12, N'Nepalowi' UNION ALL 
SELECT 1008, 112, 13, N'Nepal' UNION ALL 
SELECT 1009, 112, 14, N'z Nepalem' UNION ALL 
SELECT 1010, 112, 15, N'Nepalu' UNION ALL 
SELECT 1011, 112, 16, N'Nepalu' UNION ALL 
SELECT 1012, 112, 17, N'do Nepalu' UNION ALL 
SELECT 1013, 112, 18, N'w Nepalu' UNION ALL 
SELECT 1014, 113, 10, N'Mongolia' UNION ALL 
SELECT 1015, 113, 11, N'Mongolii' UNION ALL 
SELECT 1016, 113, 12, N'Mongolii' UNION ALL 
SELECT 1017, 113, 13, N'Mongolię' UNION ALL 
SELECT 1018, 113, 14, N'z Mongolią' UNION ALL 
SELECT 1019, 113, 15, N'Mongolii' UNION ALL 
SELECT 1020, 113, 16, N'Mongolio' UNION ALL 
SELECT 1021, 113, 17, N'do Mongolii' UNION ALL 
SELECT 1022, 113, 18, N'w Mongolii' UNION ALL 
SELECT 1023, 114, 10, N'Bhutan' UNION ALL 
SELECT 1024, 114, 11, N'Bhutanu' UNION ALL 
SELECT 1025, 114, 12, N'Bhutanowi' UNION ALL 
SELECT 1026, 114, 13, N'Bhutan' UNION ALL 
SELECT 1027, 114, 14, N'z Bhutanem' UNION ALL 
SELECT 1028, 114, 15, N'Bhutanie' UNION ALL 
SELECT 1029, 114, 16, N'Bhutanie' UNION ALL 
SELECT 1030, 114, 17, N'do Bhutanu' UNION ALL 
SELECT 1031, 114, 18, N'w Bhutanie' UNION ALL 
SELECT 1032, 115, 10, N'Bangladesz' UNION ALL 
SELECT 1033, 115, 11, N'Bangladeszu' UNION ALL 
SELECT 1034, 115, 12, N'Bangladeszowi' UNION ALL 
SELECT 1035, 115, 13, N'Bangladesz' UNION ALL 
SELECT 1036, 115, 14, N'z Bangladeszem' UNION ALL 
SELECT 1037, 115, 15, N'Bangladeszu' UNION ALL 
SELECT 1038, 115, 16, N'Bangladeszu' UNION ALL 
SELECT 1039, 115, 17, N'do Bangladeszu' UNION ALL 
SELECT 1040, 115, 18, N'w Bangladeszu' UNION ALL 
SELECT 1041, 116, 10, N'Sri Lanka' UNION ALL 
SELECT 1042, 116, 11, N'Sri Lanki' UNION ALL 
SELECT 1043, 116, 12, N'Sri Lance' UNION ALL 
SELECT 1044, 116, 13, N'Sri Lankę' UNION ALL 
SELECT 1045, 116, 14, N'ze Sri Lanką' UNION ALL 
SELECT 1046, 116, 15, N'Sri Lance' UNION ALL 
SELECT 1047, 116, 16, N'Sri Lanko' UNION ALL 
SELECT 1048, 116, 17, N'na Sri Lankę' UNION ALL 
SELECT 1049, 116, 18, N'na Sri Lance' UNION ALL 
SELECT 1050, 117, 10, N'Laos' UNION ALL 
SELECT 1051, 117, 11, N'Laosu' UNION ALL 
SELECT 1052, 117, 12, N'Laosowi' UNION ALL 
SELECT 1053, 117, 13, N'Laos' UNION ALL 
SELECT 1054, 117, 14, N'z Laosem' UNION ALL 
SELECT 1055, 117, 15, N'Laosie' UNION ALL 
SELECT 1056, 117, 16, N'Laosie' UNION ALL 
SELECT 1057, 117, 17, N'do Laosu' UNION ALL 
SELECT 1058, 117, 18, N'w Laosie' UNION ALL 
SELECT 1059, 118, 10, N'Kambodża' UNION ALL 
SELECT 1060, 118, 11, N'Kambodży' UNION ALL 
SELECT 1061, 118, 12, N'Kambodży' UNION ALL 
SELECT 1062, 118, 13, N'Kambodżę' UNION ALL 
SELECT 1063, 118, 14, N'z Kambodżą' UNION ALL 
SELECT 1064, 118, 15, N'Kambodży' UNION ALL 
SELECT 1065, 118, 16, N'Kambodżo' UNION ALL 
SELECT 1066, 118, 17, N'do Kambodży' UNION ALL 
SELECT 1067, 118, 18, N'w Kambodży' UNION ALL 
SELECT 1068, 119, 10, N'Wietnam' UNION ALL 
SELECT 1069, 119, 11, N'Wietnamu' UNION ALL 
SELECT 1070, 119, 12, N'Wietnamowi' UNION ALL 
SELECT 1071, 119, 13, N'Wietnam' UNION ALL 
SELECT 1072, 119, 14, N'z Wietnamem' UNION ALL 
SELECT 1073, 119, 15, N'Wietnamie' UNION ALL 
SELECT 1074, 119, 16, N'Wietnamie' UNION ALL 
SELECT 1075, 119, 17, N'do Wietnamu' UNION ALL 
SELECT 1076, 119, 18, N'w Wietnamie' UNION ALL 
SELECT 1077, 120, 10, N'Myanmar' UNION ALL 
SELECT 1078, 120, 11, N'Myanmaru' UNION ALL 
SELECT 1079, 120, 12, N'Myanmarowi' UNION ALL 
SELECT 1080, 120, 13, N'Myanmar' UNION ALL 
SELECT 1081, 120, 14, N'z Myanmarem' UNION ALL 
SELECT 1082, 120, 15, N'Myanmarze' UNION ALL 
SELECT 1083, 120, 16, N'Myanmarze' UNION ALL 
SELECT 1084, 120, 17, N'do Myanmaru' UNION ALL 
SELECT 1085, 120, 18, N'w Myanmarze' UNION ALL 
SELECT 1086, 121, 10, N'Birma' UNION ALL 
SELECT 1087, 121, 11, N'Birmy' UNION ALL 
SELECT 1088, 121, 12, N'Birmie' UNION ALL 
SELECT 1089, 121, 13, N'Birmę' UNION ALL 
SELECT 1090, 121, 14, N'z Birmą' UNION ALL 
SELECT 1091, 121, 15, N'Birmie' UNION ALL 
SELECT 1092, 121, 16, N'Birmo' UNION ALL 
SELECT 1093, 121, 17, N'do Birmy' UNION ALL 
SELECT 1094, 121, 18, N'w Birmie' UNION ALL 
SELECT 1095, 122, 10, N'Korea Południowa' UNION ALL 
SELECT 1096, 122, 11, N'Korei Południowej' UNION ALL 
SELECT 1097, 122, 12, N'Korei Południowej' UNION ALL 
SELECT 1098, 122, 13, N'Koreę Południową' UNION ALL 
SELECT 1099, 122, 14, N'z Koreą Południową' UNION ALL 
SELECT 1100, 122, 15, N'Korei Południowej' UNION ALL 
SELECT 1101, 122, 16, N'Koreo Południowa' UNION ALL 
SELECT 1102, 122, 17, N'do Korei Południowej' UNION ALL 
SELECT 1103, 122, 18, N'w Korei Południowej' UNION ALL 
SELECT 1104, 123, 10, N'Singapur' UNION ALL 
SELECT 1105, 123, 11, N'Singapuru' UNION ALL 
SELECT 1106, 123, 12, N'Singapurowi' UNION ALL 
SELECT 1107, 123, 13, N'Singapur' UNION ALL 
SELECT 1108, 123, 14, N'z Singapurem' UNION ALL 
SELECT 1109, 123, 15, N'Singapurze' UNION ALL 
SELECT 1110, 123, 16, N'Singapurze' UNION ALL 
SELECT 1111, 123, 17, N'do Singapuru' UNION ALL 
SELECT 1112, 123, 18, N'w Singapurze' UNION ALL 
SELECT 1113, 124, 10, N'Hongkong' UNION ALL 
SELECT 1114, 124, 11, N'Hongkongu' UNION ALL 
SELECT 1115, 124, 12, N'Hongkongowi' UNION ALL 
SELECT 1116, 124, 13, N'Hongkong' UNION ALL 
SELECT 1117, 124, 14, N'z Hongkongiem' UNION ALL 
SELECT 1118, 124, 15, N'Hongkongu' UNION ALL 
SELECT 1119, 124, 16, N'Hongkongu' UNION ALL 
SELECT 1120, 124, 17, N'do Hongkongu' UNION ALL 
SELECT 1121, 124, 18, N'w Hongkongu' UNION ALL 
SELECT 1122, 125, 10, N'Tajwan' UNION ALL 
SELECT 1123, 125, 11, N'Tajwanu' UNION ALL 
SELECT 1124, 125, 12, N'Tajwanowi' UNION ALL 
SELECT 1125, 125, 13, N'Tajwan' UNION ALL 
SELECT 1126, 125, 14, N'z Tajwanem' UNION ALL 
SELECT 1127, 125, 15, N'Tajwanie' UNION ALL 
SELECT 1128, 125, 16, N'Tajwanie' UNION ALL 
SELECT 1129, 125, 17, N'na Tajwan' UNION ALL 
SELECT 1130, 125, 18, N'na Tajwanie' UNION ALL 
SELECT 1131, 126, 17, N'na Filipiny' UNION ALL 
SELECT 1132, 126, 18, N'na Filipinach' UNION ALL 
SELECT 1133, 126, 19, N'Filipiny' UNION ALL 
SELECT 1134, 126, 20, N'Filipin' UNION ALL 
SELECT 1135, 126, 21, N'Filipinom' UNION ALL 
SELECT 1136, 126, 22, N'Filipiny' UNION ALL 
SELECT 1137, 126, 23, N'z Filipinami' UNION ALL 
SELECT 1138, 126, 24, N'Filipinach' UNION ALL 
SELECT 1139, 126, 25, N'Filipiny' UNION ALL 
SELECT 1140, 127, 10, N'Indonezja' UNION ALL 
SELECT 1141, 127, 11, N'Indonezji' UNION ALL 
SELECT 1142, 127, 12, N'Indonezji' UNION ALL 
SELECT 1143, 127, 13, N'Indonezję' UNION ALL 
SELECT 1144, 127, 14, N'z Indonezją' UNION ALL 
SELECT 1145, 127, 15, N'Indonezji' UNION ALL 
SELECT 1146, 127, 16, N'Indonezjo' UNION ALL 
SELECT 1147, 127, 17, N'do Indonezji' UNION ALL 
SELECT 1148, 127, 18, N'w Indonezji' UNION ALL 
SELECT 1149, 128, 10, N'Malezja' UNION ALL 
SELECT 1150, 128, 11, N'Malezji' UNION ALL 
SELECT 1151, 128, 12, N'Malezji' UNION ALL 
SELECT 1152, 128, 13, N'Malezję' UNION ALL 
SELECT 1153, 128, 14, N'z Malezją' UNION ALL 
SELECT 1154, 128, 15, N'Malezji' UNION ALL 
SELECT 1155, 128, 16, N'Malezjo' UNION ALL 
SELECT 1156, 128, 17, N'do Malezji' UNION ALL 
SELECT 1157, 128, 18, N'w Malezji' UNION ALL 
SELECT 1158, 129, 10, N'Korea Północna' UNION ALL 
SELECT 1159, 129, 11, N'Korei Północnej' UNION ALL 
SELECT 1160, 129, 12, N'Korei Północnej' UNION ALL 
SELECT 1161, 129, 13, N'Koreę Północną' UNION ALL 
SELECT 1162, 129, 14, N'z Koreą Północną' UNION ALL 
SELECT 1163, 129, 15, N'Korei Północnej' UNION ALL 
SELECT 1164, 129, 16, N'Koreo Północna' UNION ALL 
SELECT 1165, 129, 17, N'do Korei Północnej' UNION ALL 
SELECT 1166, 129, 18, N'w Korei Północnej' UNION ALL 
SELECT 1167, 130, 10, N'Nowa Zelandia' UNION ALL 
SELECT 1168, 130, 11, N'Nowej Zelandii' UNION ALL 
SELECT 1169, 130, 12, N'Nowej Zelandii' UNION ALL 
SELECT 1170, 130, 13, N'Nową Zelandię' UNION ALL 
SELECT 1171, 130, 14, N'z Nową Zelandią' UNION ALL 
SELECT 1172, 130, 15, N'Nowej Zelandii' UNION ALL 
SELECT 1173, 130, 16, N'Nowa Zelandio' UNION ALL 
SELECT 1174, 130, 17, N'do Nowej Zelandii' UNION ALL 
SELECT 1175, 130, 18, N'w Nowej Zelandii' UNION ALL 
SELECT 1176, 131, 10, N'Fidżi' UNION ALL 
SELECT 1177, 131, 11, N'Fidżi' UNION ALL 
SELECT 1178, 131, 12, N'Fidżi' UNION ALL 
SELECT 1179, 131, 13, N'Fidżi' UNION ALL 
SELECT 1180, 131, 14, N'z Fidżi' UNION ALL 
SELECT 1181, 131, 15, N'Fidżi' UNION ALL 
SELECT 1182, 131, 16, N'Fidżi' UNION ALL 
SELECT 1183, 131, 17, N'na Fidżi' UNION ALL 
SELECT 1184, 131, 18, N'na Fidżi' UNION ALL 
SELECT 1185, 132, 10, N'Meksyk' UNION ALL 
SELECT 1186, 132, 11, N'Meksyku' UNION ALL 
SELECT 1187, 132, 12, N'Meksykowi' UNION ALL 
SELECT 1188, 132, 13, N'Meksyk' UNION ALL 
SELECT 1189, 132, 14, N'z Meksykiem' UNION ALL 
SELECT 1190, 132, 15, N'Meksyku' UNION ALL 
SELECT 1191, 132, 16, N'Meksyku' UNION ALL 
SELECT 1192, 132, 17, N'do Meksyku' UNION ALL 
SELECT 1193, 132, 18, N'w Meksyku' UNION ALL 
SELECT 1194, 133, 10, N'Jamajka' UNION ALL 
SELECT 1195, 133, 11, N'Jamajki' UNION ALL 
SELECT 1196, 133, 12, N'Jamajce' UNION ALL 
SELECT 1197, 133, 13, N'Jamajkę' UNION ALL 
SELECT 1198, 133, 14, N'z Jamajką' UNION ALL 
SELECT 1199, 133, 15, N'Jamajce' UNION ALL 
SELECT 1200, 133, 16, N'Jamajko' UNION ALL 
SELECT 1201, 133, 17, N'na Jamajkę' UNION ALL 
SELECT 1202, 133, 18, N'na Jamajce' UNION ALL 
SELECT 1203, 134, 10, N'Kuba' UNION ALL 
SELECT 1204, 134, 11, N'Kuby' UNION ALL 
SELECT 1205, 134, 12, N'Kubie' UNION ALL 
SELECT 1206, 134, 13, N'Kubę' UNION ALL 
SELECT 1207, 134, 14, N'z Kubą' UNION ALL 
SELECT 1208, 134, 15, N'Kubie' UNION ALL 
SELECT 1209, 134, 16, N'Kubo' UNION ALL 
SELECT 1210, 134, 17, N'na Kubę' UNION ALL 
SELECT 1211, 134, 18, N'na Kubie' UNION ALL 
SELECT 1212, 135, 10, N'Honduras' UNION ALL 
SELECT 1213, 135, 11, N'Hondurasu' UNION ALL 
SELECT 1214, 135, 12, N'Hondurasowi' UNION ALL 
SELECT 1215, 135, 13, N'Honduras' UNION ALL 
SELECT 1216, 135, 14, N'z Hondurasem' UNION ALL 
SELECT 1217, 135, 15, N'Hondurasie' UNION ALL 
SELECT 1218, 135, 16, N'Hondurasie' UNION ALL 
SELECT 1219, 135, 17, N'do Hondurasu' UNION ALL 
SELECT 1220, 135, 18, N'w Hondurasie' UNION ALL 
SELECT 1221, 136, 10, N'Salwador' UNION ALL 
SELECT 1222, 136, 11, N'Salwadoru' UNION ALL 
SELECT 1223, 136, 12, N'Salwadorowi' UNION ALL 
SELECT 1224, 136, 13, N'Salwador' UNION ALL 
SELECT 1225, 136, 14, N'z Salwadorem' UNION ALL 
SELECT 1226, 136, 15, N'Salwadorze' UNION ALL 
SELECT 1227, 136, 16, N'Salwadorze' UNION ALL 
SELECT 1228, 136, 17, N'do Salwadoru' UNION ALL 
SELECT 1229, 136, 18, N'w Salwadorze' UNION ALL 
SELECT 1230, 137, 10, N'Gwatemala' UNION ALL 
SELECT 1231, 137, 11, N'Gwatemali' UNION ALL 
SELECT 1232, 137, 12, N'Gwatemali' UNION ALL 
SELECT 1233, 137, 13, N'Gwatemalę' UNION ALL 
SELECT 1234, 137, 14, N'z Gwatemalą' UNION ALL 
SELECT 1235, 137, 15, N'Gwatemali' UNION ALL 
SELECT 1236, 137, 16, N'Gwatemalo' UNION ALL 
SELECT 1237, 137, 17, N'do Gwatemali' UNION ALL 
SELECT 1238, 137, 18, N'w Gwatemali' UNION ALL 
SELECT 1239, 138, 10, N'Angola' UNION ALL 
SELECT 1240, 138, 11, N'Angoli' UNION ALL 
SELECT 1241, 138, 12, N'Angoli' UNION ALL 
SELECT 1242, 138, 13, N'Angolę' UNION ALL 
SELECT 1243, 138, 14, N'z Angolą' UNION ALL 
SELECT 1244, 138, 15, N'Angoli' UNION ALL 
SELECT 1245, 138, 16, N'Angolo' UNION ALL 
SELECT 1246, 138, 17, N'do Angoli' UNION ALL 
SELECT 1247, 138, 18, N'w Angoli' UNION ALL 
SELECT 1248, 139, 10, N'Liberia' UNION ALL 
SELECT 1249, 139, 11, N'Liberii' UNION ALL 
SELECT 1250, 139, 12, N'Liberii' UNION ALL 
SELECT 1251, 139, 13, N'Liberię' UNION ALL 
SELECT 1252, 139, 14, N'z Liberią' UNION ALL 
SELECT 1253, 139, 15, N'Liberii' UNION ALL 
SELECT 1254, 139, 16, N'Liberio' UNION ALL 
SELECT 1255, 139, 17, N'do Liberii' UNION ALL 
SELECT 1256, 139, 18, N'w Liberii' UNION ALL 
SELECT 1257, 140, 10, N'Madagaskar' UNION ALL 
SELECT 1258, 140, 11, N'Madagaskaru' UNION ALL 
SELECT 1259, 140, 12, N'Madagaskarowi' UNION ALL 
SELECT 1260, 140, 13, N'Madagaskar' UNION ALL 
SELECT 1261, 140, 14, N'zMadagaskar em' UNION ALL 
SELECT 1262, 140, 15, N'Madagaskarze' UNION ALL 
SELECT 1263, 140, 16, N'Madagaskarze' UNION ALL 
SELECT 1264, 140, 17, N'na Madagaskar' UNION ALL 
SELECT 1265, 140, 18, N'na Madagaskarze' UNION ALL 
SELECT 1266, 141, 10, N'Zimbabwe' UNION ALL 
SELECT 1267, 141, 11, N'Zimbabwe' UNION ALL 
SELECT 1268, 141, 12, N'Zimbabwe' UNION ALL 
SELECT 1269, 141, 13, N'Zimbabwe' UNION ALL 
SELECT 1270, 141, 14, N'z Zimbabwe' UNION ALL 
SELECT 1271, 141, 15, N'Zimbabwe' UNION ALL 
SELECT 1272, 141, 16, N'Zimbabwe' UNION ALL 
SELECT 1273, 141, 17, N'do Zimbabwe' UNION ALL 
SELECT 1274, 141, 18, N'w Zimbabwe' UNION ALL 
SELECT 1275, 142, 17, N'na Seszele' UNION ALL 
SELECT 1276, 142, 18, N'na Seszelach' UNION ALL 
SELECT 1277, 142, 19, N'Seszele' UNION ALL 
SELECT 1278, 142, 20, N'Seszeli' UNION ALL 
SELECT 1279, 142, 21, N'Seszelom' UNION ALL 
SELECT 1280, 142, 22, N'Seszele' UNION ALL 
SELECT 1281, 142, 23, N'z Seszelami' UNION ALL 
SELECT 1282, 142, 24, N'Seszelach' UNION ALL 
SELECT 1283, 142, 25, N'Seszele' UNION ALL 
SELECT 1284, 143, 10, N'Mauritius' UNION ALL 
SELECT 1285, 143, 11, N'Mauritiusu' UNION ALL 
SELECT 1286, 143, 12, N'Mauritiusowi' UNION ALL 
SELECT 1287, 143, 13, N'Mauritius' UNION ALL 
SELECT 1288, 143, 14, N'z Mauritiusem' UNION ALL 
SELECT 1289, 143, 15, N'Mauritiusie' UNION ALL 
SELECT 1290, 143, 16, N'Mauritiusie' UNION ALL 
SELECT 1291, 143, 17, N'na Mauritius' UNION ALL 
SELECT 1292, 143, 18, N'na Mauritiusie' UNION ALL 
SELECT 1293, 144, 17, N'do USA' UNION ALL 
SELECT 1294, 144, 18, N'w USA' UNION ALL 
SELECT 1295, 144, 19, N'USA' UNION ALL 
SELECT 1296, 144, 20, N'USA' UNION ALL 
SELECT 1297, 144, 21, N'USA' UNION ALL 
SELECT 1298, 144, 22, N'USA' UNION ALL 
SELECT 1299, 144, 23, N'z USA' UNION ALL 
SELECT 1300, 144, 24, N'USA' UNION ALL 
SELECT 1301, 144, 25, N'USA' UNION ALL 
SELECT 1302, 145, 17, N'do Stanów Zjednoczonych' UNION ALL 
SELECT 1303, 145, 18, N'w Stanach Zjednoczonych' UNION ALL 
SELECT 1304, 145, 19, N'Stany Zjednoczone' UNION ALL 
SELECT 1305, 145, 20, N'Stanów Zjednoczonych' UNION ALL 
SELECT 1306, 145, 21, N'Stanom Zjednoczonym' UNION ALL 
SELECT 1307, 145, 22, N'Stany Zjednoczone' UNION ALL 
SELECT 1308, 145, 23, N'ze Stanami Zjednoczonymi' UNION ALL 
SELECT 1309, 145, 24, N'Stanach Zjednoczonych' UNION ALL 
SELECT 1310, 145, 25, N'Stany Zjednoczone' UNION ALL 
SELECT 1311, 146, 10, N'Mozambik' UNION ALL 
SELECT 1312, 146, 11, N'Mozambiku' UNION ALL 
SELECT 1313, 146, 12, N'Mozambikowi' UNION ALL 
SELECT 1314, 146, 13, N'Mozambik' UNION ALL 
SELECT 1315, 146, 14, N'z Mozambikiem' UNION ALL 
SELECT 1316, 146, 15, N'Mozambiku' UNION ALL 
SELECT 1317, 146, 16, N'Mozambiku' UNION ALL 
SELECT 1318, 146, 17, N'do Mozambiku' UNION ALL 
SELECT 1319, 146, 18, N'w Mozambiku' UNION ALL 
SELECT 1320, 147, 10, N'Ruanda' UNION ALL 
SELECT 1321, 147, 11, N'Ruandy' UNION ALL 
SELECT 1322, 147, 12, N'Ruandzie' UNION ALL 
SELECT 1323, 147, 13, N'Ruandę' UNION ALL 
SELECT 1324, 147, 14, N'z Ruandą' UNION ALL 
SELECT 1325, 147, 15, N'Ruandzie' UNION ALL 
SELECT 1326, 147, 16, N'Ruando' UNION ALL 
SELECT 1327, 147, 17, N'do Ruandy' UNION ALL 
SELECT 1328, 147, 18, N'w Ruandzie' UNION ALL 
SELECT 1329, 148, 10, N'Rwanda' UNION ALL 
SELECT 1330, 148, 11, N'Rwandy' UNION ALL 
SELECT 1331, 148, 12, N'Rwandzie' UNION ALL 
SELECT 1332, 148, 13, N'Rwandę' UNION ALL 
SELECT 1333, 148, 14, N'z Rwandą' UNION ALL 
SELECT 1334, 148, 15, N'Rwandzie' UNION ALL 
SELECT 1335, 148, 16, N'Rwando' UNION ALL 
SELECT 1336, 148, 17, N'do Rwandy' UNION ALL 
SELECT 1337, 148, 18, N'w Rwandzie' UNION ALL 
SELECT 1338, 149, 10, N'Burundi' UNION ALL 
SELECT 1339, 149, 11, N'Burundi' UNION ALL 
SELECT 1340, 149, 12, N'Burundi' UNION ALL 
SELECT 1341, 149, 13, N'Burundi' UNION ALL 
SELECT 1342, 149, 14, N'z Burundi' UNION ALL 
SELECT 1343, 149, 15, N'Burundi' UNION ALL 
SELECT 1344, 149, 16, N'Burundi' UNION ALL 
SELECT 1345, 149, 17, N'do Burundi' UNION ALL 
SELECT 1346, 149, 18, N'w Burundi' UNION ALL 
SELECT 1347, 150, 10, N'Uganda' UNION ALL 
SELECT 1348, 150, 11, N'Ugandy' UNION ALL 
SELECT 1349, 150, 12, N'Ugandzie' UNION ALL 
SELECT 1350, 150, 13, N'Ugandę' UNION ALL 
SELECT 1351, 150, 14, N'z Ugandą' UNION ALL 
SELECT 1352, 150, 15, N'Ugandzie' UNION ALL 
SELECT 1353, 150, 16, N'Ugando' UNION ALL 
SELECT 1354, 150, 17, N'do Ugandy' UNION ALL 
SELECT 1355, 150, 18, N'w Ugandzie' UNION ALL 
SELECT 1356, 151, 10, N'Kongo' UNION ALL 
SELECT 1357, 151, 11, N'Kongo' UNION ALL 
SELECT 1358, 151, 12, N'Kongo' UNION ALL 
SELECT 1359, 151, 13, N'Kongo' UNION ALL 
SELECT 1360, 151, 14, N'z Kongo' UNION ALL 
SELECT 1361, 151, 15, N'Kongo' UNION ALL 
SELECT 1362, 151, 16, N'Kongo' UNION ALL 
SELECT 1363, 151, 17, N'do Kongo' UNION ALL 
SELECT 1364, 151, 18, N'w Kongo' UNION ALL 
SELECT 1365, 152, 10, N'Gabon' UNION ALL 
SELECT 1366, 152, 11, N'Gabonu' UNION ALL 
SELECT 1367, 152, 12, N'Gabonowi' UNION ALL 
SELECT 1368, 152, 13, N'Gabon' UNION ALL 
SELECT 1369, 152, 14, N'z Gabonem' UNION ALL 
SELECT 1370, 152, 15, N'Gabonie' UNION ALL 
SELECT 1371, 152, 16, N'Gabonie' UNION ALL 
SELECT 1372, 152, 17, N'do Gabonu' UNION ALL 
SELECT 1373, 152, 18, N'w Gabonie' UNION ALL 
SELECT 1374, 153, 10, N'Demokratyczna Republika Konga' UNION ALL 
SELECT 1375, 153, 11, N'Demokratycznej Republiki Konga' UNION ALL 
SELECT 1376, 153, 12, N'Demokratycznej Republice Konga' UNION ALL 
SELECT 1377, 153, 13, N'Demokratyczną Republikę Konga' UNION ALL 
SELECT 1378, 153, 14, N'z Demokratyczną Republiką Konga' UNION ALL 
SELECT 1379, 153, 15, N'Demokratycznej Republice Konga' UNION ALL 
SELECT 1380, 153, 16, N'Demokratyczna Republiko Konga' UNION ALL 
SELECT 1381, 153, 17, N'do Demokratycznej Republiki Konga' UNION ALL 
SELECT 1382, 153, 18, N'w Demokratycznej Republice Konga' UNION ALL 
SELECT 1383, 154, 10, N'Arabia' UNION ALL 
SELECT 1384, 154, 11, N'Arabii' UNION ALL 
SELECT 1385, 154, 12, N'Arabii' UNION ALL 
SELECT 1386, 154, 13, N'Arabię' UNION ALL 
SELECT 1387, 154, 14, N'z Arabią' UNION ALL 
SELECT 1388, 154, 15, N'Arabii' UNION ALL 
SELECT 1389, 154, 16, N'Arabio' UNION ALL 
SELECT 1390, 154, 17, N'do Arabii' UNION ALL 
SELECT 1391, 154, 18, N'w Arabii' UNION ALL 
SELECT 1392, 155, 17, N'do Emiratów Arabskich' UNION ALL 
SELECT 1393, 155, 18, N'w Emiratach Arabskich' UNION ALL 
SELECT 1394, 155, 19, N'Emiraty Arabskie' UNION ALL 
SELECT 1395, 155, 20, N'Emiratów Arabskich' UNION ALL 
SELECT 1396, 155, 21, N'Emiratom Arabskim' UNION ALL 
SELECT 1397, 155, 22, N'Emiraty Arabskie' UNION ALL 
SELECT 1398, 155, 23, N'z Emiratami Arabskimi' UNION ALL 
SELECT 1399, 155, 24, N'Emiratach Arabskich' UNION ALL 
SELECT 1400, 155, 25, N'Emiraty Arabskie' UNION ALL 
SELECT 1401, 156, 17, N'do EmiratEmirat.ów' UNION ALL 
SELECT 1402, 156, 18, N'w EmiratEmirat.ach' UNION ALL 
SELECT 1403, 156, 19, N'EmiratEmirat.y' UNION ALL 
SELECT 1404, 156, 20, N'EmiratEmirat.ów' UNION ALL 
SELECT 1405, 156, 21, N'EmiratEmirat.om' UNION ALL 
SELECT 1406, 156, 22, N'EmiratEmirat.y' UNION ALL 
SELECT 1407, 156, 23, N'z EmiratEmirat.ami' UNION ALL 
SELECT 1408, 156, 24, N'EmiratEmirat.ach' UNION ALL 
SELECT 1409, 156, 25, N'EmiratEmirat.y' UNION ALL 
SELECT 1410, 157, 10, N'Egipt' UNION ALL 
SELECT 1411, 157, 11, N'Egiptu' UNION ALL 
SELECT 1412, 157, 12, N'Egiptowi' UNION ALL 
SELECT 1413, 157, 13, N'Egipt' UNION ALL 
SELECT 1414, 157, 14, N'z Egiptem' UNION ALL 
SELECT 1415, 157, 15, N'Egipcie' UNION ALL 
SELECT 1416, 157, 16, N'Egipcie' UNION ALL 
SELECT 1417, 157, 17, N'do Egiptu' UNION ALL 
SELECT 1418, 157, 18, N'w Egipcie' UNION ALL 
SELECT 1419, 158, 10, N'Libia' UNION ALL 
SELECT 1420, 158, 11, N'Libii' UNION ALL 
SELECT 1421, 158, 12, N'Libii' UNION ALL 
SELECT 1422, 158, 13, N'Libię' UNION ALL 
SELECT 1423, 158, 14, N'z Libią' UNION ALL 
SELECT 1424, 158, 15, N'Libii' UNION ALL 
SELECT 1425, 158, 16, N'Libio' UNION ALL 
SELECT 1426, 158, 17, N'do Libii' UNION ALL 
SELECT 1427, 158, 18, N'w Libii' UNION ALL 
SELECT 1428, 159, 10, N'Tunezja' UNION ALL 
SELECT 1429, 159, 11, N'Tunezji' UNION ALL 
SELECT 1430, 159, 12, N'Tunezji' UNION ALL 
SELECT 1431, 159, 13, N'Tunezję' UNION ALL 
SELECT 1432, 159, 14, N'z Tunezją' UNION ALL 
SELECT 1433, 159, 15, N'Tunezji' UNION ALL 
SELECT 1434, 159, 16, N'Tunezjo' UNION ALL 
SELECT 1435, 159, 17, N'do Tunezji' UNION ALL 
SELECT 1436, 159, 18, N'w Tunezji' UNION ALL 
SELECT 1437, 160, 10, N'Maroko' UNION ALL 
SELECT 1438, 160, 11, N'Maroka' UNION ALL 
SELECT 1439, 160, 12, N'Maroku' UNION ALL 
SELECT 1440, 160, 13, N'Maroko' UNION ALL 
SELECT 1441, 160, 14, N'z Marokiem' UNION ALL 
SELECT 1442, 160, 15, N'Maroku' UNION ALL 
SELECT 1443, 160, 16, N'Maroko' UNION ALL 
SELECT 1444, 160, 17, N'do Maroko' UNION ALL 
SELECT 1445, 160, 18, N'w Maroku' UNION ALL 
SELECT 1446, 161, 10, N'Sudan' UNION ALL 
SELECT 1447, 161, 11, N'Sudanu' UNION ALL 
SELECT 1448, 161, 12, N'Sudanowi' UNION ALL 
SELECT 1449, 161, 13, N'Sudan' UNION ALL 
SELECT 1450, 161, 14, N'z Sudanem' UNION ALL 
SELECT 1451, 161, 15, N'Sudanie' UNION ALL 
SELECT 1452, 161, 16, N'Sudanie' UNION ALL 
SELECT 1453, 161, 17, N'do Sudanu' UNION ALL 
SELECT 1454, 161, 18, N'w Sudanie' UNION ALL 
SELECT 1455, 162, 10, N'Etiopia' UNION ALL 
SELECT 1456, 162, 11, N'Etiopii' UNION ALL 
SELECT 1457, 162, 12, N'Etiopii' UNION ALL 
SELECT 1458, 162, 13, N'Etiopię' UNION ALL 
SELECT 1459, 162, 14, N'z Etiopią' UNION ALL 
SELECT 1460, 162, 15, N'Etiopii' UNION ALL 
SELECT 1461, 162, 16, N'Etiopio' UNION ALL 
SELECT 1462, 162, 17, N'do Etiopii' UNION ALL 
SELECT 1463, 162, 18, N'w Etiopii' UNION ALL 
SELECT 1464, 163, 10, N'Erytrea' UNION ALL 
SELECT 1465, 163, 11, N'Erytrei' UNION ALL 
SELECT 1466, 163, 12, N'Erytrei' UNION ALL 
SELECT 1467, 163, 13, N'Erytreę' UNION ALL 
SELECT 1468, 163, 14, N'z Erytreą' UNION ALL 
SELECT 1469, 163, 15, N'Erytrei' UNION ALL 
SELECT 1470, 163, 16, N'Erytreo' UNION ALL 
SELECT 1471, 163, 17, N'do Erytrei' UNION ALL 
SELECT 1472, 163, 18, N'w Erytrei' UNION ALL 
SELECT 1473, 164, 10, N'Dżibuti' UNION ALL 
SELECT 1474, 164, 11, N'Dżibuti' UNION ALL 
SELECT 1475, 164, 12, N'Dżibuti' UNION ALL 
SELECT 1476, 164, 13, N'Dżibuti' UNION ALL 
SELECT 1477, 164, 14, N'Dżibuti' UNION ALL 
SELECT 1478, 164, 15, N'Dżibuti' UNION ALL 
SELECT 1479, 164, 16, N'Dżibuti' UNION ALL 
SELECT 1480, 164, 17, N'do Dżibuti' UNION ALL 
SELECT 1481, 164, 18, N'w Dżibuti' UNION ALL 
SELECT 1482, 165, 10, N'Czad' UNION ALL 
SELECT 1483, 165, 11, N'Czadu' UNION ALL 
SELECT 1484, 165, 12, N'Czadowi' UNION ALL 
SELECT 1485, 165, 13, N'Czad' UNION ALL 
SELECT 1486, 165, 14, N'z Czadem' UNION ALL 
SELECT 1487, 165, 15, N'Czadzie' UNION ALL 
SELECT 1488, 165, 16, N'Czadzie' UNION ALL 
SELECT 1489, 165, 17, N'do Czadu' UNION ALL 
SELECT 1490, 165, 18, N'w Czadzie' UNION ALL 
SELECT 1491, 166, 10, N'Mauretania' UNION ALL 
SELECT 1492, 166, 11, N'Mauretanii' UNION ALL 
SELECT 1493, 166, 12, N'Mauretanii' UNION ALL 
SELECT 1494, 166, 13, N'Mauretanię' UNION ALL 
SELECT 1495, 166, 14, N'z Mauretanią' UNION ALL 
SELECT 1496, 166, 15, N'Mauretanii' UNION ALL 
SELECT 1497, 166, 16, N'Mauretanio' UNION ALL 
SELECT 1498, 166, 17, N'do Mauretanii' UNION ALL 
SELECT 1499, 166, 18, N'w Mauretanii' UNION ALL 
SELECT 1500, 167, 10, N'Burkina Faso' UNION ALL 
SELECT 1501, 167, 11, N'Burkina Faso' UNION ALL 
SELECT 1502, 167, 12, N'Burkina Faso' UNION ALL 
SELECT 1503, 167, 13, N'Burkina Faso' UNION ALL 
SELECT 1504, 167, 14, N'Burkina Faso' UNION ALL 
SELECT 1505, 167, 15, N'Burkina Faso' UNION ALL 
SELECT 1506, 167, 16, N'Burkina Faso' UNION ALL 
SELECT 1507, 167, 17, N'do Burkina Faso' UNION ALL 
SELECT 1508, 167, 18, N'w Burkina Faso' UNION ALL 
SELECT 1509, 168, 10, N'Mali' UNION ALL 
SELECT 1510, 168, 11, N'Mali' UNION ALL 
SELECT 1511, 168, 12, N'Mali' UNION ALL 
SELECT 1512, 168, 13, N'Mali' UNION ALL 
SELECT 1513, 168, 14, N'Mali' UNION ALL 
SELECT 1514, 168, 15, N'Mali' UNION ALL 
SELECT 1515, 168, 16, N'Mali' UNION ALL 
SELECT 1516, 168, 17, N'do Mali' UNION ALL 
SELECT 1517, 168, 18, N'w Mali' UNION ALL 
SELECT 1518, 169, 10, N'Senegal' UNION ALL 
SELECT 1519, 169, 11, N'Senegalu' UNION ALL 
SELECT 1520, 169, 12, N'Senegalowi' UNION ALL 
SELECT 1521, 169, 13, N'Senegal' UNION ALL 
SELECT 1522, 169, 14, N'z Senegalem' UNION ALL 
SELECT 1523, 169, 15, N'Senegalu' UNION ALL 
SELECT 1524, 169, 16, N'Senegalu' UNION ALL 
SELECT 1525, 169, 17, N'do Senegalu' UNION ALL 
SELECT 1526, 169, 18, N'w Senegalu' UNION ALL 
SELECT 1527, 170, 10, N'Gwinea' UNION ALL 
SELECT 1528, 170, 11, N'Gwinei' UNION ALL 
SELECT 1529, 170, 12, N'Gwinei' UNION ALL 
SELECT 1530, 170, 13, N'Gwineę' UNION ALL 
SELECT 1531, 170, 14, N'z Gwineą' UNION ALL 
SELECT 1532, 170, 15, N'Gwinei' UNION ALL 
SELECT 1533, 170, 16, N'Gwineo' UNION ALL 
SELECT 1534, 170, 17, N'do Gwinei' UNION ALL 
SELECT 1535, 170, 18, N'w Gwinei' UNION ALL 
SELECT 1536, 171, 10, N'Ghana' UNION ALL 
SELECT 1537, 171, 11, N'Ghany' UNION ALL 
SELECT 1538, 171, 12, N'Ghanie' UNION ALL 
SELECT 1539, 171, 13, N'Ghanę' UNION ALL 
SELECT 1540, 171, 14, N'z Ghaną' UNION ALL 
SELECT 1541, 171, 15, N'Ghanie' UNION ALL 
SELECT 1542, 171, 16, N'Ghano' UNION ALL 
SELECT 1543, 171, 17, N'do Ghany' UNION ALL 
SELECT 1544, 171, 18, N'w Ghanie' UNION ALL 
SELECT 1545, 172, 10, N'Wybrzeże Kości Słoniowej' UNION ALL 
SELECT 1546, 172, 11, N'Wybrzeża Kości Słoniowej' UNION ALL 
SELECT 1547, 172, 12, N'Wybrzeżu Kości Słoniowej' UNION ALL 
SELECT 1548, 172, 13, N'Wybrzeże Kości Słoniowej' UNION ALL 
SELECT 1549, 172, 14, N'z Wybrzeżem Kości Słoniowej' UNION ALL 
SELECT 1550, 172, 15, N'Wybrzeżu Kości Słoniowej' UNION ALL 
SELECT 1551, 172, 16, N'Wybrzeże Kości Słoniowej' UNION ALL 
SELECT 1552, 172, 17, N'do Wybrzeża Kości Słoniowej' UNION ALL 
SELECT 1553, 172, 18, N'w Wybrzeżu Kości Słoniowej' UNION ALL 
SELECT 1554, 173, 10, N'Togo' UNION ALL 
SELECT 1555, 173, 11, N'Togo' UNION ALL 
SELECT 1556, 173, 12, N'Togo' UNION ALL 
SELECT 1557, 173, 13, N'Togo' UNION ALL 
SELECT 1558, 173, 14, N'Togo' UNION ALL 
SELECT 1559, 173, 15, N'Togo' UNION ALL 
SELECT 1560, 173, 16, N'Togo' UNION ALL 
SELECT 1561, 173, 17, N'do Togo' UNION ALL 
SELECT 1562, 173, 18, N'w Togo' UNION ALL 
SELECT 1563, 174, 10, N'Sierra Leone' UNION ALL 
SELECT 1564, 174, 11, N'Sierra Leone' UNION ALL 
SELECT 1565, 174, 12, N'Sierra Leone' UNION ALL 
SELECT 1566, 174, 13, N'Sierra Leone' UNION ALL 
SELECT 1567, 174, 14, N'Sierra Leone' UNION ALL 
SELECT 1568, 174, 15, N'Sierra Leone' UNION ALL 
SELECT 1569, 174, 16, N'Sierra Leone' UNION ALL 
SELECT 1570, 174, 17, N'do Sierra Leone' UNION ALL 
SELECT 1571, 174, 18, N'w Sierra Leone' UNION ALL 
SELECT 1572, 175, 10, N'Niger' UNION ALL 
SELECT 1573, 175, 11, N'Nigru' UNION ALL 
SELECT 1574, 175, 12, N'Nigrowi' UNION ALL 
SELECT 1575, 175, 13, N'Niger' UNION ALL 
SELECT 1576, 175, 14, N'z Nigrem' UNION ALL 
SELECT 1577, 175, 15, N'Nigrze' UNION ALL 
SELECT 1578, 175, 16, N'Nigrze' UNION ALL 
SELECT 1579, 175, 17, N'do Nigru' UNION ALL 
SELECT 1580, 175, 18, N'w Nigrze' UNION ALL 
SELECT 1581, 176, 10, N'Europa' UNION ALL 
SELECT 1582, 176, 11, N'Europy' UNION ALL 
SELECT 1583, 176, 12, N'Europie' UNION ALL 
SELECT 1584, 176, 13, N'Europę' UNION ALL 
SELECT 1585, 176, 14, N'z Europą' UNION ALL 
SELECT 1586, 176, 15, N'Europie' UNION ALL 
SELECT 1587, 176, 16, N'Europo' UNION ALL 
SELECT 1588, 176, 17, N'do Europy' UNION ALL 
SELECT 1589, 176, 18, N'w Europie' UNION ALL 
SELECT 1590, 177, 10, N'Ameryka Południowa' UNION ALL 
SELECT 1591, 177, 11, N'Ameryki Południowej' UNION ALL 
SELECT 1592, 177, 12, N'Ameryce Południowej' UNION ALL 
SELECT 1593, 177, 13, N'Amerykę Południową' UNION ALL 
SELECT 1594, 177, 14, N'z Ameryką Południową' UNION ALL 
SELECT 1595, 177, 15, N'Ameryce Południowej' UNION ALL 
SELECT 1596, 177, 16, N'Ameryko Południowa' UNION ALL 
SELECT 1597, 177, 17, N'do Ameryki Południowej' UNION ALL 
SELECT 1598, 177, 18, N'w Ameryce Południowej' UNION ALL 
SELECT 1599, 178, 10, N'Ameryka Północna' UNION ALL 
SELECT 1600, 178, 11, N'Ameryki Północnej' UNION ALL 
SELECT 1601, 178, 12, N'Ameryce Północnej' UNION ALL 
SELECT 1602, 178, 13, N'Amerykę Północną' UNION ALL 
SELECT 1603, 178, 14, N'z Ameryką Północną' UNION ALL 
SELECT 1604, 178, 15, N'Ameryce Północnej' UNION ALL 
SELECT 1605, 178, 16, N'Ameryko Północna' UNION ALL 
SELECT 1606, 178, 17, N'do Ameryki Północnej' UNION ALL 
SELECT 1607, 178, 18, N'w Ameryce Północnej' UNION ALL 
SELECT 1608, 179, 10, N'Afryka' UNION ALL 
SELECT 1609, 179, 11, N'Afryki' UNION ALL 
SELECT 1610, 179, 12, N'Afryce' UNION ALL 
SELECT 1611, 179, 13, N'Afrykę' UNION ALL 
SELECT 1612, 179, 14, N'z Afryką' UNION ALL 
SELECT 1613, 179, 15, N'Afryce' UNION ALL 
SELECT 1614, 179, 16, N'Afryko' UNION ALL 
SELECT 1615, 179, 17, N'do Afryki' UNION ALL 
SELECT 1616, 179, 18, N'w Afryce' UNION ALL 
SELECT 1617, 180, 10, N'Azja' UNION ALL 
SELECT 1618, 180, 11, N'Azji' UNION ALL 
SELECT 1619, 180, 12, N'Azji' UNION ALL 
SELECT 1620, 180, 13, N'Azję' UNION ALL 
SELECT 1621, 180, 14, N'z Azją' UNION ALL 
SELECT 1622, 180, 15, N'Azji' UNION ALL 
SELECT 1623, 180, 16, N'Azjo' UNION ALL 
SELECT 1624, 180, 17, N'do Azji' UNION ALL 
SELECT 1625, 180, 18, N'w Azji' UNION ALL 
SELECT 1626, 181, 10, N'Oceania' UNION ALL 
SELECT 1627, 181, 11, N'Oceanii' UNION ALL 
SELECT 1628, 181, 12, N'Oceanii' UNION ALL 
SELECT 1629, 181, 13, N'Oceanię' UNION ALL 
SELECT 1630, 181, 14, N'z Oceanią' UNION ALL 
SELECT 1631, 181, 15, N'Oceanii' UNION ALL 
SELECT 1632, 181, 16, N'Oceanio' UNION ALL 
SELECT 1633, 181, 17, N'do Oceanii' UNION ALL 
SELECT 1634, 181, 18, N'w Oceanii' UNION ALL 
SELECT 1635, 182, 10, N'Skandynawia' UNION ALL 
SELECT 1636, 182, 11, N'Skandynawii' UNION ALL 
SELECT 1637, 182, 12, N'Skandynawii' UNION ALL 
SELECT 1638, 182, 13, N'Skandynawię' UNION ALL 
SELECT 1639, 182, 14, N'ze Skandynawią' UNION ALL 
SELECT 1640, 182, 15, N'Skandynawii' UNION ALL 
SELECT 1641, 182, 16, N'Skandynawio' UNION ALL 
SELECT 1642, 182, 17, N'do Skandynawii' UNION ALL 
SELECT 1643, 182, 18, N'w Skandynawii' UNION ALL 
SELECT 1644, 183, 10, N'Kaukaz' UNION ALL 
SELECT 1645, 183, 11, N'Kaukazu' UNION ALL 
SELECT 1646, 183, 12, N'Kaukazowi' UNION ALL 
SELECT 1647, 183, 13, N'Kaukaz' UNION ALL 
SELECT 1648, 183, 14, N'z Kaukazem' UNION ALL 
SELECT 1649, 183, 15, N'Kaukazie' UNION ALL 
SELECT 1650, 183, 16, N'Kaukazie' UNION ALL 
SELECT 1651, 183, 17, N'na Kaukaz' UNION ALL 
SELECT 1652, 183, 18, N'na Kaukazie' UNION ALL 
SELECT 1653, 184, 17, N'na Karaiby' UNION ALL 
SELECT 1654, 184, 18, N'na Karaibach' UNION ALL 
SELECT 1655, 184, 19, N'Karaiby' UNION ALL 
SELECT 1656, 184, 20, N'Karaibów' UNION ALL 
SELECT 1657, 184, 21, N'Karaibom' UNION ALL 
SELECT 1658, 184, 22, N'Karaiby' UNION ALL 
SELECT 1659, 184, 23, N'z Karaibami' UNION ALL 
SELECT 1660, 184, 24, N'Karaibach' UNION ALL 
SELECT 1661, 184, 25, N'Karaiby' UNION ALL 
SELECT 1662, 185, 10, N'WKS' UNION ALL 
SELECT 1663, 185, 11, N'WKS' UNION ALL 
SELECT 1664, 185, 12, N'WKS' UNION ALL 
SELECT 1665, 185, 13, N'WKS' UNION ALL 
SELECT 1666, 185, 14, N'WKS' UNION ALL 
SELECT 1667, 185, 15, N'WKS' UNION ALL 
SELECT 1668, 185, 16, N'WKS' UNION ALL 
SELECT 1669, 185, 17, N'do WKS' UNION ALL 
SELECT 1670, 185, 18, N'w WKS' UNION ALL 
SELECT 1671, 186, 10, N'kot' UNION ALL 
SELECT 1672, 186, 11, N'kota' UNION ALL 
SELECT 1673, 186, 12, N'kotu' UNION ALL 
SELECT 1674, 186, 13, N'kota' UNION ALL 
SELECT 1675, 186, 14, N'z kotem' UNION ALL 
SELECT 1676, 186, 15, N'kocie' UNION ALL 
SELECT 1677, 186, 16, N'kocie' UNION ALL 
SELECT 1678, 186, 19, N'koty' UNION ALL 
SELECT 1679, 186, 20, N'kotów' UNION ALL 
SELECT 1680, 186, 21, N'kotom' UNION ALL 
SELECT 1681, 186, 22, N'koty' UNION ALL 
SELECT 1682, 186, 23, N'z kotami' UNION ALL 
SELECT 1683, 186, 24, N'kotach' UNION ALL 
SELECT 1684, 186, 25, N'koty' UNION ALL 
SELECT 1685, 187, 10, N'chomik' UNION ALL 
SELECT 1686, 187, 11, N'chomika' UNION ALL 
SELECT 1687, 187, 12, N'chomikowi' UNION ALL 
SELECT 1688, 187, 13, N'chomika' UNION ALL 
SELECT 1689, 187, 14, N'z chomikiem' UNION ALL 
SELECT 1690, 187, 15, N'chomiku' UNION ALL 
SELECT 1691, 187, 16, N'chomiku' UNION ALL 
SELECT 1692, 187, 19, N'chomiki' UNION ALL 
SELECT 1693, 187, 20, N'chomików' UNION ALL 
SELECT 1694, 187, 21, N'chomikom' UNION ALL 
SELECT 1695, 187, 22, N'chomiki' UNION ALL 
SELECT 1696, 187, 23, N'z chomikami' UNION ALL 
SELECT 1697, 187, 24, N'chomikach' UNION ALL 
SELECT 1698, 187, 25, N'chomiki' UNION ALL 
SELECT 1699, 188, 10, N'krowa' UNION ALL 
SELECT 1700, 188, 11, N'krowy' UNION ALL 
SELECT 1701, 188, 12, N'krowie' UNION ALL 
SELECT 1702, 188, 13, N'krowę' UNION ALL 
SELECT 1703, 188, 14, N'z krową' UNION ALL 
SELECT 1704, 188, 15, N'krowie' UNION ALL 
SELECT 1705, 188, 16, N'krowo' UNION ALL 
SELECT 1706, 188, 19, N'krowy' UNION ALL 
SELECT 1707, 188, 20, N'krów' UNION ALL 
SELECT 1708, 188, 21, N'krowom' UNION ALL 
SELECT 1709, 188, 22, N'krowy' UNION ALL 
SELECT 1710, 188, 23, N'z krowami' UNION ALL 
SELECT 1711, 188, 24, N'krowach' UNION ALL 
SELECT 1712, 188, 25, N'krowy' UNION ALL 
SELECT 1713, 189, 10, N'koń' UNION ALL 
SELECT 1714, 189, 11, N'konia' UNION ALL 
SELECT 1715, 189, 12, N'koniowi' UNION ALL 
SELECT 1716, 189, 13, N'konia' UNION ALL 
SELECT 1717, 189, 14, N'z koniem' UNION ALL 
SELECT 1718, 189, 15, N'koniu' UNION ALL 
SELECT 1719, 189, 16, N'koniu' UNION ALL 
SELECT 1720, 189, 19, N'konie' UNION ALL 
SELECT 1721, 189, 20, N'koni' UNION ALL 
SELECT 1722, 189, 21, N'koniom' UNION ALL 
SELECT 1723, 189, 22, N'konie' UNION ALL 
SELECT 1724, 189, 23, N'z końmi' UNION ALL 
SELECT 1725, 189, 24, N'koniach' UNION ALL 
SELECT 1726, 189, 25, N'konie' UNION ALL 
SELECT 1727, 190, 10, N'mucha' UNION ALL 
SELECT 1728, 190, 11, N'muchy' UNION ALL 
SELECT 1729, 190, 12, N'musze' UNION ALL 
SELECT 1730, 190, 13, N'muchę' UNION ALL 
SELECT 1731, 190, 14, N'z muchą' UNION ALL 
SELECT 1732, 190, 15, N'musze' UNION ALL 
SELECT 1733, 190, 16, N'mucho' UNION ALL 
SELECT 1734, 190, 19, N'muchy' UNION ALL 
SELECT 1735, 190, 20, N'much' UNION ALL 
SELECT 1736, 190, 21, N'muchom' UNION ALL 
SELECT 1737, 190, 22, N'muchy' UNION ALL 
SELECT 1738, 190, 23, N'z muchami' UNION ALL 
SELECT 1739, 190, 24, N'muchach' UNION ALL 
SELECT 1740, 190, 25, N'muchy' UNION ALL 
SELECT 1741, 191, 10, N'pszczoła' UNION ALL 
SELECT 1742, 191, 11, N'pszczoły' UNION ALL 
SELECT 1743, 191, 12, N'pszczole' UNION ALL 
SELECT 1744, 191, 13, N'pszczołę' UNION ALL 
SELECT 1745, 191, 14, N'z pszczołą' UNION ALL 
SELECT 1746, 191, 15, N'pszczole' UNION ALL 
SELECT 1747, 191, 16, N'pszczoło' UNION ALL 
SELECT 1748, 191, 19, N'pszczoły' UNION ALL 
SELECT 1749, 191, 20, N'pszczół' UNION ALL 
SELECT 1750, 191, 21, N'pszczołom' UNION ALL 
SELECT 1751, 191, 22, N'pszczoły' UNION ALL 
SELECT 1752, 191, 23, N'z pszczołami' UNION ALL 
SELECT 1753, 191, 24, N'pszczołach' UNION ALL 
SELECT 1754, 191, 25, N'pszczoły' UNION ALL 
SELECT 1755, 192, 10, N'osa' UNION ALL 
SELECT 1756, 192, 11, N'osy' UNION ALL 
SELECT 1757, 192, 12, N'osie' UNION ALL 
SELECT 1758, 192, 13, N'osę' UNION ALL 
SELECT 1759, 192, 14, N'z osą' UNION ALL 
SELECT 1760, 192, 15, N'osie' UNION ALL 
SELECT 1761, 192, 16, N'oso' UNION ALL 
SELECT 1762, 192, 19, N'osy' UNION ALL 
SELECT 1763, 192, 20, N'os' UNION ALL 
SELECT 1764, 192, 21, N'osom' UNION ALL 
SELECT 1765, 192, 22, N'osy' UNION ALL 
SELECT 1766, 192, 23, N'z osami' UNION ALL 
SELECT 1767, 192, 24, N'osach' UNION ALL 
SELECT 1768, 192, 25, N'osy' UNION ALL 
SELECT 1769, 193, 10, N'komar' UNION ALL 
SELECT 1770, 193, 11, N'komara' UNION ALL 
SELECT 1771, 193, 12, N'komarowi' UNION ALL 
SELECT 1772, 193, 13, N'komara' UNION ALL 
SELECT 1773, 193, 14, N'z komarem' UNION ALL 
SELECT 1774, 193, 15, N'komarze' UNION ALL 
SELECT 1775, 193, 16, N'komarze' UNION ALL 
SELECT 1776, 193, 19, N'komary' UNION ALL 
SELECT 1777, 193, 20, N'komarów' UNION ALL 
SELECT 1778, 193, 21, N'komarom' UNION ALL 
SELECT 1779, 193, 22, N'komary' UNION ALL 
SELECT 1780, 193, 23, N'z komarami' UNION ALL 
SELECT 1781, 193, 24, N'komarach' UNION ALL 
SELECT 1782, 193, 25, N'komary' UNION ALL 
SELECT 1783, 194, 10, N'żaba' UNION ALL 
SELECT 1784, 194, 11, N'żaby' UNION ALL 
SELECT 1785, 194, 12, N'żabie' UNION ALL 
SELECT 1786, 194, 13, N'żabę' UNION ALL 
SELECT 1787, 194, 14, N'z żabą' UNION ALL 
SELECT 1788, 194, 15, N'żabie' UNION ALL 
SELECT 1789, 194, 16, N'żabo' UNION ALL 
SELECT 1790, 194, 19, N'żaby' UNION ALL 
SELECT 1791, 194, 20, N'żab' UNION ALL 
SELECT 1792, 194, 21, N'żabom' UNION ALL 
SELECT 1793, 194, 22, N'żaby' UNION ALL 
SELECT 1794, 194, 23, N'z żabami' UNION ALL 
SELECT 1795, 194, 24, N'żabach' UNION ALL 
SELECT 1796, 194, 25, N'żaby' UNION ALL 
SELECT 1797, 195, 10, N'ptak' UNION ALL 
SELECT 1798, 195, 11, N'ptaka' UNION ALL 
SELECT 1799, 195, 12, N'ptakowi' UNION ALL 
SELECT 1800, 195, 13, N'ptaka' UNION ALL 
SELECT 1801, 195, 14, N'z ptakiem' UNION ALL 
SELECT 1802, 195, 15, N'ptaku' UNION ALL 
SELECT 1803, 195, 16, N'ptaku' UNION ALL 
SELECT 1804, 195, 19, N'ptaki' UNION ALL 
SELECT 1805, 195, 20, N'ptaków' UNION ALL 
SELECT 1806, 195, 21, N'ptakom' UNION ALL 
SELECT 1807, 195, 22, N'ptaki' UNION ALL 
SELECT 1808, 195, 23, N'z ptakami' UNION ALL 
SELECT 1809, 195, 24, N'ptakach' UNION ALL 
SELECT 1810, 195, 25, N'ptaki' UNION ALL 
SELECT 1811, 196, 10, N'ryba' UNION ALL 
SELECT 1812, 196, 11, N'ryby' UNION ALL 
SELECT 1813, 196, 12, N'rybie' UNION ALL 
SELECT 1814, 196, 13, N'rybę' UNION ALL 
SELECT 1815, 196, 14, N'z rybą' UNION ALL 
SELECT 1816, 196, 15, N'rybie' UNION ALL 
SELECT 1817, 196, 16, N'rybo' UNION ALL 
SELECT 1818, 196, 19, N'ryby' UNION ALL 
SELECT 1819, 196, 20, N'ryb' UNION ALL 
SELECT 1820, 196, 21, N'rybom' UNION ALL 
SELECT 1821, 196, 22, N'ryby' UNION ALL 
SELECT 1822, 196, 23, N'z rybami' UNION ALL 
SELECT 1823, 196, 24, N'rybach' UNION ALL 
SELECT 1824, 196, 25, N'ryby' UNION ALL 
SELECT 1825, 197, 10, N'bocian' UNION ALL 
SELECT 1826, 197, 11, N'bociana' UNION ALL 
SELECT 1827, 197, 12, N'bocianowi' UNION ALL 
SELECT 1828, 197, 13, N'bociana' UNION ALL 
SELECT 1829, 197, 14, N'z bocianem' UNION ALL 
SELECT 1830, 197, 15, N'bocianie' UNION ALL 
SELECT 1831, 197, 16, N'bocianie' UNION ALL 
SELECT 1832, 197, 19, N'bociany' UNION ALL 
SELECT 1833, 197, 20, N'bocianów' UNION ALL 
SELECT 1834, 197, 21, N'bocianom' UNION ALL 
SELECT 1835, 197, 22, N'bociany' UNION ALL 
SELECT 1836, 197, 23, N'z bocianami' UNION ALL 
SELECT 1837, 197, 24, N'bocianach' UNION ALL 
SELECT 1838, 197, 25, N'bociany' UNION ALL 
SELECT 1839, 198, 10, N'wróbel' UNION ALL 
SELECT 1840, 198, 11, N'wróbla' UNION ALL 
SELECT 1841, 198, 12, N'wróblowi' UNION ALL 
SELECT 1842, 198, 13, N'wróbla' UNION ALL 
SELECT 1843, 198, 14, N'z wróblem' UNION ALL 
SELECT 1844, 198, 15, N'wróblu' UNION ALL 
SELECT 1845, 198, 16, N'wróblu' UNION ALL 
SELECT 1846, 198, 19, N'wróble' UNION ALL 
SELECT 1847, 198, 20, N'wróbli' UNION ALL 
SELECT 1848, 198, 21, N'wróblom' UNION ALL 
SELECT 1849, 198, 22, N'wróble' UNION ALL 
SELECT 1850, 198, 23, N'z wróblami' UNION ALL 
SELECT 1851, 198, 24, N'wróblach' UNION ALL 
SELECT 1852, 198, 25, N'wróble' UNION ALL 
SELECT 1853, 199, 10, N'motyl' UNION ALL 
SELECT 1854, 199, 11, N'motyla' UNION ALL 
SELECT 1855, 199, 12, N'motylowi' UNION ALL 
SELECT 1856, 199, 13, N'motyla' UNION ALL 
SELECT 1857, 199, 14, N'z motylem' UNION ALL 
SELECT 1858, 199, 15, N'motylu' UNION ALL 
SELECT 1859, 199, 16, N'motylu' UNION ALL 
SELECT 1860, 199, 19, N'motyle' UNION ALL 
SELECT 1861, 199, 20, N'motyli' UNION ALL 
SELECT 1862, 199, 21, N'motylom' UNION ALL 
SELECT 1863, 199, 22, N'motyle' UNION ALL 
SELECT 1864, 199, 23, N'z motylami' UNION ALL 
SELECT 1865, 199, 24, N'motylach' UNION ALL 
SELECT 1866, 199, 25, N'motyle' UNION ALL 
SELECT 1867, 200, 10, N'małpa' UNION ALL 
SELECT 1868, 200, 11, N'małpy' UNION ALL 
SELECT 1869, 200, 12, N'małpie' UNION ALL 
SELECT 1870, 200, 13, N'małpę' UNION ALL 
SELECT 1871, 200, 14, N'z małpą' UNION ALL 
SELECT 1872, 200, 15, N'małpie' UNION ALL 
SELECT 1873, 200, 16, N'małpo' UNION ALL 
SELECT 1874, 200, 19, N'małpy' UNION ALL 
SELECT 1875, 200, 20, N'małp' UNION ALL 
SELECT 1876, 200, 21, N'małpom' UNION ALL 
SELECT 1877, 200, 22, N'małpy' UNION ALL 
SELECT 1878, 200, 23, N'z małpami' UNION ALL 
SELECT 1879, 200, 24, N'małpach' UNION ALL 
SELECT 1880, 200, 25, N'małpy' UNION ALL 
SELECT 1881, 201, 10, N'słoń' UNION ALL 
SELECT 1882, 201, 11, N'słonia' UNION ALL 
SELECT 1883, 201, 12, N'słoniowi' UNION ALL 
SELECT 1884, 201, 13, N'słonia' UNION ALL 
SELECT 1885, 201, 14, N'ze słoniem' UNION ALL 
SELECT 1886, 201, 15, N'słoniu' UNION ALL 
SELECT 1887, 201, 16, N'słoniu' UNION ALL 
SELECT 1888, 201, 19, N'słonie' UNION ALL 
SELECT 1889, 201, 20, N'słoni' UNION ALL 
SELECT 1890, 201, 21, N'słoniom' UNION ALL 
SELECT 1891, 201, 22, N'słonie' UNION ALL 
SELECT 1892, 201, 23, N'ze słoniami' UNION ALL 
SELECT 1893, 201, 24, N'słoniach' UNION ALL 
SELECT 1894, 201, 25, N'słonie' UNION ALL 
SELECT 1895, 202, 10, N'lew' UNION ALL 
SELECT 1896, 202, 11, N'lwa' UNION ALL 
SELECT 1897, 202, 12, N'lwu' UNION ALL 
SELECT 1898, 202, 13, N'lwa' UNION ALL 
SELECT 1899, 202, 14, N'z lwem' UNION ALL 
SELECT 1900, 202, 15, N'lwie' UNION ALL 
SELECT 1901, 202, 16, N'lwie' UNION ALL 
SELECT 1902, 202, 19, N'lwy' UNION ALL 
SELECT 1903, 202, 20, N'lwów' UNION ALL 
SELECT 1904, 202, 21, N'lwom' UNION ALL 
SELECT 1905, 202, 22, N'lwy' UNION ALL 
SELECT 1906, 202, 23, N'z lwami' UNION ALL 
SELECT 1907, 202, 24, N'lwach' UNION ALL 
SELECT 1908, 202, 25, N'lwy' UNION ALL 
SELECT 1909, 203, 10, N'żyrafa' UNION ALL 
SELECT 1910, 203, 11, N'żyrafy' UNION ALL 
SELECT 1911, 203, 12, N'żyrafie' UNION ALL 
SELECT 1912, 203, 13, N'żyrafę' UNION ALL 
SELECT 1913, 203, 14, N'z żyrafą' UNION ALL 
SELECT 1914, 203, 15, N'żyrafie' UNION ALL 
SELECT 1915, 203, 16, N'żyrafo' UNION ALL 
SELECT 1916, 203, 19, N'żyrafy' UNION ALL 
SELECT 1917, 203, 20, N'żyraf' UNION ALL 
SELECT 1918, 203, 21, N'żyrafom' UNION ALL 
SELECT 1919, 203, 22, N'żyrafy' UNION ALL 
SELECT 1920, 203, 23, N'z żyrafami' UNION ALL 
SELECT 1921, 203, 24, N'żyrafach' UNION ALL 
SELECT 1922, 203, 25, N'żyrafy' UNION ALL 
SELECT 1923, 204, 10, N'wielbłąd' UNION ALL 
SELECT 1924, 204, 11, N'wielbłąda' UNION ALL 
SELECT 1925, 204, 12, N'wielbłądowi' UNION ALL 
SELECT 1926, 204, 13, N'wielbłąda' UNION ALL 
SELECT 1927, 204, 14, N'z wielbłądem' UNION ALL 
SELECT 1928, 204, 15, N'wielbłądzie' UNION ALL 
SELECT 1929, 204, 16, N'wielbłądzie' UNION ALL 
SELECT 1930, 204, 19, N'wielbłądy' UNION ALL 
SELECT 1931, 204, 20, N'wielbłądów' UNION ALL 
SELECT 1932, 204, 21, N'wielbłądom' UNION ALL 
SELECT 1933, 204, 22, N'wielbłądy' UNION ALL 
SELECT 1934, 204, 23, N'z wielbłądami' UNION ALL 
SELECT 1935, 204, 24, N'wielbłądach' UNION ALL 
SELECT 1936, 204, 25, N'wielbłądy' UNION ALL 
SELECT 1937, 205, 10, N'tygrys' UNION ALL 
SELECT 1938, 205, 11, N'tygrysa' UNION ALL 
SELECT 1939, 205, 12, N'tygrysowi' UNION ALL 
SELECT 1940, 205, 13, N'tygrysa' UNION ALL 
SELECT 1941, 205, 14, N'z tygrysem' UNION ALL 
SELECT 1942, 205, 15, N'tygrysie' UNION ALL 
SELECT 1943, 205, 16, N'tygrysie' UNION ALL 
SELECT 1944, 205, 19, N'tygrysy' UNION ALL 
SELECT 1945, 205, 20, N'tygrysów' UNION ALL 
SELECT 1946, 205, 21, N'tygrysom' UNION ALL 
SELECT 1947, 205, 22, N'tygrysy' UNION ALL 
SELECT 1948, 205, 23, N'z tygrysami' UNION ALL 
SELECT 1949, 205, 24, N'tygrysach' UNION ALL 
SELECT 1950, 205, 25, N'tygrysy' UNION ALL 
SELECT 1951, 206, 10, N'wąż' UNION ALL 
SELECT 1952, 206, 11, N'węża' UNION ALL 
SELECT 1953, 206, 12, N'wężowi' UNION ALL 
SELECT 1954, 206, 13, N'węża' UNION ALL 
SELECT 1955, 206, 14, N'z wężem' UNION ALL 
SELECT 1956, 206, 15, N'wężu' UNION ALL 
SELECT 1957, 206, 16, N'wężu' UNION ALL 
SELECT 1958, 206, 19, N'węże' UNION ALL 
SELECT 1959, 206, 20, N'węży' UNION ALL 
SELECT 1960, 206, 21, N'wężom' UNION ALL 
SELECT 1961, 206, 22, N'węże' UNION ALL 
SELECT 1962, 206, 23, N'z wężami' UNION ALL 
SELECT 1963, 206, 24, N'wężach' UNION ALL 
SELECT 1964, 206, 25, N'węże' UNION ALL 
SELECT 1965, 207, 10, N'rekin' UNION ALL 
SELECT 1966, 207, 11, N'rekina' UNION ALL 
SELECT 1967, 207, 12, N'rekinowi' UNION ALL 
SELECT 1968, 207, 13, N'rekina' UNION ALL 
SELECT 1969, 207, 14, N'z rekinem' UNION ALL 
SELECT 1970, 207, 15, N'rekinie' UNION ALL 
SELECT 1971, 207, 16, N'rekinie' UNION ALL 
SELECT 1972, 207, 19, N'rekiny' UNION ALL 
SELECT 1973, 207, 20, N'rekinów' UNION ALL 
SELECT 1974, 207, 21, N'rekinom' UNION ALL 
SELECT 1975, 207, 22, N'rekiny' UNION ALL 
SELECT 1976, 207, 23, N'z rekinami' UNION ALL 
SELECT 1977, 207, 24, N'rekinach' UNION ALL 
SELECT 1978, 207, 25, N'rekiny' UNION ALL 
SELECT 1979, 208, 10, N'wieloryb' UNION ALL 
SELECT 1980, 208, 11, N'wieloryba' UNION ALL 
SELECT 1981, 208, 12, N'wielorybowi' UNION ALL 
SELECT 1982, 208, 13, N'wieloryba' UNION ALL 
SELECT 1983, 208, 14, N'z wielorybem' UNION ALL 
SELECT 1984, 208, 15, N'wielorybie' UNION ALL 
SELECT 1985, 208, 16, N'wielorybie' UNION ALL 
SELECT 1986, 208, 19, N'wieloryby' UNION ALL 
SELECT 1987, 208, 20, N'wielorybów' UNION ALL 
SELECT 1988, 208, 21, N'wielorybom' UNION ALL 
SELECT 1989, 208, 22, N'wieloryby' UNION ALL 
SELECT 1990, 208, 23, N'z wielorybami' UNION ALL 
SELECT 1991, 208, 24, N'wielorybach' UNION ALL 
SELECT 1992, 208, 25, N'wieloryby' UNION ALL 
SELECT 1993, 209, 10, N'osioł' UNION ALL 
SELECT 1994, 209, 11, N'osła' UNION ALL 
SELECT 1995, 209, 12, N'osłu' UNION ALL 
SELECT 1996, 209, 13, N'osła' UNION ALL 
SELECT 1997, 209, 14, N'z osłem' UNION ALL 
SELECT 1998, 209, 15, N'ośle' UNION ALL 
SELECT 1999, 209, 16, N'ośle' UNION ALL 
SELECT 2000, 209, 19, N'osły' UNION ALL 
SELECT 2001, 209, 20, N'osłów' UNION ALL 
SELECT 2002, 209, 21, N'osłom' UNION ALL 
SELECT 2003, 209, 22, N'osły' UNION ALL 
SELECT 2004, 209, 23, N'z osłami' UNION ALL 
SELECT 2005, 209, 24, N'osłach' UNION ALL 
SELECT 2006, 209, 25, N'osły' UNION ALL 
SELECT 2007, 210, 10, N'owca' UNION ALL 
SELECT 2008, 210, 11, N'owcy' UNION ALL 
SELECT 2009, 210, 12, N'owcy' UNION ALL 
SELECT 2010, 210, 13, N'owcę' UNION ALL 
SELECT 2011, 210, 14, N'z owcą' UNION ALL 
SELECT 2012, 210, 15, N'owcy' UNION ALL 
SELECT 2013, 210, 16, N'owco' UNION ALL 
SELECT 2014, 210, 19, N'owce' UNION ALL 
SELECT 2015, 210, 20, N'owiec' UNION ALL 
SELECT 2016, 210, 21, N'owcom' UNION ALL 
SELECT 2017, 210, 22, N'owce' UNION ALL 
SELECT 2018, 210, 23, N'z owcami' UNION ALL 
SELECT 2019, 210, 24, N'owcach' UNION ALL 
SELECT 2020, 210, 25, N'owce' UNION ALL 
SELECT 2021, 211, 10, N'gołąb' UNION ALL 
SELECT 2022, 211, 11, N'gołębia' UNION ALL 
SELECT 2023, 211, 12, N'gołębiowi' UNION ALL 
SELECT 2024, 211, 13, N'gołębia' UNION ALL 
SELECT 2025, 211, 14, N'z gołębiem' UNION ALL 
SELECT 2026, 211, 15, N'gołębiu' UNION ALL 
SELECT 2027, 211, 16, N'gołębiu' UNION ALL 
SELECT 2028, 211, 19, N'gołębie' UNION ALL 
SELECT 2029, 211, 20, N'gołębi' UNION ALL 
SELECT 2030, 211, 21, N'gołębio,' UNION ALL 
SELECT 2031, 211, 22, N'gołębie' UNION ALL 
SELECT 2032, 211, 23, N'z gołębiami' UNION ALL 
SELECT 2033, 211, 24, N'gołębiach' UNION ALL 
SELECT 2034, 211, 25, N'gołębie' UNION ALL 
SELECT 2035, 212, 10, N'sokół' UNION ALL 
SELECT 2036, 212, 11, N'sokoła' UNION ALL 
SELECT 2037, 212, 12, N'sokołowi' UNION ALL 
SELECT 2038, 212, 13, N'sokoła' UNION ALL 
SELECT 2039, 212, 14, N'z sokołem' UNION ALL 
SELECT 2040, 212, 15, N'sokole' UNION ALL 
SELECT 2041, 212, 16, N'sokole' UNION ALL 
SELECT 2042, 212, 19, N'sokoły' UNION ALL 
SELECT 2043, 212, 20, N'sokołów' UNION ALL 
SELECT 2044, 212, 21, N'sokołom' UNION ALL 
SELECT 2045, 212, 22, N'sokoły' UNION ALL 
SELECT 2046, 212, 23, N'z sokołami' UNION ALL 
SELECT 2047, 212, 24, N'sokołach' UNION ALL 
SELECT 2048, 212, 25, N'sokoły' UNION ALL 
SELECT 2049, 213, 10, N'orzeł' UNION ALL 
SELECT 2050, 213, 11, N'orła' UNION ALL 
SELECT 2051, 213, 12, N'orłowi' UNION ALL 
SELECT 2052, 213, 13, N'orła' UNION ALL 
SELECT 2053, 213, 14, N'z orłem' UNION ALL 
SELECT 2054, 213, 15, N'ośle' UNION ALL 
SELECT 2055, 213, 16, N'ośle' UNION ALL 
SELECT 2056, 213, 19, N'orły' UNION ALL 
SELECT 2057, 213, 20, N'orłów' UNION ALL 
SELECT 2058, 213, 21, N'orłom' UNION ALL 
SELECT 2059, 213, 22, N'orły' UNION ALL 
SELECT 2060, 213, 23, N'z orłami' UNION ALL 
SELECT 2061, 213, 24, N'orłach' UNION ALL 
SELECT 2062, 213, 25, N'orły' UNION ALL 
SELECT 2063, 214, 10, N'jastrząb' UNION ALL 
SELECT 2064, 214, 11, N'jastrzębia' UNION ALL 
SELECT 2065, 214, 12, N'jastrzębiowi' UNION ALL 
SELECT 2066, 214, 13, N'jastrzębia' UNION ALL 
SELECT 2067, 214, 14, N'z jastrzębiem' UNION ALL 
SELECT 2068, 214, 15, N'jastrzębiu' UNION ALL 
SELECT 2069, 214, 16, N'jastrzębiu' UNION ALL 
SELECT 2070, 214, 19, N'jastrzębie' UNION ALL 
SELECT 2071, 214, 20, N'jastrzębi' UNION ALL 
SELECT 2072, 214, 21, N'jastrzębio,' UNION ALL 
SELECT 2073, 214, 22, N'jastrzębie' UNION ALL 
SELECT 2074, 214, 23, N'z jastrzębiami' UNION ALL 
SELECT 2075, 214, 24, N'jastrzębiach' UNION ALL 
SELECT 2076, 214, 25, N'jastrzębie' UNION ALL 
SELECT 2077, 215, 17, N'w Andy' UNION ALL 
SELECT 2078, 215, 18, N'w Andach' UNION ALL 
SELECT 2079, 215, 19, N'Andy' UNION ALL 
SELECT 2080, 215, 20, N'Andów' UNION ALL 
SELECT 2081, 215, 21, N'Andom' UNION ALL 
SELECT 2082, 215, 22, N'Andy' UNION ALL 
SELECT 2083, 215, 23, N'z Andami' UNION ALL 
SELECT 2084, 215, 24, N'Andach' UNION ALL 
SELECT 2085, 215, 25, N'Andy' UNION ALL 
SELECT 2086, 216, 17, N'w Himalaje' UNION ALL 
SELECT 2087, 216, 18, N'w Himalajach' UNION ALL 
SELECT 2088, 216, 19, N'Himalaje' UNION ALL 
SELECT 2089, 216, 20, N'Himalajów' UNION ALL 
SELECT 2090, 216, 21, N'Himalajom' UNION ALL 
SELECT 2091, 216, 22, N'Himalaje' UNION ALL 
SELECT 2092, 216, 23, N'z Himalajami' UNION ALL 
SELECT 2093, 216, 24, N'Himalajach' UNION ALL 
SELECT 2094, 216, 25, N'Himalaje' UNION ALL 
SELECT 2095, 217, 17, N'w Alpy' UNION ALL 
SELECT 2096, 217, 18, N'w Alpach' UNION ALL 
SELECT 2097, 217, 19, N'Alpy' UNION ALL 
SELECT 2098, 217, 20, N'Alp' UNION ALL 
SELECT 2099, 217, 21, N'Alpom' UNION ALL 
SELECT 2100, 217, 22, N'Alpy' UNION ALL 
SELECT 2101, 217, 23, N'z Alpami' UNION ALL 
SELECT 2102, 217, 24, N'Alpach' UNION ALL 
SELECT 2103, 217, 25, N'Alpy' UNION ALL 
SELECT 2104, 218, 10, N'Morze Śródziemne' UNION ALL 
SELECT 2105, 218, 11, N'Morza Śródziemnego' UNION ALL 
SELECT 2106, 218, 12, N'Morzu Śródziemnemu' UNION ALL 
SELECT 2107, 218, 13, N'Morze Śródziemne' UNION ALL 
SELECT 2108, 218, 14, N'z Morzem Śródziemnym' UNION ALL 
SELECT 2109, 218, 15, N'Morzu Śródziemnym' UNION ALL 
SELECT 2110, 218, 16, N'Morze Śródziemne' UNION ALL 
SELECT 2111, 218, 17, N'nad Morze Śródziemne' UNION ALL 
SELECT 2112, 218, 18, N'nad Morzem Śródziemnym' UNION ALL 
SELECT 2113, 219, 10, N'Ocean Atlantycki' UNION ALL 
SELECT 2114, 219, 11, N'Oceanu Atlantyckiego' UNION ALL 
SELECT 2115, 219, 12, N'Oceanowi Atlantyckiemu' UNION ALL 
SELECT 2116, 219, 13, N'Ocean Atlantycki' UNION ALL 
SELECT 2117, 219, 14, N'z Oceanem Atlantyckim' UNION ALL 
SELECT 2118, 219, 15, N'Oceanie Atlantyckim' UNION ALL 
SELECT 2119, 219, 16, N'Oceanie Atlantycki' UNION ALL 
SELECT 2120, 219, 17, N'nad Ocean Atlantycki' UNION ALL 
SELECT 2121, 219, 18, N'nad Oceanem Atlantyckim' UNION ALL 
SELECT 2122, 220, 10, N'Ocean Spokojny' UNION ALL 
SELECT 2123, 220, 11, N'Oceanu Spokojnego' UNION ALL 
SELECT 2124, 220, 12, N'Oceanowi Spokojnemu' UNION ALL 
SELECT 2125, 220, 13, N'Ocean Spokojny' UNION ALL 
SELECT 2126, 220, 14, N'z Oceanem Spokojnym' UNION ALL 
SELECT 2127, 220, 15, N'Oceanie Spokojnym' UNION ALL 
SELECT 2128, 220, 16, N'Oceanie Spokojny' UNION ALL 
SELECT 2129, 220, 17, N'nad Ocean Spokojny' UNION ALL 
SELECT 2130, 220, 18, N'nad Oceanem Spokojnym' UNION ALL 
SELECT 2131, 221, 10, N'Ocean Indyjski' UNION ALL 
SELECT 2132, 221, 11, N'Oceanu Indyjskiego' UNION ALL 
SELECT 2133, 221, 12, N'Oceanowi Indyjskiemu' UNION ALL 
SELECT 2134, 221, 13, N'Ocean Indyjski' UNION ALL 
SELECT 2135, 221, 14, N'z Oceanem Indyjskim' UNION ALL 
SELECT 2136, 221, 15, N'Oceanie Indyjskim' UNION ALL 
SELECT 2137, 221, 16, N'Oceanie Indyjski' UNION ALL 
SELECT 2138, 221, 17, N'nad Ocean Indyjski' UNION ALL 
SELECT 2139, 221, 18, N'nad Oceanem Indyjskim' UNION ALL 
SELECT 2140, 222, 10, N'Zatoka Perska' UNION ALL 
SELECT 2141, 222, 11, N'Zatoki Perskiej' UNION ALL 
SELECT 2142, 222, 12, N'Zatoce Perskiej' UNION ALL 
SELECT 2143, 222, 13, N'Zatokę Perską' UNION ALL 
SELECT 2144, 222, 14, N'z Zatoką Perską' UNION ALL 
SELECT 2145, 222, 15, N'Zatoce Perskiej' UNION ALL 
SELECT 2146, 222, 16, N'Zatoko Perska' UNION ALL 
SELECT 2147, 222, 17, N'nad Zatokę Perską' UNION ALL 
SELECT 2148, 222, 18, N'nad Zatoką Perską' UNION ALL 
SELECT 2149, 223, 10, N'Morze Bałtyckie' UNION ALL 
SELECT 2150, 223, 11, N'Morza Bałtyckiego' UNION ALL 
SELECT 2151, 223, 12, N'Morzu Bałtyckiemu' UNION ALL 
SELECT 2152, 223, 13, N'Morze Bałtyckie' UNION ALL 
SELECT 2153, 223, 14, N'z Morzem Bałtyckim' UNION ALL 
SELECT 2154, 223, 15, N'Morzu Bałtyckim' UNION ALL 
SELECT 2155, 223, 16, N'Morze Bałtyckie' UNION ALL 
SELECT 2156, 223, 17, N'nad Morze Bałtyckie' UNION ALL 
SELECT 2157, 223, 18, N'nad Morzem Bałtyckim' UNION ALL 
SELECT 2158, 224, 10, N'SardyniSardyni.a' UNION ALL 
SELECT 2159, 224, 11, N'SardyniSardyni.i' UNION ALL 
SELECT 2160, 224, 12, N'SardyniSardyni.i' UNION ALL 
SELECT 2161, 224, 13, N'SardyniSardyni.ę' UNION ALL 
SELECT 2162, 224, 14, N'z SardyniSardyni.ą' UNION ALL 
SELECT 2163, 224, 15, N'SardyniSardyni.i' UNION ALL 
SELECT 2164, 224, 16, N'SardyniSardyni.o' UNION ALL 
SELECT 2165, 224, 17, N'na SardyniSardyni.ę' UNION ALL 
SELECT 2166, 224, 18, N'na SardyniSardyni.i' UNION ALL 
SELECT 2167, 225, 10, N'Sycylia' UNION ALL 
SELECT 2168, 225, 11, N'Sycylii' UNION ALL 
SELECT 2169, 225, 12, N'Sycylii' UNION ALL 
SELECT 2170, 225, 13, N'Sycylię' UNION ALL 
SELECT 2171, 225, 14, N'z Sycylią' UNION ALL 
SELECT 2172, 225, 15, N'Sycylii' UNION ALL 
SELECT 2173, 225, 16, N'Sycylio' UNION ALL 
SELECT 2174, 225, 17, N'na Sycylię' UNION ALL 
SELECT 2175, 225, 18, N'na Sycylii' UNION ALL 
SELECT 2176, 226, 10, N'poniedziałek' UNION ALL 
SELECT 2177, 226, 11, N'poniedziałku' UNION ALL 
SELECT 2178, 226, 12, N'poniedziałkowi' UNION ALL 
SELECT 2179, 226, 13, N'poniedziałek' UNION ALL 
SELECT 2180, 226, 14, N'z poniedziałkiem' UNION ALL 
SELECT 2181, 226, 15, N'poniedziałku' UNION ALL 
SELECT 2182, 226, 16, N'poniedziałku' UNION ALL 
SELECT 2183, 226, 19, N'poniedziałki' UNION ALL 
SELECT 2184, 226, 20, N'poniedziałków' UNION ALL 
SELECT 2185, 226, 21, N'poniedziałkom' UNION ALL 
SELECT 2186, 226, 22, N'poniedziałki' UNION ALL 
SELECT 2187, 226, 23, N'z poniedziałkami' UNION ALL 
SELECT 2188, 226, 24, N'poniedziałkach' UNION ALL 
SELECT 2189, 226, 25, N'poniedziałki' UNION ALL 
SELECT 2190, 227, 10, N'wtorek' UNION ALL 
SELECT 2191, 227, 11, N'wtorku' UNION ALL 
SELECT 2192, 227, 12, N'wtorkowi' UNION ALL 
SELECT 2193, 227, 13, N'wtorek' UNION ALL 
SELECT 2194, 227, 14, N'z wtorkiem' UNION ALL 
SELECT 2195, 227, 15, N'wtorku' UNION ALL 
SELECT 2196, 227, 16, N'wtorku' UNION ALL 
SELECT 2197, 227, 19, N'wtorki' UNION ALL 
SELECT 2198, 227, 20, N'wtorków' UNION ALL 
SELECT 2199, 227, 21, N'wtorkom' UNION ALL 
SELECT 2200, 227, 22, N'wtorki' UNION ALL 
SELECT 2201, 227, 23, N'z wtorkami' UNION ALL 
SELECT 2202, 227, 24, N'wtorkach' UNION ALL 
SELECT 2203, 227, 25, N'wtorki' UNION ALL 
SELECT 2204, 228, 10, N'środa' UNION ALL 
SELECT 2205, 228, 11, N'środy' UNION ALL 
SELECT 2206, 228, 12, N'środzie' UNION ALL 
SELECT 2207, 228, 13, N'środę' UNION ALL 
SELECT 2208, 228, 14, N'ze środą' UNION ALL 
SELECT 2209, 228, 15, N'środzie' UNION ALL 
SELECT 2210, 228, 16, N'środo' UNION ALL 
SELECT 2211, 228, 19, N'środy' UNION ALL 
SELECT 2212, 228, 20, N'śród' UNION ALL 
SELECT 2213, 228, 21, N'środom' UNION ALL 
SELECT 2214, 228, 22, N'środy' UNION ALL 
SELECT 2215, 228, 23, N'ze środami' UNION ALL 
SELECT 2216, 228, 24, N'środach' UNION ALL 
SELECT 2217, 228, 25, N'środy' UNION ALL 
SELECT 2218, 229, 10, N'czwartek' UNION ALL 
SELECT 2219, 229, 11, N'czwartku' UNION ALL 
SELECT 2220, 229, 12, N'czwartkowi' UNION ALL 
SELECT 2221, 229, 13, N'czwartek' UNION ALL 
SELECT 2222, 229, 14, N'z czwartkiem' UNION ALL 
SELECT 2223, 229, 15, N'czwartku' UNION ALL 
SELECT 2224, 229, 16, N'czwartku' UNION ALL 
SELECT 2225, 229, 19, N'czwartki' UNION ALL 
SELECT 2226, 229, 20, N'czwartków' UNION ALL 
SELECT 2227, 229, 21, N'czwartkom' UNION ALL 
SELECT 2228, 229, 22, N'czwartki' UNION ALL 
SELECT 2229, 229, 23, N'z czwartkami' UNION ALL 
SELECT 2230, 229, 24, N'czwartkach' UNION ALL 
SELECT 2231, 229, 25, N'czwartki' UNION ALL 
SELECT 2232, 230, 10, N'piątek' UNION ALL 
SELECT 2233, 230, 11, N'piątku' UNION ALL 
SELECT 2234, 230, 12, N'piątkowi' UNION ALL 
SELECT 2235, 230, 13, N'piątek' UNION ALL 
SELECT 2236, 230, 14, N'z piątkiem' UNION ALL 
SELECT 2237, 230, 15, N'piątku' UNION ALL 
SELECT 2238, 230, 16, N'piątku' UNION ALL 
SELECT 2239, 230, 19, N'piątki' UNION ALL 
SELECT 2240, 230, 20, N'piątków' UNION ALL 
SELECT 2241, 230, 21, N'piątkom' UNION ALL 
SELECT 2242, 230, 22, N'piątki' UNION ALL 
SELECT 2243, 230, 23, N'z piątkami' UNION ALL 
SELECT 2244, 230, 24, N'piątkach' UNION ALL 
SELECT 2245, 230, 25, N'piątki' UNION ALL 
SELECT 2246, 231, 10, N'sobota' UNION ALL 
SELECT 2247, 231, 11, N'soboty' UNION ALL 
SELECT 2248, 231, 12, N'sobocie' UNION ALL 
SELECT 2249, 231, 13, N'sobotę' UNION ALL 
SELECT 2250, 231, 14, N'z sobotą' UNION ALL 
SELECT 2251, 231, 15, N'sobocie' UNION ALL 
SELECT 2252, 231, 16, N'soboto' UNION ALL 
SELECT 2253, 231, 19, N'soboty' UNION ALL 
SELECT 2254, 231, 20, N'sobót' UNION ALL 
SELECT 2255, 231, 21, N'sobotom' UNION ALL 
SELECT 2256, 231, 22, N'soboty' UNION ALL 
SELECT 2257, 231, 23, N'z sobotami' UNION ALL 
SELECT 2258, 231, 24, N'sobotach' UNION ALL 
SELECT 2259, 231, 25, N'soboty' UNION ALL 
SELECT 2260, 232, 10, N'niedziela' UNION ALL 
SELECT 2261, 232, 11, N'niedzieli' UNION ALL 
SELECT 2262, 232, 12, N'niedzieli' UNION ALL 
SELECT 2263, 232, 13, N'niedzielę' UNION ALL 
SELECT 2264, 232, 14, N'z niedzielą' UNION ALL 
SELECT 2265, 232, 15, N'niedzieli' UNION ALL 
SELECT 2266, 232, 16, N'niedzielo' UNION ALL 
SELECT 2267, 232, 19, N'niedziele' UNION ALL 
SELECT 2268, 232, 20, N'niedziel' UNION ALL 
SELECT 2269, 232, 21, N'niedzielom' UNION ALL 
SELECT 2270, 232, 22, N'niedziele' UNION ALL 
SELECT 2271, 232, 23, N'z niedzielami' UNION ALL 
SELECT 2272, 232, 24, N'niedzielach' UNION ALL 
SELECT 2273, 232, 25, N'niedziele' UNION ALL 
SELECT 2274, 233, 10, N'styczeń' UNION ALL 
SELECT 2275, 233, 11, N'stycznia' UNION ALL 
SELECT 2276, 233, 12, N'styczniowi' UNION ALL 
SELECT 2277, 233, 13, N'styczeń' UNION ALL 
SELECT 2278, 233, 14, N'ze styczniem' UNION ALL 
SELECT 2279, 233, 15, N'styczniu' UNION ALL 
SELECT 2280, 233, 16, N'styczniu' UNION ALL 
SELECT 2281, 233, 19, N'stycznie' UNION ALL 
SELECT 2282, 233, 20, N'styczni' UNION ALL 
SELECT 2283, 233, 21, N'styczniom' UNION ALL 
SELECT 2284, 233, 22, N'stycznie' UNION ALL 
SELECT 2285, 233, 23, N'ze styczniami' UNION ALL 
SELECT 2286, 233, 24, N'styczniach' UNION ALL 
SELECT 2287, 233, 25, N'stycznie' UNION ALL 
SELECT 2288, 234, 10, N'luty' UNION ALL 
SELECT 2289, 234, 11, N'lutego' UNION ALL 
SELECT 2290, 234, 12, N'lutemu' UNION ALL 
SELECT 2291, 234, 13, N'luty' UNION ALL 
SELECT 2292, 234, 14, N'z lutym' UNION ALL 
SELECT 2293, 234, 15, N'lutym' UNION ALL 
SELECT 2294, 234, 16, N'luty' UNION ALL 
SELECT 2295, 234, 19, N'lute' UNION ALL 
SELECT 2296, 234, 20, N'lutych' UNION ALL 
SELECT 2297, 234, 21, N'lutym' UNION ALL 
SELECT 2298, 234, 22, N'lute' UNION ALL 
SELECT 2299, 234, 23, N'z lutymi' UNION ALL 
SELECT 2300, 234, 24, N'lutych' UNION ALL 
SELECT 2301, 234, 25, N'lute' UNION ALL 
SELECT 2302, 235, 10, N'marzec' UNION ALL 
SELECT 2303, 235, 11, N'marca' UNION ALL 
SELECT 2304, 235, 12, N'marcowi' UNION ALL 
SELECT 2305, 235, 13, N'marzec' UNION ALL 
SELECT 2306, 235, 14, N'z marcem' UNION ALL 
SELECT 2307, 235, 15, N'marcu' UNION ALL 
SELECT 2308, 235, 16, N'marcu' UNION ALL 
SELECT 2309, 235, 19, N'marce' UNION ALL 
SELECT 2310, 235, 20, N'marców' UNION ALL 
SELECT 2311, 235, 21, N'marcom' UNION ALL 
SELECT 2312, 235, 22, N'marce' UNION ALL 
SELECT 2313, 235, 23, N'z marcami' UNION ALL 
SELECT 2314, 235, 24, N'marcach' UNION ALL 
SELECT 2315, 235, 25, N'marce' UNION ALL 
SELECT 2316, 236, 10, N'kwiecień' UNION ALL 
SELECT 2317, 236, 11, N'kwietnia' UNION ALL 
SELECT 2318, 236, 12, N'kwietniowi' UNION ALL 
SELECT 2319, 236, 13, N'kwiecień' UNION ALL 
SELECT 2320, 236, 14, N'z kwietniem' UNION ALL 
SELECT 2321, 236, 15, N'kwietniu' UNION ALL 
SELECT 2322, 236, 16, N'kwietniu' UNION ALL 
SELECT 2323, 236, 19, N'kwietnie' UNION ALL 
SELECT 2324, 236, 20, N'kwietni' UNION ALL 
SELECT 2325, 236, 21, N'kwietniom' UNION ALL 
SELECT 2326, 236, 22, N'kwietnie' UNION ALL 
SELECT 2327, 236, 23, N'z kwietniami' UNION ALL 
SELECT 2328, 236, 24, N'kwietniach' UNION ALL 
SELECT 2329, 236, 25, N'kwietnie' UNION ALL 
SELECT 2330, 237, 10, N'maj' UNION ALL 
SELECT 2331, 237, 11, N'maju' UNION ALL 
SELECT 2332, 237, 12, N'majowi' UNION ALL 
SELECT 2333, 237, 13, N'maj' UNION ALL 
SELECT 2334, 237, 14, N'z majem' UNION ALL 
SELECT 2335, 237, 15, N'maju' UNION ALL 
SELECT 2336, 237, 16, N'maju' UNION ALL 
SELECT 2337, 237, 19, N'maje' UNION ALL 
SELECT 2338, 237, 20, N'majów' UNION ALL 
SELECT 2339, 237, 21, N'majom' UNION ALL 
SELECT 2340, 237, 22, N'maje' UNION ALL 
SELECT 2341, 237, 23, N'z majami' UNION ALL 
SELECT 2342, 237, 24, N'majach' UNION ALL 
SELECT 2343, 237, 25, N'maje' UNION ALL 
SELECT 2344, 238, 10, N'czerwiec' UNION ALL 
SELECT 2345, 238, 11, N'czerwca' UNION ALL 
SELECT 2346, 238, 12, N'czerwcowi' UNION ALL 
SELECT 2347, 238, 13, N'czerwiec' UNION ALL 
SELECT 2348, 238, 14, N'z czerwcem' UNION ALL 
SELECT 2349, 238, 15, N'czerwcu' UNION ALL 
SELECT 2350, 238, 16, N'czerwcu' UNION ALL 
SELECT 2351, 238, 19, N'czerwce' UNION ALL 
SELECT 2352, 238, 20, N'czerwców' UNION ALL 
SELECT 2353, 238, 21, N'czerwcom' UNION ALL 
SELECT 2354, 238, 22, N'czerwce' UNION ALL 
SELECT 2355, 238, 23, N'z czerwcami' UNION ALL 
SELECT 2356, 238, 24, N'czerwcach' UNION ALL 
SELECT 2357, 238, 25, N'czerwce' UNION ALL 
SELECT 2358, 239, 10, N'lipiec' UNION ALL 
SELECT 2359, 239, 11, N'lipca' UNION ALL 
SELECT 2360, 239, 12, N'lipcowi' UNION ALL 
SELECT 2361, 239, 13, N'lipiec' UNION ALL 
SELECT 2362, 239, 14, N'z lipcem' UNION ALL 
SELECT 2363, 239, 15, N'lipcu' UNION ALL 
SELECT 2364, 239, 16, N'lipcu' UNION ALL 
SELECT 2365, 239, 19, N'lipce' UNION ALL 
SELECT 2366, 239, 20, N'lipców' UNION ALL 
SELECT 2367, 239, 21, N'lipcom' UNION ALL 
SELECT 2368, 239, 22, N'lipce' UNION ALL 
SELECT 2369, 239, 23, N'z lipcami' UNION ALL 
SELECT 2370, 239, 24, N'lipcach' UNION ALL 
SELECT 2371, 239, 25, N'lipce' UNION ALL 
SELECT 2372, 240, 10, N'sierpień' UNION ALL 
SELECT 2373, 240, 11, N'sierpnia' UNION ALL 
SELECT 2374, 240, 12, N'sierpniowi' UNION ALL 
SELECT 2375, 240, 13, N'sierpień' UNION ALL 
SELECT 2376, 240, 14, N'z sierpniem' UNION ALL 
SELECT 2377, 240, 15, N'sierpniu' UNION ALL 
SELECT 2378, 240, 16, N'sierpniu' UNION ALL 
SELECT 2379, 240, 19, N'sierpnie' UNION ALL 
SELECT 2380, 240, 20, N'sierpni' UNION ALL 
SELECT 2381, 240, 21, N'sierpniom' UNION ALL 
SELECT 2382, 240, 22, N'sierpnie' UNION ALL 
SELECT 2383, 240, 23, N'z sierpniami' UNION ALL 
SELECT 2384, 240, 24, N'sierpniach' UNION ALL 
SELECT 2385, 240, 25, N'sierpnie' UNION ALL 
SELECT 2386, 241, 10, N'wrzesień' UNION ALL 
SELECT 2387, 241, 11, N'września' UNION ALL 
SELECT 2388, 241, 12, N'wrześniowi' UNION ALL 
SELECT 2389, 241, 13, N'wrzesień' UNION ALL 
SELECT 2390, 241, 14, N'z wrześniem' UNION ALL 
SELECT 2391, 241, 15, N'wrześniu' UNION ALL 
SELECT 2392, 241, 16, N'wrześniu' UNION ALL 
SELECT 2393, 241, 19, N'wrześnie' UNION ALL 
SELECT 2394, 241, 20, N'wrześni' UNION ALL 
SELECT 2395, 241, 21, N'wrześniom' UNION ALL 
SELECT 2396, 241, 22, N'wrześnie' UNION ALL 
SELECT 2397, 241, 23, N'z wrześniami' UNION ALL 
SELECT 2398, 241, 24, N'wrześniach' UNION ALL 
SELECT 2399, 241, 25, N'wrześnie' UNION ALL 
SELECT 2400, 242, 10, N'październik' UNION ALL 
SELECT 2401, 242, 11, N'października' UNION ALL 
SELECT 2402, 242, 12, N'październikowi' UNION ALL 
SELECT 2403, 242, 13, N'październik' UNION ALL 
SELECT 2404, 242, 14, N'z październikiem' UNION ALL 
SELECT 2405, 242, 15, N'październiku' UNION ALL 
SELECT 2406, 242, 16, N'październiku' UNION ALL 
SELECT 2407, 242, 19, N'październiko' UNION ALL 
SELECT 2408, 242, 20, N'październików' UNION ALL 
SELECT 2409, 242, 21, N'październikom' UNION ALL 
SELECT 2410, 242, 22, N'październiki' UNION ALL 
SELECT 2411, 242, 23, N'z październikami' UNION ALL 
SELECT 2412, 242, 24, N'październikach' UNION ALL 
SELECT 2413, 242, 25, N'październiki' UNION ALL 
SELECT 2414, 243, 10, N'listopad' UNION ALL 
SELECT 2415, 243, 11, N'listopada' UNION ALL 
SELECT 2416, 243, 12, N'listopadowi' UNION ALL 
SELECT 2417, 243, 13, N'listopad' UNION ALL 
SELECT 2418, 243, 14, N'z listopadem' UNION ALL 
SELECT 2419, 243, 15, N'listopadzie' UNION ALL 
SELECT 2420, 243, 16, N'listopadzie' UNION ALL 
SELECT 2421, 243, 19, N'listopady' UNION ALL 
SELECT 2422, 243, 20, N'listopadów' UNION ALL 
SELECT 2423, 243, 21, N'listopadom' UNION ALL 
SELECT 2424, 243, 22, N'listopady' UNION ALL 
SELECT 2425, 243, 23, N'z listopadami' UNION ALL 
SELECT 2426, 243, 24, N'listopadach' UNION ALL 
SELECT 2427, 243, 25, N'listopady' UNION ALL 
SELECT 2428, 244, 10, N'grudzień' UNION ALL 
SELECT 2429, 244, 11, N'grudnia' UNION ALL 
SELECT 2430, 244, 12, N'grudniowi' UNION ALL 
SELECT 2431, 244, 13, N'grudzień' UNION ALL 
SELECT 2432, 244, 14, N'z grudniem' UNION ALL 
SELECT 2433, 244, 15, N'grudniu' UNION ALL 
SELECT 2434, 244, 16, N'grudniu' UNION ALL 
SELECT 2435, 244, 19, N'grudnie' UNION ALL 
SELECT 2436, 244, 20, N'grudni' UNION ALL 
SELECT 2437, 244, 21, N'grudniom' UNION ALL 
SELECT 2438, 244, 22, N'grudnie' UNION ALL 
SELECT 2439, 244, 23, N'z grudniami' UNION ALL 
SELECT 2440, 244, 24, N'grudniach' UNION ALL 
SELECT 2441, 244, 25, N'grudnie' UNION ALL 
SELECT 2442, 245, 10, N'rok' UNION ALL 
SELECT 2443, 245, 11, N'roku' UNION ALL 
SELECT 2444, 245, 12, N'rokowi' UNION ALL 
SELECT 2445, 245, 13, N'rok' UNION ALL 
SELECT 2446, 245, 14, N'zrokiem' UNION ALL 
SELECT 2447, 245, 15, N'roku' UNION ALL 
SELECT 2448, 245, 16, N'roku' UNION ALL 
SELECT 2449, 245, 19, N'lata' UNION ALL 
SELECT 2450, 245, 20, N'lat' UNION ALL 
SELECT 2451, 245, 21, N'latom' UNION ALL 
SELECT 2452, 245, 22, N'lata' UNION ALL 
SELECT 2453, 245, 23, N'z latami' UNION ALL 
SELECT 2454, 245, 24, N'latach' UNION ALL 
SELECT 2455, 245, 25, N'lata' UNION ALL 
SELECT 2456, 246, 10, N'miesiąc' UNION ALL 
SELECT 2457, 246, 11, N'miesiąca' UNION ALL 
SELECT 2458, 246, 12, N'miesiącowi' UNION ALL 
SELECT 2459, 246, 13, N'miesiąc' UNION ALL 
SELECT 2460, 246, 14, N'z miesiącem' UNION ALL 
SELECT 2461, 246, 15, N'miesiącu' UNION ALL 
SELECT 2462, 246, 16, N'miesiącu' UNION ALL 
SELECT 2463, 246, 19, N'miesiące' UNION ALL 
SELECT 2464, 246, 20, N'miesięcy' UNION ALL 
SELECT 2465, 246, 21, N'miesiącom' UNION ALL 
SELECT 2466, 246, 22, N'miesiące' UNION ALL 
SELECT 2467, 246, 23, N'z miesiącami' UNION ALL 
SELECT 2468, 246, 24, N'miesiącach' UNION ALL 
SELECT 2469, 246, 25, N'miesiące' UNION ALL 
SELECT 2470, 247, 10, N'dzień' UNION ALL 
SELECT 2471, 247, 11, N'dnia' UNION ALL 
SELECT 2472, 247, 12, N'dniowi' UNION ALL 
SELECT 2473, 247, 13, N'dzień' UNION ALL 
SELECT 2474, 247, 14, N'z dniem' UNION ALL 
SELECT 2475, 247, 15, N'dniu' UNION ALL 
SELECT 2476, 247, 16, N'dniu' UNION ALL 
SELECT 2477, 247, 19, N'dni' UNION ALL 
SELECT 2478, 247, 20, N'dni' UNION ALL 
SELECT 2479, 247, 21, N'dniom' UNION ALL 
SELECT 2480, 247, 22, N'dni' UNION ALL 
SELECT 2481, 247, 23, N'z dniami' UNION ALL 
SELECT 2482, 247, 24, N'dniach' UNION ALL 
SELECT 2483, 247, 25, N'dni' UNION ALL 
SELECT 2484, 248, 10, N'tydzień' UNION ALL 
SELECT 2485, 248, 11, N'tygodnia' UNION ALL 
SELECT 2486, 248, 12, N'tygodniowi' UNION ALL 
SELECT 2487, 248, 13, N'tydzień' UNION ALL 
SELECT 2488, 248, 14, N'z tygodniem' UNION ALL 
SELECT 2489, 248, 15, N'tygodniu' UNION ALL 
SELECT 2490, 248, 16, N'tygodniu' UNION ALL 
SELECT 2491, 248, 19, N'tygodnie' UNION ALL 
SELECT 2492, 248, 20, N'tygodni' UNION ALL 
SELECT 2493, 248, 21, N'tygodniom' UNION ALL 
SELECT 2494, 248, 22, N'tygodnie' UNION ALL 
SELECT 2495, 248, 23, N'z tygodniami' UNION ALL 
SELECT 2496, 248, 24, N'tygodniach' UNION ALL 
SELECT 2497, 248, 25, N'tygodni' UNION ALL 
SELECT 2498, 249, 10, N'godzina' UNION ALL 
SELECT 2499, 249, 11, N'godziny' UNION ALL 
SELECT 2500, 249, 12, N'godzinie' UNION ALL 
SELECT 2501, 249, 13, N'godzinę' UNION ALL 
SELECT 2502, 249, 14, N'z godziną' UNION ALL 
SELECT 2503, 249, 15, N'godzinie' UNION ALL 
SELECT 2504, 249, 16, N'godzino' UNION ALL 
SELECT 2505, 249, 19, N'godziny' UNION ALL 
SELECT 2506, 249, 20, N'godzin' UNION ALL 
SELECT 2507, 249, 21, N'godzinom' UNION ALL 
SELECT 2508, 249, 22, N'godziny' UNION ALL 
SELECT 2509, 249, 23, N'z godzinami' UNION ALL 
SELECT 2510, 249, 24, N'godzinach' UNION ALL 
SELECT 2511, 249, 25, N'godziny' UNION ALL 
SELECT 2512, 250, 10, N'minuta' UNION ALL 
SELECT 2513, 250, 11, N'minuty' UNION ALL 
SELECT 2514, 250, 12, N'minucie' UNION ALL 
SELECT 2515, 250, 13, N'minutę' UNION ALL 
SELECT 2516, 250, 14, N'z minutą' UNION ALL 
SELECT 2517, 250, 15, N'minucie' UNION ALL 
SELECT 2518, 250, 16, N'minuto' UNION ALL 
SELECT 2519, 250, 19, N'minuty' UNION ALL 
SELECT 2520, 250, 20, N'minut' UNION ALL 
SELECT 2521, 250, 21, N'minutom' UNION ALL 
SELECT 2522, 250, 22, N'minuty' UNION ALL 
SELECT 2523, 250, 23, N'z minutami' UNION ALL 
SELECT 2524, 250, 24, N'minutach' UNION ALL 
SELECT 2525, 250, 25, N'minuty' UNION ALL 
SELECT 2526, 251, 10, N'sekunda' UNION ALL 
SELECT 2527, 251, 11, N'sekundy' UNION ALL 
SELECT 2528, 251, 12, N'sekundzie' UNION ALL 
SELECT 2529, 251, 13, N'sekundę' UNION ALL 
SELECT 2530, 251, 14, N'z sekundą' UNION ALL 
SELECT 2531, 251, 15, N'sekundzie' UNION ALL 
SELECT 2532, 251, 16, N'sekundo' UNION ALL 
SELECT 2533, 251, 19, N'sekundy' UNION ALL 
SELECT 2534, 251, 20, N'sekund' UNION ALL 
SELECT 2535, 251, 21, N'sekundom' UNION ALL 
SELECT 2536, 251, 22, N'sekundy' UNION ALL 
SELECT 2537, 251, 23, N'z sekundami' UNION ALL 
SELECT 2538, 251, 24, N'sekundach' UNION ALL 
SELECT 2539, 251, 25, N'sekundy' UNION ALL 
SELECT 2540, 252, 10, N'weekend' UNION ALL 
SELECT 2541, 252, 11, N'weekendu' UNION ALL 
SELECT 2542, 252, 12, N'weekendowi' UNION ALL 
SELECT 2543, 252, 13, N'weekend' UNION ALL 
SELECT 2544, 252, 14, N'z weekendem' UNION ALL 
SELECT 2545, 252, 15, N'weekendzie' UNION ALL 
SELECT 2546, 252, 16, N'weekendzie' UNION ALL 
SELECT 2547, 252, 19, N'weekendy' UNION ALL 
SELECT 2548, 252, 20, N'weekendów' UNION ALL 
SELECT 2549, 252, 21, N'weekendom' UNION ALL 
SELECT 2550, 252, 22, N'weekendy' UNION ALL 
SELECT 2551, 252, 23, N'z weekendami' UNION ALL 
SELECT 2552, 252, 24, N'weekendach' UNION ALL 
SELECT 2553, 252, 25, N'weekendy' UNION ALL 
SELECT 2554, 253, 10, N'jutro' UNION ALL 
SELECT 2555, 253, 11, N'jutra' UNION ALL 
SELECT 2556, 253, 12, N'jutru' UNION ALL 
SELECT 2557, 253, 13, N'jutro' UNION ALL 
SELECT 2558, 253, 14, N'z jutrem' UNION ALL 
SELECT 2559, 253, 15, N'jutrze' UNION ALL 
SELECT 2560, 253, 16, N'jutro' UNION ALL 
SELECT 2561, 254, 10, N'dzisiaj' UNION ALL 
SELECT 2562, 254, 11, N'dzisiaj' UNION ALL 
SELECT 2563, 254, 12, N'dzisiaj' UNION ALL 
SELECT 2564, 254, 13, N'dzisiaj' UNION ALL 
SELECT 2565, 254, 14, N'z dzisiaj' UNION ALL 
SELECT 2566, 254, 15, N'dzisiaj' UNION ALL 
SELECT 2567, 254, 16, N'dzisiaj' UNION ALL 
SELECT 2568, 255, 10, N'wczoraj' UNION ALL 
SELECT 2569, 255, 11, N'wczoraj' UNION ALL 
SELECT 2570, 255, 12, N'wczoraj' UNION ALL 
SELECT 2571, 255, 13, N'wczoraj' UNION ALL 
SELECT 2572, 255, 14, N'z wczoraj' UNION ALL 
SELECT 2573, 255, 15, N'wczoraj' UNION ALL 
SELECT 2574, 255, 16, N'wczoraj' UNION ALL 
SELECT 2575, 256, 10, N'żółw' UNION ALL 
SELECT 2576, 256, 11, N'żółwia' UNION ALL 
SELECT 2577, 256, 12, N'żółwiowi' UNION ALL 
SELECT 2578, 256, 13, N'żółwia' UNION ALL 
SELECT 2579, 256, 14, N'z żółwiem' UNION ALL 
SELECT 2580, 256, 15, N'żółwiu' UNION ALL 
SELECT 2581, 256, 16, N'żółwiu' UNION ALL 
SELECT 2582, 256, 19, N'żółwie' UNION ALL 
SELECT 2583, 256, 20, N'żółwi' UNION ALL 
SELECT 2584, 256, 21, N'żółwiom' UNION ALL 
SELECT 2585, 256, 22, N'żółwie' UNION ALL 
SELECT 2586, 256, 23, N'z żółwiami' UNION ALL 
SELECT 2587, 256, 24, N'żółwiach' UNION ALL 
SELECT 2588, 256, 25, N'żółwie' UNION ALL 
SELECT 2589, 257, 10, N'krokodyl' UNION ALL 
SELECT 2590, 257, 11, N'krokodyla' UNION ALL 
SELECT 2591, 257, 12, N'krokodylowi' UNION ALL 
SELECT 2592, 257, 13, N'krokodyla' UNION ALL 
SELECT 2593, 257, 14, N'z krokodylem' UNION ALL 
SELECT 2594, 257, 15, N'krokodylu' UNION ALL 
SELECT 2595, 257, 16, N'krokodylu' UNION ALL 
SELECT 2596, 257, 19, N'krokodyle' UNION ALL 
SELECT 2597, 257, 20, N'krokodyli' UNION ALL 
SELECT 2598, 257, 21, N'krokodylom' UNION ALL 
SELECT 2599, 257, 22, N'krokodyle' UNION ALL 
SELECT 2600, 257, 23, N'z krokodylami' UNION ALL 
SELECT 2601, 257, 24, N'krokodylach' UNION ALL 
SELECT 2602, 257, 25, N'krokodyle' UNION ALL 
SELECT 2603, 258, 10, N'kangur' UNION ALL 
SELECT 2604, 258, 11, N'kangura' UNION ALL 
SELECT 2605, 258, 12, N'kangurowi' UNION ALL 
SELECT 2606, 258, 13, N'kangura' UNION ALL 
SELECT 2607, 258, 14, N'z kangurem' UNION ALL 
SELECT 2608, 258, 15, N'kangurze' UNION ALL 
SELECT 2609, 258, 16, N'kangurze' UNION ALL 
SELECT 2610, 258, 19, N'kangury' UNION ALL 
SELECT 2611, 258, 20, N'kangurów' UNION ALL 
SELECT 2612, 258, 21, N'kangurom' UNION ALL 
SELECT 2613, 258, 22, N'kangury' UNION ALL 
SELECT 2614, 258, 23, N'z kangurami' UNION ALL 
SELECT 2615, 258, 24, N'kangurach' UNION ALL 
SELECT 2616, 258, 25, N'kangury' UNION ALL 
SELECT 2617, 259, 10, N'gad' UNION ALL 
SELECT 2618, 259, 11, N'gada' UNION ALL 
SELECT 2619, 259, 12, N'gadowi' UNION ALL 
SELECT 2620, 259, 13, N'gada' UNION ALL 
SELECT 2621, 259, 14, N'z gadem' UNION ALL 
SELECT 2622, 259, 15, N'gadzie' UNION ALL 
SELECT 2623, 259, 16, N'gadzie' UNION ALL 
SELECT 2624, 259, 19, N'gady' UNION ALL 
SELECT 2625, 259, 20, N'gadów' UNION ALL 
SELECT 2626, 259, 21, N'gadom' UNION ALL 
SELECT 2627, 259, 22, N'gady' UNION ALL 
SELECT 2628, 259, 23, N'z gadami' UNION ALL 
SELECT 2629, 259, 24, N'gadach' UNION ALL 
SELECT 2630, 259, 25, N'gady' UNION ALL 
SELECT 2631, 260, 10, N'płaz' UNION ALL 
SELECT 2632, 260, 11, N'płaza' UNION ALL 
SELECT 2633, 260, 12, N'płazowi' UNION ALL 
SELECT 2634, 260, 13, N'płaza' UNION ALL 
SELECT 2635, 260, 14, N'z płazem' UNION ALL 
SELECT 2636, 260, 15, N'płazie' UNION ALL 
SELECT 2637, 260, 16, N'płazie' UNION ALL 
SELECT 2638, 260, 19, N'płazy' UNION ALL 
SELECT 2639, 260, 20, N'płazów' UNION ALL 
SELECT 2640, 260, 21, N'płazom' UNION ALL 
SELECT 2641, 260, 22, N'płazy' UNION ALL 
SELECT 2642, 260, 23, N'z płazami' UNION ALL 
SELECT 2643, 260, 24, N'płazach' UNION ALL 
SELECT 2644, 260, 25, N'płazy' UNION ALL 
SELECT 2645, 261, 10, N'ssak' UNION ALL 
SELECT 2646, 261, 11, N'ssaka' UNION ALL 
SELECT 2647, 261, 12, N'ssakowi' UNION ALL 
SELECT 2648, 261, 13, N'ssaka' UNION ALL 
SELECT 2649, 261, 14, N'ze ssakiem' UNION ALL 
SELECT 2650, 261, 15, N'ssaku' UNION ALL 
SELECT 2651, 261, 16, N'ssaku' UNION ALL 
SELECT 2652, 261, 19, N'ssaki' UNION ALL 
SELECT 2653, 261, 20, N'ssaków' UNION ALL 
SELECT 2654, 261, 21, N'ssakom' UNION ALL 
SELECT 2655, 261, 22, N'ssaki' UNION ALL 
SELECT 2656, 261, 23, N'ze ssakami' UNION ALL 
SELECT 2657, 261, 24, N'ssakach' UNION ALL 
SELECT 2658, 261, 25, N'ssaki' UNION ALL 
SELECT 2659, 262, 10, N'robak' UNION ALL 
SELECT 2660, 262, 11, N'robaka' UNION ALL 
SELECT 2661, 262, 12, N'robakowi' UNION ALL 
SELECT 2662, 262, 13, N'robaka' UNION ALL 
SELECT 2663, 262, 14, N'z robakiem' UNION ALL 
SELECT 2664, 262, 15, N'robaku' UNION ALL 
SELECT 2665, 262, 16, N'robaku' UNION ALL 
SELECT 2666, 262, 19, N'robaki' UNION ALL 
SELECT 2667, 262, 20, N'robaków' UNION ALL 
SELECT 2668, 262, 21, N'robakom' UNION ALL 
SELECT 2669, 262, 22, N'robaki' UNION ALL 
SELECT 2670, 262, 23, N'z robakami' UNION ALL 
SELECT 2671, 262, 24, N'robakach' UNION ALL 
SELECT 2672, 262, 25, N'robaki' UNION ALL 
SELECT 2673, 263, 10, N'owad' UNION ALL 
SELECT 2674, 263, 11, N'owada' UNION ALL 
SELECT 2675, 263, 12, N'owadowi' UNION ALL 
SELECT 2676, 263, 13, N'owada' UNION ALL 
SELECT 2677, 263, 14, N'z owadem' UNION ALL 
SELECT 2678, 263, 15, N'owadzie' UNION ALL 
SELECT 2679, 263, 16, N'owadzie' UNION ALL 
SELECT 2680, 263, 19, N'owady' UNION ALL 
SELECT 2681, 263, 20, N'owadów' UNION ALL 
SELECT 2682, 263, 21, N'owadom' UNION ALL 
SELECT 2683, 263, 22, N'owady' UNION ALL 
SELECT 2684, 263, 23, N'z owadami' UNION ALL 
SELECT 2685, 263, 24, N'owadach' UNION ALL 
SELECT 2686, 263, 25, N'owady' UNION ALL 
SELECT 2687, 264, 10, N'jabłko' UNION ALL 
SELECT 2688, 264, 11, N'jabłka' UNION ALL 
SELECT 2689, 264, 12, N'jabłku' UNION ALL 
SELECT 2690, 264, 13, N'jabłko' UNION ALL 
SELECT 2691, 264, 14, N'z jabłkiem' UNION ALL 
SELECT 2692, 264, 15, N'jabłku' UNION ALL 
SELECT 2693, 264, 16, N'jabłko' UNION ALL 
SELECT 2694, 264, 19, N'jabłka' UNION ALL 
SELECT 2695, 264, 20, N'jabłek' UNION ALL 
SELECT 2696, 264, 21, N'jabłkom' UNION ALL 
SELECT 2697, 264, 22, N'jabłka' UNION ALL 
SELECT 2698, 264, 23, N'z jabłkami' UNION ALL 
SELECT 2699, 264, 24, N'jabłkach' UNION ALL 
SELECT 2700, 264, 25, N'jabłka' UNION ALL 
SELECT 2701, 265, 10, N'gruszka' UNION ALL 
SELECT 2702, 265, 11, N'gruszki' UNION ALL 
SELECT 2703, 265, 12, N'gruszce' UNION ALL 
SELECT 2704, 265, 13, N'gruszkę' UNION ALL 
SELECT 2705, 265, 14, N'z gruszką' UNION ALL 
SELECT 2706, 265, 15, N'gruszce' UNION ALL 
SELECT 2707, 265, 16, N'gruszko' UNION ALL 
SELECT 2708, 265, 19, N'gruszki' UNION ALL 
SELECT 2709, 265, 20, N'gruszek' UNION ALL 
SELECT 2710, 265, 21, N'gruszkom' UNION ALL 
SELECT 2711, 265, 22, N'gruszki' UNION ALL 
SELECT 2712, 265, 23, N'z gruszkami' UNION ALL 
SELECT 2713, 265, 24, N'gruszkach' UNION ALL 
SELECT 2714, 265, 25, N'gruszki' UNION ALL 
SELECT 2715, 266, 10, N'wiśnia' UNION ALL 
SELECT 2716, 266, 11, N'wiśni' UNION ALL 
SELECT 2717, 266, 12, N'wiśni' UNION ALL 
SELECT 2718, 266, 13, N'wiśnię' UNION ALL 
SELECT 2719, 266, 14, N'z wiśnią' UNION ALL 
SELECT 2720, 266, 15, N'wiśni' UNION ALL 
SELECT 2721, 266, 16, N'wiśnio' UNION ALL 
SELECT 2722, 266, 19, N'wiśnie' UNION ALL 
SELECT 2723, 266, 20, N'wiśni' UNION ALL 
SELECT 2724, 266, 21, N'wiśniom' UNION ALL 
SELECT 2725, 266, 22, N'wiśnie' UNION ALL 
SELECT 2726, 266, 23, N'z wiśniami' UNION ALL 
SELECT 2727, 266, 24, N'wiśniach' UNION ALL 
SELECT 2728, 266, 25, N'wiśnie' UNION ALL 
SELECT 2729, 267, 10, N'truskawka' UNION ALL 
SELECT 2730, 267, 11, N'truskawki' UNION ALL 
SELECT 2731, 267, 12, N'truskawce' UNION ALL 
SELECT 2732, 267, 13, N'truskawkę' UNION ALL 
SELECT 2733, 267, 14, N'z truskawką' UNION ALL 
SELECT 2734, 267, 15, N'truskawce' UNION ALL 
SELECT 2735, 267, 16, N'truskawko' UNION ALL 
SELECT 2736, 267, 19, N'truskawki' UNION ALL 
SELECT 2737, 267, 20, N'truskawek' UNION ALL 
SELECT 2738, 267, 21, N'truskawkom' UNION ALL 
SELECT 2739, 267, 22, N'truskawki' UNION ALL 
SELECT 2740, 267, 23, N'z truskawkami' UNION ALL 
SELECT 2741, 267, 24, N'truskawkach' UNION ALL 
SELECT 2742, 267, 25, N'truskawki' UNION ALL 
SELECT 2743, 268, 10, N'ananas' UNION ALL 
SELECT 2744, 268, 11, N'ananasa' UNION ALL 
SELECT 2745, 268, 12, N'ananasowi' UNION ALL 
SELECT 2746, 268, 13, N'ananasa' UNION ALL 
SELECT 2747, 268, 14, N'z ananasem' UNION ALL 
SELECT 2748, 268, 15, N'ananasie' UNION ALL 
SELECT 2749, 268, 16, N'ananasie' UNION ALL 
SELECT 2750, 268, 19, N'ananasy' UNION ALL 
SELECT 2751, 268, 20, N'ananasów' UNION ALL 
SELECT 2752, 268, 21, N'ananasom' UNION ALL 
SELECT 2753, 268, 22, N'ananasy' UNION ALL 
SELECT 2754, 268, 23, N'z ananasami' UNION ALL 
SELECT 2755, 268, 24, N'ananasach' UNION ALL 
SELECT 2756, 268, 25, N'ananasy' UNION ALL 
SELECT 2757, 269, 10, N'pomarańcza' UNION ALL 
SELECT 2758, 269, 11, N'pomarańczy' UNION ALL 
SELECT 2759, 269, 12, N'pomarańczy' UNION ALL 
SELECT 2760, 269, 13, N'pomarańczę' UNION ALL 
SELECT 2761, 269, 14, N'z pomarańczą' UNION ALL 
SELECT 2762, 269, 15, N'pomarańczy' UNION ALL 
SELECT 2763, 269, 16, N'pomarańczo' UNION ALL 
SELECT 2764, 269, 19, N'pomarańcze' UNION ALL 
SELECT 2765, 269, 20, N'pomarańczy' UNION ALL 
SELECT 2766, 269, 21, N'pomarańczom' UNION ALL 
SELECT 2767, 269, 22, N'pomarańcze' UNION ALL 
SELECT 2768, 269, 23, N'z pomarańczami' UNION ALL 
SELECT 2769, 269, 24, N'pomarańczach' UNION ALL 
SELECT 2770, 269, 25, N'pomarańcze' UNION ALL 
SELECT 2771, 270, 10, N'czereśnia' UNION ALL 
SELECT 2772, 270, 11, N'czereśni' UNION ALL 
SELECT 2773, 270, 12, N'czereśni' UNION ALL 
SELECT 2774, 270, 13, N'czereśnię' UNION ALL 
SELECT 2775, 270, 14, N'z czereśnią' UNION ALL 
SELECT 2776, 270, 15, N'czereśni' UNION ALL 
SELECT 2777, 270, 16, N'czereśnio' UNION ALL 
SELECT 2778, 270, 19, N'czereśnie' UNION ALL 
SELECT 2779, 270, 20, N'czereśni' UNION ALL 
SELECT 2780, 270, 21, N'czereśniom' UNION ALL 
SELECT 2781, 270, 22, N'czereśnie' UNION ALL 
SELECT 2782, 270, 23, N'z czereśniami' UNION ALL 
SELECT 2783, 270, 24, N'czereśniach' UNION ALL 
SELECT 2784, 270, 25, N'czereśnie' UNION ALL 
SELECT 2785, 271, 10, N'porzeczka' UNION ALL 
SELECT 2786, 271, 11, N'porzeczki' UNION ALL 
SELECT 2787, 271, 12, N'porzeczce' UNION ALL 
SELECT 2788, 271, 13, N'porzeczkę' UNION ALL 
SELECT 2789, 271, 14, N'z porzeczką' UNION ALL 
SELECT 2790, 271, 15, N'porzeczce' UNION ALL 
SELECT 2791, 271, 16, N'porzeczko' UNION ALL 
SELECT 2792, 271, 19, N'porzeczki' UNION ALL 
SELECT 2793, 271, 20, N'porzeczek' UNION ALL 
SELECT 2794, 271, 21, N'porzeczkom' UNION ALL 
SELECT 2795, 271, 22, N'porzeczki' UNION ALL 
SELECT 2796, 271, 23, N'z porzeczkami' UNION ALL 
SELECT 2797, 271, 24, N'porzeczkach' UNION ALL 
SELECT 2798, 271, 25, N'porzeczki' UNION ALL 
SELECT 2799, 272, 10, N'malina' UNION ALL 
SELECT 2800, 272, 11, N'maliny' UNION ALL 
SELECT 2801, 272, 12, N'malinie' UNION ALL 
SELECT 2802, 272, 13, N'malinę' UNION ALL 
SELECT 2803, 272, 14, N'z maliną' UNION ALL 
SELECT 2804, 272, 15, N'malinie' UNION ALL 
SELECT 2805, 272, 16, N'malino' UNION ALL 
SELECT 2806, 272, 19, N'maliny' UNION ALL 
SELECT 2807, 272, 20, N'malin' UNION ALL 
SELECT 2808, 272, 21, N'malinom' UNION ALL 
SELECT 2809, 272, 22, N'maliny' UNION ALL 
SELECT 2810, 272, 23, N'z malinami' UNION ALL 
SELECT 2811, 272, 24, N'malinach' UNION ALL 
SELECT 2812, 272, 25, N'maliny' UNION ALL 
SELECT 2813, 273, 10, N'banan' UNION ALL 
SELECT 2814, 273, 11, N'banana' UNION ALL 
SELECT 2815, 273, 12, N'bananowi' UNION ALL 
SELECT 2816, 273, 13, N'banana' UNION ALL 
SELECT 2817, 273, 14, N'z bananem' UNION ALL 
SELECT 2818, 273, 15, N'bananie' UNION ALL 
SELECT 2819, 273, 16, N'bananie' UNION ALL 
SELECT 2820, 273, 19, N'banany' UNION ALL 
SELECT 2821, 273, 20, N'bananów' UNION ALL 
SELECT 2822, 273, 21, N'bananom' UNION ALL 
SELECT 2823, 273, 22, N'banany' UNION ALL 
SELECT 2824, 273, 23, N'z bananami' UNION ALL 
SELECT 2825, 273, 24, N'bananach' UNION ALL 
SELECT 2826, 273, 25, N'banany' UNION ALL 
SELECT 2827, 274, 10, N'ręka' UNION ALL 
SELECT 2828, 274, 11, N'ręki' UNION ALL 
SELECT 2829, 274, 12, N'ręce' UNION ALL 
SELECT 2830, 274, 13, N'rękę' UNION ALL 
SELECT 2831, 274, 14, N'z ręką' UNION ALL 
SELECT 2832, 274, 15, N'ręce' UNION ALL 
SELECT 2833, 274, 16, N'ręko' UNION ALL 
SELECT 2834, 274, 19, N'ręce' UNION ALL 
SELECT 2835, 274, 20, N'rąk' UNION ALL 
SELECT 2836, 274, 21, N'rękom' UNION ALL 
SELECT 2837, 274, 22, N'ręce' UNION ALL 
SELECT 2838, 274, 23, N'z rękoma' UNION ALL 
SELECT 2839, 274, 24, N'rękach' UNION ALL 
SELECT 2840, 274, 25, N'ręce' UNION ALL 
SELECT 2841, 275, 10, N'książka' UNION ALL 
SELECT 2842, 275, 11, N'książki' UNION ALL 
SELECT 2843, 275, 12, N'książce' UNION ALL 
SELECT 2844, 275, 13, N'książkę' UNION ALL 
SELECT 2845, 275, 14, N'z książką' UNION ALL 
SELECT 2846, 275, 15, N'książce' UNION ALL 
SELECT 2847, 275, 16, N'książko' UNION ALL 
SELECT 2848, 275, 19, N'książki' UNION ALL 
SELECT 2849, 275, 20, N'książek' UNION ALL 
SELECT 2850, 275, 21, N'książkom' UNION ALL 
SELECT 2851, 275, 22, N'książki' UNION ALL 
SELECT 2852, 275, 23, N'z książkami' UNION ALL 
SELECT 2853, 275, 24, N'książkach' UNION ALL 
SELECT 2854, 275, 25, N'książki' UNION ALL 
SELECT 2855, 276, 10, N'gra' UNION ALL 
SELECT 2856, 276, 11, N'gry' UNION ALL 
SELECT 2857, 276, 12, N'grze' UNION ALL 
SELECT 2858, 276, 13, N'grę' UNION ALL 
SELECT 2859, 276, 14, N'z grą' UNION ALL 
SELECT 2860, 276, 15, N'grze' UNION ALL 
SELECT 2861, 276, 16, N'gro' UNION ALL 
SELECT 2862, 276, 19, N'gry' UNION ALL 
SELECT 2863, 276, 20, N'gier' UNION ALL 
SELECT 2864, 276, 21, N'grom' UNION ALL 
SELECT 2865, 276, 22, N'gry' UNION ALL 
SELECT 2866, 276, 23, N'z grami' UNION ALL 
SELECT 2867, 276, 24, N'grach' UNION ALL 
SELECT 2868, 276, 25, N'gry' UNION ALL 
SELECT 2869, 277, 10, N'produkt' UNION ALL 
SELECT 2870, 277, 11, N'produktu' UNION ALL 
SELECT 2871, 277, 12, N'produktowi' UNION ALL 
SELECT 2872, 277, 13, N'produkt' UNION ALL 
SELECT 2873, 277, 14, N'z produktem' UNION ALL 
SELECT 2874, 277, 15, N'produkcie' UNION ALL 
SELECT 2875, 277, 16, N'produkcie' UNION ALL 
SELECT 2876, 277, 19, N'produkty' UNION ALL 
SELECT 2877, 277, 20, N'produktów' UNION ALL 
SELECT 2878, 277, 21, N'produktom' UNION ALL 
SELECT 2879, 277, 22, N'produkty' UNION ALL 
SELECT 2880, 277, 23, N'z produktami' UNION ALL 
SELECT 2881, 277, 24, N'produktach' UNION ALL 
SELECT 2882, 277, 25, N'produkty' UNION ALL 
SELECT 2883, 278, 10, N'samochód' UNION ALL 
SELECT 2884, 278, 11, N'samochodu' UNION ALL 
SELECT 2885, 278, 12, N'samochodowi' UNION ALL 
SELECT 2886, 278, 13, N'samochód' UNION ALL 
SELECT 2887, 278, 14, N'z samochodem' UNION ALL 
SELECT 2888, 278, 15, N'samochodzie' UNION ALL 
SELECT 2889, 278, 16, N'samochodzie' UNION ALL 
SELECT 2890, 278, 19, N'samochody' UNION ALL 
SELECT 2891, 278, 20, N'samochodów' UNION ALL 
SELECT 2892, 278, 21, N'samochodom' UNION ALL 
SELECT 2893, 278, 22, N'samochody' UNION ALL 
SELECT 2894, 278, 23, N'z samochodami' UNION ALL 
SELECT 2895, 278, 24, N'samochodach' UNION ALL 
SELECT 2896, 278, 25, N'samochody' UNION ALL 
SELECT 2897, 279, 10, N'oprogramowanie' UNION ALL 
SELECT 2898, 279, 11, N'oprogramowania' UNION ALL 
SELECT 2899, 279, 12, N'oprogramowaniu' UNION ALL 
SELECT 2900, 279, 13, N'oprogramowanie' UNION ALL 
SELECT 2901, 279, 14, N'z oprogramowaniem' UNION ALL 
SELECT 2902, 279, 15, N'oprogramowaniu' UNION ALL 
SELECT 2903, 279, 16, N'oprogramowanie' UNION ALL 
SELECT 2904, 279, 19, N'oprogramowania' UNION ALL 
SELECT 2905, 279, 20, N'oprogramowań' UNION ALL 
SELECT 2906, 279, 21, N'oprogramowaniom' UNION ALL 
SELECT 2907, 279, 22, N'oprogramowania' UNION ALL 
SELECT 2908, 279, 23, N'z oprogramowaniami' UNION ALL 
SELECT 2909, 279, 24, N'oprogramowaniach' UNION ALL 
SELECT 2910, 279, 25, N'oprogramowania' UNION ALL 
SELECT 2911, 280, 10, N'telewizja' UNION ALL 
SELECT 2912, 280, 11, N'telewizji' UNION ALL 
SELECT 2913, 280, 12, N'telewizji' UNION ALL 
SELECT 2914, 280, 13, N'telewizję' UNION ALL 
SELECT 2915, 280, 14, N'z telewizją' UNION ALL 
SELECT 2916, 280, 15, N'telewizji' UNION ALL 
SELECT 2917, 280, 16, N'telewizjo' UNION ALL 
SELECT 2918, 280, 19, N'telewizje' UNION ALL 
SELECT 2919, 280, 20, N'telewizji' UNION ALL 
SELECT 2920, 280, 21, N'telewizjom' UNION ALL 
SELECT 2921, 280, 22, N'telewizje' UNION ALL 
SELECT 2922, 280, 23, N'z telewizjami' UNION ALL 
SELECT 2923, 280, 24, N'telewizjach' UNION ALL 
SELECT 2924, 280, 25, N'telewizje' UNION ALL 
SELECT 2925, 281, 10, N'internet' UNION ALL 
SELECT 2926, 281, 11, N'internetu' UNION ALL 
SELECT 2927, 281, 12, N'internetowi' UNION ALL 
SELECT 2928, 281, 13, N'internet' UNION ALL 
SELECT 2929, 281, 14, N'z internetem' UNION ALL 
SELECT 2930, 281, 15, N'internecie' UNION ALL 
SELECT 2931, 281, 16, N'internecie' UNION ALL 
SELECT 2932, 282, 10, N'prasa' UNION ALL 
SELECT 2933, 282, 11, N'prasy' UNION ALL 
SELECT 2934, 282, 12, N'prasie' UNION ALL 
SELECT 2935, 282, 13, N'prasę' UNION ALL 
SELECT 2936, 282, 14, N'z prasą' UNION ALL 
SELECT 2937, 282, 15, N'prasie' UNION ALL 
SELECT 2938, 282, 16, N'praso' UNION ALL 
SELECT 2939, 282, 19, N'prasy' UNION ALL 
SELECT 2940, 282, 20, N'pras' UNION ALL 
SELECT 2941, 282, 21, N'prasom' UNION ALL 
SELECT 2942, 282, 22, N'prasy' UNION ALL 
SELECT 2943, 282, 23, N'z prasami' UNION ALL 
SELECT 2944, 282, 24, N'prasach' UNION ALL 
SELECT 2945, 282, 25, N'prasy' UNION ALL 
SELECT 2946, 283, 10, N'hotel' UNION ALL 
SELECT 2947, 283, 11, N'hotelu' UNION ALL 
SELECT 2948, 283, 12, N'hotelowi' UNION ALL 
SELECT 2949, 283, 13, N'hotel' UNION ALL 
SELECT 2950, 283, 14, N'z hotelem' UNION ALL 
SELECT 2951, 283, 15, N'hotelu' UNION ALL 
SELECT 2952, 283, 16, N'hotelu' UNION ALL 
SELECT 2953, 283, 17, N'do hotelu' UNION ALL 
SELECT 2954, 283, 18, N'w hotelu' UNION ALL 
SELECT 2955, 283, 19, N'hotele' UNION ALL 
SELECT 2956, 283, 20, N'hoteli' UNION ALL 
SELECT 2957, 283, 21, N'hotelom' UNION ALL 
SELECT 2958, 283, 22, N'hotele' UNION ALL 
SELECT 2959, 283, 23, N'z hotelami' UNION ALL 
SELECT 2960, 283, 24, N'hotelach' UNION ALL 
SELECT 2961, 283, 25, N'hotele' UNION ALL 
SELECT 2962, 284, 10, N'prąd' UNION ALL 
SELECT 2963, 284, 11, N'prądu' UNION ALL 
SELECT 2964, 284, 12, N'prądowi' UNION ALL 
SELECT 2965, 284, 13, N'prąd' UNION ALL 
SELECT 2966, 284, 14, N'z prądem' UNION ALL 
SELECT 2967, 284, 15, N'prądzie' UNION ALL 
SELECT 2968, 284, 16, N'prądzie' UNION ALL 
SELECT 2969, 284, 19, N'prądy' UNION ALL 
SELECT 2970, 284, 20, N'prądów' UNION ALL 
SELECT 2971, 284, 21, N'prądom' UNION ALL 
SELECT 2972, 284, 22, N'prądy' UNION ALL 
SELECT 2973, 284, 23, N'z prądami' UNION ALL 
SELECT 2974, 284, 24, N'prądach' UNION ALL 
SELECT 2975, 284, 25, N'prądy' UNION ALL 
SELECT 2976, 285, 10, N'telefon' UNION ALL 
SELECT 2977, 285, 11, N'telefonu' UNION ALL 
SELECT 2978, 285, 12, N'telefonowi' UNION ALL 
SELECT 2979, 285, 13, N'telefon' UNION ALL 
SELECT 2980, 285, 14, N'z telefonem' UNION ALL 
SELECT 2981, 285, 15, N'telefonie' UNION ALL 
SELECT 2982, 285, 16, N'telefonie' UNION ALL 
SELECT 2983, 285, 19, N'telefony' UNION ALL 
SELECT 2984, 285, 20, N'telefonów' UNION ALL 
SELECT 2985, 285, 21, N'telefonom' UNION ALL 
SELECT 2986, 285, 22, N'telefony' UNION ALL 
SELECT 2987, 285, 23, N'z telefonami' UNION ALL 
SELECT 2988, 285, 24, N'telefonach' UNION ALL 
SELECT 2989, 285, 25, N'telefony' UNION ALL 
SELECT 2990, 286, 10, N'ogrzewanie' UNION ALL 
SELECT 2991, 286, 11, N'ogrzewania' UNION ALL 
SELECT 2992, 286, 12, N'ogrzewaniu' UNION ALL 
SELECT 2993, 286, 13, N'ogrzewanie' UNION ALL 
SELECT 2994, 286, 14, N'z ogrzewaniem' UNION ALL 
SELECT 2995, 286, 15, N'ogrzewaniu' UNION ALL 
SELECT 2996, 286, 16, N'ogrzewanie' UNION ALL 
SELECT 2997, 286, 19, N'ogrzewania' UNION ALL 
SELECT 2998, 286, 20, N'ogrzewań' UNION ALL 
SELECT 2999, 286, 21, N'ogrzewaniom' UNION ALL 
SELECT 3000, 286, 22, N'ogrzewania' UNION ALL 
SELECT 3001, 286, 23, N'z ogrzewaniami' UNION ALL 
SELECT 3002, 286, 24, N'ogrzewaniach' UNION ALL 
SELECT 3003, 286, 25, N'ogrzewania' UNION ALL 
SELECT 3004, 287, 10, N'woda' UNION ALL 
SELECT 3005, 287, 11, N'wody' UNION ALL 
SELECT 3006, 287, 12, N'wodzie' UNION ALL 
SELECT 3007, 287, 13, N'wodę' UNION ALL 
SELECT 3008, 287, 14, N'z wodą' UNION ALL 
SELECT 3009, 287, 15, N'wodzie' UNION ALL 
SELECT 3010, 287, 16, N'wodo' UNION ALL 
SELECT 3011, 287, 19, N'wody' UNION ALL 
SELECT 3012, 287, 20, N'wód' UNION ALL 
SELECT 3013, 287, 21, N'wodom' UNION ALL 
SELECT 3014, 287, 22, N'wody' UNION ALL 
SELECT 3015, 287, 23, N'z wodami' UNION ALL 
SELECT 3016, 287, 24, N'wodach' UNION ALL 
SELECT 3017, 287, 25, N'wody' UNION ALL 
SELECT 3018, 288, 10, N'gaz' UNION ALL 
SELECT 3019, 288, 11, N'gazu' UNION ALL 
SELECT 3020, 288, 12, N'gazowi' UNION ALL 
SELECT 3021, 288, 13, N'gaz' UNION ALL 
SELECT 3022, 288, 14, N'z gazem' UNION ALL 
SELECT 3023, 288, 15, N'gazie' UNION ALL 
SELECT 3024, 288, 16, N'gazie' UNION ALL 
SELECT 3025, 288, 19, N'gazy' UNION ALL 
SELECT 3026, 288, 20, N'gazów' UNION ALL 
SELECT 3027, 288, 21, N'gazom' UNION ALL 
SELECT 3028, 288, 22, N'gazy' UNION ALL 
SELECT 3029, 288, 23, N'z gazami' UNION ALL 
SELECT 3030, 288, 24, N'gazach' UNION ALL 
SELECT 3031, 288, 25, N'gazy' UNION ALL 
SELECT 3032, 289, 10, N'samolot' UNION ALL 
SELECT 3033, 289, 11, N'samolotu' UNION ALL 
SELECT 3034, 289, 12, N'samolotowi' UNION ALL 
SELECT 3035, 289, 13, N'samolot' UNION ALL 
SELECT 3036, 289, 14, N'z samolotem' UNION ALL 
SELECT 3037, 289, 15, N'samolocie' UNION ALL 
SELECT 3038, 289, 16, N'samolocie' UNION ALL 
SELECT 3039, 289, 19, N'samoloty' UNION ALL 
SELECT 3040, 289, 20, N'samolotów' UNION ALL 
SELECT 3041, 289, 21, N'samolotom' UNION ALL 
SELECT 3042, 289, 22, N'samoloty' UNION ALL 
SELECT 3043, 289, 23, N'z samolotami' UNION ALL 
SELECT 3044, 289, 24, N'samolotach' UNION ALL 
SELECT 3045, 289, 25, N'samoloty' UNION ALL 
SELECT 3046, 290, 10, N'pociąg' UNION ALL 
SELECT 3047, 290, 11, N'pociągu' UNION ALL 
SELECT 3048, 290, 12, N'pociągowi' UNION ALL 
SELECT 3049, 290, 13, N'pociąg' UNION ALL 
SELECT 3050, 290, 14, N'z pociągiem' UNION ALL 
SELECT 3051, 290, 15, N'pociągu' UNION ALL 
SELECT 3052, 290, 16, N'pociągu' UNION ALL 
SELECT 3053, 290, 19, N'pociągi' UNION ALL 
SELECT 3054, 290, 20, N'pociągów' UNION ALL 
SELECT 3055, 290, 21, N'pociągom' UNION ALL 
SELECT 3056, 290, 22, N'pociągi' UNION ALL 
SELECT 3057, 290, 23, N'z pociągami' UNION ALL 
SELECT 3058, 290, 24, N'pociągach' UNION ALL 
SELECT 3059, 290, 25, N'pociągi' UNION ALL 
SELECT 3060, 291, 10, N'autobus' UNION ALL 
SELECT 3061, 291, 11, N'autobusu' UNION ALL 
SELECT 3062, 291, 12, N'autobusowi' UNION ALL 
SELECT 3063, 291, 13, N'autobus' UNION ALL 
SELECT 3064, 291, 14, N'z autobusem' UNION ALL 
SELECT 3065, 291, 15, N'autobusie' UNION ALL 
SELECT 3066, 291, 16, N'autobusie' UNION ALL 
SELECT 3067, 291, 19, N'autobusy' UNION ALL 
SELECT 3068, 291, 20, N'autobusów' UNION ALL 
SELECT 3069, 291, 21, N'autobusom' UNION ALL 
SELECT 3070, 291, 22, N'autobusy' UNION ALL 
SELECT 3071, 291, 23, N'z autobusami' UNION ALL 
SELECT 3072, 291, 24, N'autobusach' UNION ALL 
SELECT 3073, 291, 25, N'autobusy' UNION ALL 
SELECT 3074, 292, 10, N'lekcja' UNION ALL 
SELECT 3075, 292, 11, N'lekcji' UNION ALL 
SELECT 3076, 292, 12, N'lekcji' UNION ALL 
SELECT 3077, 292, 13, N'lekcję' UNION ALL 
SELECT 3078, 292, 14, N'z lekcją' UNION ALL 
SELECT 3079, 292, 15, N'lekcji' UNION ALL 
SELECT 3080, 292, 16, N'lekcjo' UNION ALL 
SELECT 3081, 292, 19, N'lekcje' UNION ALL 
SELECT 3082, 292, 20, N'lekcji' UNION ALL 
SELECT 3083, 292, 21, N'lekcjom' UNION ALL 
SELECT 3084, 292, 22, N'lekcje' UNION ALL 
SELECT 3085, 292, 23, N'z lekcjami' UNION ALL 
SELECT 3086, 292, 24, N'lekcjach' UNION ALL 
SELECT 3087, 292, 25, N'lekcje' UNION ALL 
SELECT 3088, 293, 10, N'morze' UNION ALL 
SELECT 3089, 293, 11, N'morza' UNION ALL 
SELECT 3090, 293, 12, N'morzu' UNION ALL 
SELECT 3091, 293, 13, N'morze' UNION ALL 
SELECT 3092, 293, 14, N'z morzem' UNION ALL 
SELECT 3093, 293, 15, N'morzu' UNION ALL 
SELECT 3094, 293, 16, N'morze' UNION ALL 
SELECT 3095, 293, 17, N'nad morze' UNION ALL 
SELECT 3096, 293, 18, N'nad morzem' UNION ALL 
SELECT 3097, 293, 19, N'morza' UNION ALL 
SELECT 3098, 293, 20, N'mórz' UNION ALL 
SELECT 3099, 293, 21, N'morzom' UNION ALL 
SELECT 3100, 293, 22, N'morza' UNION ALL 
SELECT 3101, 293, 23, N'z morzami' UNION ALL 
SELECT 3102, 293, 24, N'morzach' UNION ALL 
SELECT 3103, 293, 25, N'morza' UNION ALL 
SELECT 3104, 294, 10, N'jezioro' UNION ALL 
SELECT 3105, 294, 11, N'jeziora' UNION ALL 
SELECT 3106, 294, 12, N'jezioru' UNION ALL 
SELECT 3107, 294, 13, N'jezioro' UNION ALL 
SELECT 3108, 294, 14, N'z jeziorem' UNION ALL 
SELECT 3109, 294, 15, N'jeziorze' UNION ALL 
SELECT 3110, 294, 16, N'jezioro' UNION ALL 
SELECT 3111, 294, 17, N'nad jezioro' UNION ALL 
SELECT 3112, 294, 18, N'nad jeziorem' UNION ALL 
SELECT 3113, 294, 19, N'jeziora' UNION ALL 
SELECT 3114, 294, 20, N'jezior' UNION ALL 
SELECT 3115, 294, 21, N'jeziorom' UNION ALL 
SELECT 3116, 294, 22, N'jeziora' UNION ALL 
SELECT 3117, 294, 23, N'z jeziorami' UNION ALL 
SELECT 3118, 294, 24, N'jeziorach' UNION ALL 
SELECT 3119, 294, 25, N'jeziora' UNION ALL 
SELECT 3120, 295, 10, N'plaża' UNION ALL 
SELECT 3121, 295, 11, N'plaży' UNION ALL 
SELECT 3122, 295, 12, N'plaży' UNION ALL 
SELECT 3123, 295, 13, N'plażę' UNION ALL 
SELECT 3124, 295, 14, N'z plażą' UNION ALL 
SELECT 3125, 295, 15, N'plaży' UNION ALL 
SELECT 3126, 295, 16, N'plażo' UNION ALL 
SELECT 3127, 295, 17, N'na plażę' UNION ALL 
SELECT 3128, 295, 18, N'na plaży' UNION ALL 
SELECT 3129, 295, 19, N'plaże' UNION ALL 
SELECT 3130, 295, 20, N'plaż' UNION ALL 
SELECT 3131, 295, 21, N'plażom' UNION ALL 
SELECT 3132, 295, 22, N'plaże' UNION ALL 
SELECT 3133, 295, 23, N'z plażami' UNION ALL 
SELECT 3134, 295, 24, N'plażach' UNION ALL 
SELECT 3135, 295, 25, N'plaże' UNION ALL 
SELECT 3136, 296, 10, N'szpital' UNION ALL 
SELECT 3137, 296, 11, N'szpitala' UNION ALL 
SELECT 3138, 296, 12, N'szpitalowi' UNION ALL 
SELECT 3139, 296, 13, N'szpital' UNION ALL 
SELECT 3140, 296, 14, N'ze szpitalem' UNION ALL 
SELECT 3141, 296, 15, N'szpitalu' UNION ALL 
SELECT 3142, 296, 16, N'szpitalu' UNION ALL 
SELECT 3143, 296, 17, N'do szpitala' UNION ALL 
SELECT 3144, 296, 18, N'w szpitalu' UNION ALL 
SELECT 3145, 296, 19, N'szpitale' UNION ALL 
SELECT 3146, 296, 20, N'szpitali' UNION ALL 
SELECT 3147, 296, 21, N'szpitalom' UNION ALL 
SELECT 3148, 296, 22, N'szpitale' UNION ALL 
SELECT 3149, 296, 23, N'ze szpitalami' UNION ALL 
SELECT 3150, 296, 24, N'szpitalach' UNION ALL 
SELECT 3151, 296, 25, N'szpitale' UNION ALL 
SELECT 3152, 297, 10, N'szkoła' UNION ALL 
SELECT 3153, 297, 11, N'szkoły' UNION ALL 
SELECT 3154, 297, 12, N'szkole' UNION ALL 
SELECT 3155, 297, 13, N'szkołę' UNION ALL 
SELECT 3156, 297, 14, N'ze szkołą' UNION ALL 
SELECT 3157, 297, 15, N'szkole' UNION ALL 
SELECT 3158, 297, 16, N'szkoło' UNION ALL 
SELECT 3159, 297, 17, N'do szkoły' UNION ALL 
SELECT 3160, 297, 18, N'w szkole' UNION ALL 
SELECT 3161, 297, 19, N'szkoły' UNION ALL 
SELECT 3162, 297, 20, N'szkół' UNION ALL 
SELECT 3163, 297, 21, N'szkołom' UNION ALL 
SELECT 3164, 297, 22, N'szkoły' UNION ALL 
SELECT 3165, 297, 23, N'ze szkołami' UNION ALL 
SELECT 3166, 297, 24, N'szkołach' UNION ALL 
SELECT 3167, 297, 25, N'szkoły' UNION ALL 
SELECT 3168, 298, 10, N'poczta' UNION ALL 
SELECT 3169, 298, 11, N'poczty' UNION ALL 
SELECT 3170, 298, 12, N'poczcie' UNION ALL 
SELECT 3171, 298, 13, N'pocztę' UNION ALL 
SELECT 3172, 298, 14, N'z pocztą' UNION ALL 
SELECT 3173, 298, 15, N'poczcie' UNION ALL 
SELECT 3174, 298, 16, N'poczto' UNION ALL 
SELECT 3175, 298, 17, N'na pocztę' UNION ALL 
SELECT 3176, 298, 18, N'na poczcie' UNION ALL 
SELECT 3177, 298, 19, N'poczty' UNION ALL 
SELECT 3178, 298, 20, N'poczt' UNION ALL 
SELECT 3179, 298, 21, N'pocztom' UNION ALL 
SELECT 3180, 298, 22, N'poczty' UNION ALL 
SELECT 3181, 298, 23, N'z pocztami' UNION ALL 
SELECT 3182, 298, 24, N'pocztach' UNION ALL 
SELECT 3183, 298, 25, N'poczty' UNION ALL 
SELECT 3184, 299, 10, N'policja' UNION ALL 
SELECT 3185, 299, 11, N'policji' UNION ALL 
SELECT 3186, 299, 12, N'policji' UNION ALL 
SELECT 3187, 299, 13, N'policję' UNION ALL 
SELECT 3188, 299, 14, N'z policją' UNION ALL 
SELECT 3189, 299, 15, N'policji' UNION ALL 
SELECT 3190, 299, 16, N'policjo' UNION ALL 
SELECT 3191, 299, 19, N'policje' UNION ALL 
SELECT 3192, 299, 20, N'policji' UNION ALL 
SELECT 3193, 299, 21, N'policjom' UNION ALL 
SELECT 3194, 299, 22, N'policje' UNION ALL 
SELECT 3195, 299, 23, N'z policjami' UNION ALL 
SELECT 3196, 299, 24, N'policjach' UNION ALL 
SELECT 3197, 299, 25, N'policje' UNION ALL 
SELECT 3198, 300, 10, N'Oscar' UNION ALL 
SELECT 3199, 300, 11, N'Oscara' UNION ALL 
SELECT 3200, 300, 12, N'Oscarowi' UNION ALL 
SELECT 3201, 300, 13, N'Oscara' UNION ALL 
SELECT 3202, 300, 14, N'z Oscarem' UNION ALL 
SELECT 3203, 300, 15, N'Oscarze' UNION ALL 
SELECT 3204, 300, 16, N'Oscarze' UNION ALL 
SELECT 3205, 300, 19, N'Oscary' UNION ALL 
SELECT 3206, 300, 20, N'Oscarów' UNION ALL 
SELECT 3207, 300, 21, N'Oscarom' UNION ALL 
SELECT 3208, 300, 22, N'Oscary' UNION ALL 
SELECT 3209, 300, 23, N'z Oscarami' UNION ALL 
SELECT 3210, 300, 24, N'Oscarach' UNION ALL 
SELECT 3211, 300, 25, N'Oscary' UNION ALL 
SELECT 3212, 301, 10, N'Nagroda Nobla' UNION ALL 
SELECT 3213, 301, 11, N'Nagrody Nobla' UNION ALL 
SELECT 3214, 301, 12, N'Nagrodzie Nobla' UNION ALL 
SELECT 3215, 301, 13, N'Nagrodę Nobla' UNION ALL 
SELECT 3216, 301, 14, N'z Nagrodą Nobla' UNION ALL 
SELECT 3217, 301, 15, N'Nagrodzie Nobla' UNION ALL 
SELECT 3218, 301, 16, N'Nagrodo Nobla' UNION ALL 
SELECT 3219, 301, 19, N'Nagrody Nobla' UNION ALL 
SELECT 3220, 301, 20, N'Nagród Nobla' UNION ALL 
SELECT 3221, 301, 21, N'Nagrodom Nobla' UNION ALL 
SELECT 3222, 301, 22, N'Nagrody Nobla' UNION ALL 
SELECT 3223, 301, 23, N'z Nagrodami Nobla' UNION ALL 
SELECT 3224, 301, 24, N'Nagrodach Nobla' UNION ALL 
SELECT 3225, 301, 25, N'Nagrody Nobla' UNION ALL 
SELECT 3226, 302, 10, N'strażak' UNION ALL 
SELECT 3227, 302, 11, N'strażaka' UNION ALL 
SELECT 3228, 302, 12, N'strażakowi' UNION ALL 
SELECT 3229, 302, 13, N'strażaka' UNION ALL 
SELECT 3230, 302, 14, N'ze strażakiem' UNION ALL 
SELECT 3231, 302, 15, N'strażaku' UNION ALL 
SELECT 3232, 302, 16, N'strażaku' UNION ALL 
SELECT 3233, 302, 19, N'strażacy' UNION ALL 
SELECT 3234, 302, 20, N'strażaków' UNION ALL 
SELECT 3235, 302, 21, N'strażakom' UNION ALL 
SELECT 3236, 302, 22, N'strażaków' UNION ALL 
SELECT 3237, 302, 23, N'ze strażakami' UNION ALL 
SELECT 3238, 302, 24, N'strażakach' UNION ALL 
SELECT 3239, 302, 25, N'strażacy' UNION ALL 
SELECT 3240, 303, 10, N'lekarz' UNION ALL 
SELECT 3241, 303, 11, N'lekarza' UNION ALL 
SELECT 3242, 303, 12, N'lekarzowi' UNION ALL 
SELECT 3243, 303, 13, N'lekarza' UNION ALL 
SELECT 3244, 303, 14, N'z lekarzem' UNION ALL 
SELECT 3245, 303, 15, N'lekarzu' UNION ALL 
SELECT 3246, 303, 16, N'lekarzu' UNION ALL 
SELECT 3247, 303, 19, N'lekarze' UNION ALL 
SELECT 3248, 303, 20, N'lekarzy' UNION ALL 
SELECT 3249, 303, 21, N'lekarzom' UNION ALL 
SELECT 3250, 303, 22, N'lekarzy' UNION ALL 
SELECT 3251, 303, 23, N'z lekarzami' UNION ALL 
SELECT 3252, 303, 24, N'lekarzach' UNION ALL 
SELECT 3253, 303, 25, N'lekarze' UNION ALL 
SELECT 3254, 304, 10, N'policjant' UNION ALL 
SELECT 3255, 304, 11, N'policjanta' UNION ALL 
SELECT 3256, 304, 12, N'policjantowi' UNION ALL 
SELECT 3257, 304, 13, N'policjanta' UNION ALL 
SELECT 3258, 304, 14, N'z policjantem' UNION ALL 
SELECT 3259, 304, 15, N'policjancie' UNION ALL 
SELECT 3260, 304, 16, N'policjancie' UNION ALL 
SELECT 3261, 304, 19, N'policjanci' UNION ALL 
SELECT 3262, 304, 20, N'policjantów' UNION ALL 
SELECT 3263, 304, 21, N'policjantom' UNION ALL 
SELECT 3264, 304, 22, N'policjantów' UNION ALL 
SELECT 3265, 304, 23, N'z policjantami' UNION ALL 
SELECT 3266, 304, 24, N'policjantach' UNION ALL 
SELECT 3267, 304, 25, N'policjanci' UNION ALL 
SELECT 3268, 305, 10, N'nauczyciel' UNION ALL 
SELECT 3269, 305, 11, N'nauczyciela' UNION ALL 
SELECT 3270, 305, 12, N'nauczycielowi' UNION ALL 
SELECT 3271, 305, 13, N'nauczyciela' UNION ALL 
SELECT 3272, 305, 14, N'z nauczycielem' UNION ALL 
SELECT 3273, 305, 15, N'nauczycielu' UNION ALL 
SELECT 3274, 305, 16, N'nauczycielu' UNION ALL 
SELECT 3275, 305, 19, N'nauczyciele' UNION ALL 
SELECT 3276, 305, 20, N'nauczycieli' UNION ALL 
SELECT 3277, 305, 21, N'nauczycielom' UNION ALL 
SELECT 3278, 305, 22, N'nauczycieli' UNION ALL 
SELECT 3279, 305, 23, N'z nauczycielami' UNION ALL 
SELECT 3280, 305, 24, N'nauczycielach' UNION ALL 
SELECT 3281, 305, 25, N'nauczyciele' UNION ALL 
SELECT 3282, 306, 10, N'taksówkarz' UNION ALL 
SELECT 3283, 306, 11, N'taksówkarza' UNION ALL 
SELECT 3284, 306, 12, N'taksówkarzowi' UNION ALL 
SELECT 3285, 306, 13, N'taksówkarza' UNION ALL 
SELECT 3286, 306, 14, N'z taksówkarzem' UNION ALL 
SELECT 3287, 306, 15, N'taksówkarzu' UNION ALL 
SELECT 3288, 306, 16, N'taksówkarzu' UNION ALL 
SELECT 3289, 306, 19, N'taksówkarze' UNION ALL 
SELECT 3290, 306, 20, N'taksówkarzy' UNION ALL 
SELECT 3291, 306, 21, N'taksówkarzom' UNION ALL 
SELECT 3292, 306, 22, N'taksówkarzy' UNION ALL 
SELECT 3293, 306, 23, N'z taksówkarzami' UNION ALL 
SELECT 3294, 306, 24, N'taksówkarzach' UNION ALL 
SELECT 3295, 306, 25, N'taksówkarze' UNION ALL 
SELECT 3296, 307, 10, N'kierowca' UNION ALL 
SELECT 3297, 307, 11, N'kierowcy' UNION ALL 
SELECT 3298, 307, 12, N'kierowcy' UNION ALL 
SELECT 3299, 307, 13, N'kierowcę' UNION ALL 
SELECT 3300, 307, 14, N'z kierowcą' UNION ALL 
SELECT 3301, 307, 15, N'kierowcy' UNION ALL 
SELECT 3302, 307, 16, N'kierowco' UNION ALL 
SELECT 3303, 307, 19, N'kierowcy' UNION ALL 
SELECT 3304, 307, 20, N'kierowców' UNION ALL 
SELECT 3305, 307, 21, N'kierowcom' UNION ALL 
SELECT 3306, 307, 22, N'kierowców' UNION ALL 
SELECT 3307, 307, 23, N'z kierowcami' UNION ALL 
SELECT 3308, 307, 24, N'kierowcach' UNION ALL 
SELECT 3309, 307, 25, N'kierowcy' UNION ALL 
SELECT 3310, 308, 10, N'mieszkanie' UNION ALL 
SELECT 3311, 308, 11, N'mieszkania' UNION ALL 
SELECT 3312, 308, 12, N'mieszkaniu' UNION ALL 
SELECT 3313, 308, 13, N'mieszkanie' UNION ALL 
SELECT 3314, 308, 14, N'z mieszkaniem' UNION ALL 
SELECT 3315, 308, 15, N'mieszkaniu' UNION ALL 
SELECT 3316, 308, 16, N'mieszkanie' UNION ALL 
SELECT 3317, 308, 17, N'do mieszkania' UNION ALL 
SELECT 3318, 308, 18, N'w mieszkaniu' UNION ALL 
SELECT 3319, 308, 19, N'mieszkania' UNION ALL 
SELECT 3320, 308, 20, N'mieszkań' UNION ALL 
SELECT 3321, 308, 21, N'mieszkaniom' UNION ALL 
SELECT 3322, 308, 22, N'mieszkania' UNION ALL 
SELECT 3323, 308, 23, N'z mieszkaniami' UNION ALL 
SELECT 3324, 308, 24, N'mieszkaniach' UNION ALL 
SELECT 3325, 308, 25, N'mieszkania' UNION ALL 
SELECT 3326, 309, 10, N'pokój' UNION ALL 
SELECT 3327, 309, 11, N'pokoju' UNION ALL 
SELECT 3328, 309, 12, N'pokojowi' UNION ALL 
SELECT 3329, 309, 13, N'pokój' UNION ALL 
SELECT 3330, 309, 14, N'z pokojem' UNION ALL 
SELECT 3331, 309, 15, N'pokoju' UNION ALL 
SELECT 3332, 309, 16, N'pokoju' UNION ALL 
SELECT 3333, 309, 17, N'do pokoju' UNION ALL 
SELECT 3334, 309, 18, N'w pokoju' UNION ALL 
SELECT 3335, 309, 19, N'pokoje' UNION ALL 
SELECT 3336, 309, 20, N'pokojów' UNION ALL 
SELECT 3337, 309, 21, N'pokojom' UNION ALL 
SELECT 3338, 309, 22, N'pokoje' UNION ALL 
SELECT 3339, 309, 23, N'z pokojami' UNION ALL 
SELECT 3340, 309, 24, N'pokojach' UNION ALL 
SELECT 3341, 309, 25, N'pokoje' UNION ALL 
SELECT 3342, 310, 19, N'drzwi' UNION ALL 
SELECT 3343, 310, 20, N'drzwi' UNION ALL 
SELECT 3344, 310, 21, N'drzwiom' UNION ALL 
SELECT 3345, 310, 22, N'drzwi' UNION ALL 
SELECT 3346, 310, 23, N'z drzwiami' UNION ALL 
SELECT 3347, 310, 24, N'drzwiach' UNION ALL 
SELECT 3348, 310, 25, N'drzwi' UNION ALL 
SELECT 3349, 311, 10, N'okno' UNION ALL 
SELECT 3350, 311, 11, N'okna' UNION ALL 
SELECT 3351, 311, 12, N'oknu' UNION ALL 
SELECT 3352, 311, 13, N'okno' UNION ALL 
SELECT 3353, 311, 14, N'z oknem' UNION ALL 
SELECT 3354, 311, 15, N'oknie' UNION ALL 
SELECT 3355, 311, 16, N'okno' UNION ALL 
SELECT 3356, 311, 19, N'okna' UNION ALL 
SELECT 3357, 311, 20, N'okien' UNION ALL 
SELECT 3358, 311, 21, N'oknom' UNION ALL 
SELECT 3359, 311, 22, N'okna' UNION ALL 
SELECT 3360, 311, 23, N'z oknami' UNION ALL 
SELECT 3361, 311, 24, N'oknach' UNION ALL 
SELECT 3362, 311, 25, N'okna' UNION ALL 
SELECT 3363, 312, 10, N'śniadanie' UNION ALL 
SELECT 3364, 312, 11, N'śniadania' UNION ALL 
SELECT 3365, 312, 12, N'śniadaniu' UNION ALL 
SELECT 3366, 312, 13, N'śniadanie' UNION ALL 
SELECT 3367, 312, 14, N'ze śniadaniem' UNION ALL 
SELECT 3368, 312, 15, N'śniadaniu' UNION ALL 
SELECT 3369, 312, 16, N'śniadanie' UNION ALL 
SELECT 3370, 312, 19, N'śniadania' UNION ALL 
SELECT 3371, 312, 20, N'śniadań' UNION ALL 
SELECT 3372, 312, 21, N'śniadaniom' UNION ALL 
SELECT 3373, 312, 22, N'śniadania' UNION ALL 
SELECT 3374, 312, 23, N'ze śniadaniami' UNION ALL 
SELECT 3375, 312, 24, N'śniadaniach' UNION ALL 
SELECT 3376, 312, 25, N'śniadania' UNION ALL 
SELECT 3377, 313, 10, N'obiad' UNION ALL 
SELECT 3378, 313, 11, N'obiadu' UNION ALL 
SELECT 3379, 313, 12, N'obiadowi' UNION ALL 
SELECT 3380, 313, 13, N'obiad' UNION ALL 
SELECT 3381, 313, 14, N'z obiadem' UNION ALL 
SELECT 3382, 313, 15, N'obiadzie' UNION ALL 
SELECT 3383, 313, 16, N'obiadzie' UNION ALL 
SELECT 3384, 313, 19, N'obiady' UNION ALL 
SELECT 3385, 313, 20, N'obiadów' UNION ALL 
SELECT 3386, 313, 21, N'obiadom' UNION ALL 
SELECT 3387, 313, 22, N'obiady' UNION ALL 
SELECT 3388, 313, 23, N'z obiadami' UNION ALL 
SELECT 3389, 313, 24, N'obiadach' UNION ALL 
SELECT 3390, 313, 25, N'obiady' UNION ALL 
SELECT 3391, 314, 10, N'dom' UNION ALL 
SELECT 3392, 314, 11, N'domu' UNION ALL 
SELECT 3393, 314, 12, N'domowi' UNION ALL 
SELECT 3394, 314, 13, N'dom' UNION ALL 
SELECT 3395, 314, 14, N'z domem' UNION ALL 
SELECT 3396, 314, 15, N'domu' UNION ALL 
SELECT 3397, 314, 16, N'domie' UNION ALL 
SELECT 3398, 314, 17, N'do domu' UNION ALL 
SELECT 3399, 314, 18, N'w domu' UNION ALL 
SELECT 3400, 314, 19, N'domy' UNION ALL 
SELECT 3401, 314, 20, N'domów' UNION ALL 
SELECT 3402, 314, 21, N'domom' UNION ALL 
SELECT 3403, 314, 22, N'domy' UNION ALL 
SELECT 3404, 314, 23, N'z domami' UNION ALL 
SELECT 3405, 314, 24, N'domach' UNION ALL 
SELECT 3406, 314, 25, N'domy' UNION ALL 
SELECT 3407, 315, 10, N'brzeg' UNION ALL 
SELECT 3408, 315, 11, N'brzegu' UNION ALL 
SELECT 3409, 315, 12, N'brzegowi' UNION ALL 
SELECT 3410, 315, 13, N'brzeg' UNION ALL 
SELECT 3411, 315, 14, N'z brzegiem' UNION ALL 
SELECT 3412, 315, 15, N'brzegu' UNION ALL 
SELECT 3413, 315, 16, N'brzegu' UNION ALL 
SELECT 3414, 315, 17, N'nad brzeg' UNION ALL 
SELECT 3415, 315, 18, N'nad brzegiem' UNION ALL 
SELECT 3416, 315, 19, N'brzegi' UNION ALL 
SELECT 3417, 315, 20, N'brzegów' UNION ALL 
SELECT 3418, 315, 21, N'brzegom' UNION ALL 
SELECT 3419, 315, 22, N'brzegi' UNION ALL 
SELECT 3420, 315, 23, N'z brzegami' UNION ALL 
SELECT 3421, 315, 24, N'brzegach' UNION ALL 
SELECT 3422, 315, 25, N'brzegi' UNION ALL 
SELECT 3423, 316, 10, N'las' UNION ALL 
SELECT 3424, 316, 11, N'lasu' UNION ALL 
SELECT 3425, 316, 12, N'lasowi' UNION ALL 
SELECT 3426, 316, 13, N'las' UNION ALL 
SELECT 3427, 316, 14, N'z lasem' UNION ALL 
SELECT 3428, 316, 15, N'lesie' UNION ALL 
SELECT 3429, 316, 16, N'lesie' UNION ALL 
SELECT 3430, 316, 17, N'do lasu' UNION ALL 
SELECT 3431, 316, 18, N'w lesie' UNION ALL 
SELECT 3432, 316, 19, N'lasy' UNION ALL 
SELECT 3433, 316, 20, N'lasów' UNION ALL 
SELECT 3434, 316, 21, N'lasom' UNION ALL 
SELECT 3435, 316, 22, N'lasy' UNION ALL 
SELECT 3436, 316, 23, N'z lasami' UNION ALL 
SELECT 3437, 316, 24, N'lasach' UNION ALL 
SELECT 3438, 316, 25, N'lasy' UNION ALL 
SELECT 3439, 317, 10, N'lotnisko' UNION ALL 
SELECT 3440, 317, 11, N'lotniska' UNION ALL 
SELECT 3441, 317, 12, N'lotnisku' UNION ALL 
SELECT 3442, 317, 13, N'lotnisko' UNION ALL 
SELECT 3443, 317, 14, N'z lotniskiem' UNION ALL 
SELECT 3444, 317, 15, N'lotnisku' UNION ALL 
SELECT 3445, 317, 16, N'lotnisko' UNION ALL 
SELECT 3446, 317, 17, N'na lotnisko' UNION ALL 
SELECT 3447, 317, 18, N'na lotnisku' UNION ALL 
SELECT 3448, 317, 19, N'lotniska' UNION ALL 
SELECT 3449, 317, 20, N'lotnisk' UNION ALL 
SELECT 3450, 317, 21, N'lotniskom' UNION ALL 
SELECT 3451, 317, 22, N'lotniska' UNION ALL 
SELECT 3452, 317, 23, N'z lotniskami' UNION ALL 
SELECT 3453, 317, 24, N'lotniskach' UNION ALL 
SELECT 3454, 317, 25, N'lotniska' UNION ALL 
SELECT 3455, 318, 10, N'rzeka' UNION ALL 
SELECT 3456, 318, 11, N'rzeki' UNION ALL 
SELECT 3457, 318, 12, N'rzece' UNION ALL 
SELECT 3458, 318, 13, N'rzekę' UNION ALL 
SELECT 3459, 318, 14, N'z rzeką' UNION ALL 
SELECT 3460, 318, 15, N'rzece' UNION ALL 
SELECT 3461, 318, 16, N'rzeko' UNION ALL 
SELECT 3462, 318, 17, N'nad rzekę' UNION ALL 
SELECT 3463, 318, 18, N'nad rzeką' UNION ALL 
SELECT 3464, 318, 19, N'rzeki' UNION ALL 
SELECT 3465, 318, 20, N'rzek' UNION ALL 
SELECT 3466, 318, 21, N'rzekom' UNION ALL 
SELECT 3467, 318, 22, N'rzeki' UNION ALL 
SELECT 3468, 318, 23, N'z rzekami' UNION ALL 
SELECT 3469, 318, 24, N'rzekach' UNION ALL 
SELECT 3470, 318, 25, N'rzeki' UNION ALL 
SELECT 3471, 319, 10, N'taksówka' UNION ALL 
SELECT 3472, 319, 11, N'taksówki' UNION ALL 
SELECT 3473, 319, 12, N'taksówce' UNION ALL 
SELECT 3474, 319, 13, N'taksówkę' UNION ALL 
SELECT 3475, 319, 14, N'z taksówką' UNION ALL 
SELECT 3476, 319, 15, N'taksówce' UNION ALL 
SELECT 3477, 319, 16, N'taksówko' UNION ALL 
SELECT 3478, 319, 17, N'na taksówkę' UNION ALL 
SELECT 3479, 319, 18, N'w taksówce' UNION ALL 
SELECT 3480, 319, 19, N'taksówki' UNION ALL 
SELECT 3481, 319, 20, N'taksówek' UNION ALL 
SELECT 3482, 319, 21, N'taksówkom' UNION ALL 
SELECT 3483, 319, 22, N'taksówki' UNION ALL 
SELECT 3484, 319, 23, N'z taksówkami' UNION ALL 
SELECT 3485, 319, 24, N'taksówkach' UNION ALL 
SELECT 3486, 319, 25, N'taksówki' UNION ALL 
SELECT 3487, 320, 10, N'wywiad' UNION ALL 
SELECT 3488, 320, 11, N'wywiadu' UNION ALL 
SELECT 3489, 320, 12, N'wywiadowi' UNION ALL 
SELECT 3490, 320, 13, N'wywiad' UNION ALL 
SELECT 3491, 320, 14, N'z wywiadem' UNION ALL 
SELECT 3492, 320, 15, N'wywiadzie' UNION ALL 
SELECT 3493, 320, 16, N'wywiadzie' UNION ALL 
SELECT 3494, 320, 19, N'wywiady' UNION ALL 
SELECT 3495, 320, 20, N'wywiadów' UNION ALL 
SELECT 3496, 320, 21, N'wywiadom' UNION ALL 
SELECT 3497, 320, 22, N'wywiady' UNION ALL 
SELECT 3498, 320, 23, N'z wywiadami' UNION ALL 
SELECT 3499, 320, 24, N'wywiadach' UNION ALL 
SELECT 3500, 320, 25, N'wywiady' UNION ALL 
SELECT 3501, 321, 10, N'spotkanie' UNION ALL 
SELECT 3502, 321, 11, N'spotkania' UNION ALL 
SELECT 3503, 321, 12, N'spotkaniu' UNION ALL 
SELECT 3504, 321, 13, N'spotkanie' UNION ALL 
SELECT 3505, 321, 14, N'ze spotkaniem' UNION ALL 
SELECT 3506, 321, 15, N'spotkaniu' UNION ALL 
SELECT 3507, 321, 16, N'spotkanie' UNION ALL 
SELECT 3508, 321, 19, N'spotkania' UNION ALL 
SELECT 3509, 321, 20, N'spotkań' UNION ALL 
SELECT 3510, 321, 21, N'spotkaniom' UNION ALL 
SELECT 3511, 321, 22, N'spotkania' UNION ALL 
SELECT 3512, 321, 23, N'ze spotkaniami' UNION ALL 
SELECT 3513, 321, 24, N'spotkaniach' UNION ALL 
SELECT 3514, 321, 25, N'spotkania' UNION ALL 
SELECT 3515, 322, 10, N'debata' UNION ALL 
SELECT 3516, 322, 11, N'debaty' UNION ALL 
SELECT 3517, 322, 12, N'debacie' UNION ALL 
SELECT 3518, 322, 13, N'debatę' UNION ALL 
SELECT 3519, 322, 14, N'z debatą' UNION ALL 
SELECT 3520, 322, 15, N'debacie' UNION ALL 
SELECT 3521, 322, 16, N'debato' UNION ALL 
SELECT 3522, 322, 19, N'debaty' UNION ALL 
SELECT 3523, 322, 20, N'debat' UNION ALL 
SELECT 3524, 322, 21, N'debatom' UNION ALL 
SELECT 3525, 322, 22, N'debaty' UNION ALL 
SELECT 3526, 322, 23, N'z debatami' UNION ALL 
SELECT 3527, 322, 24, N'debatach' UNION ALL 
SELECT 3528, 322, 25, N'debaty' UNION ALL 
SELECT 3529, 323, 10, N'portfel' UNION ALL 
SELECT 3530, 323, 11, N'portfela' UNION ALL 
SELECT 3531, 323, 12, N'portfelowi' UNION ALL 
SELECT 3532, 323, 13, N'portfel' UNION ALL 
SELECT 3533, 323, 14, N'z portfelem' UNION ALL 
SELECT 3534, 323, 15, N'portfelu' UNION ALL 
SELECT 3535, 323, 16, N'portfelu' UNION ALL 
SELECT 3536, 323, 19, N'portfele' UNION ALL 
SELECT 3537, 323, 20, N'portfeli' UNION ALL 
SELECT 3538, 323, 21, N'portfelom' UNION ALL 
SELECT 3539, 323, 22, N'portfele' UNION ALL 
SELECT 3540, 323, 23, N'z portfelami' UNION ALL 
SELECT 3541, 323, 24, N'portfelach' UNION ALL 
SELECT 3542, 323, 25, N'portfele' UNION ALL 
SELECT 3543, 324, 10, N'klucz' UNION ALL 
SELECT 3544, 324, 11, N'klucza' UNION ALL 
SELECT 3545, 324, 12, N'kluczowi' UNION ALL 
SELECT 3546, 324, 13, N'klucz' UNION ALL 
SELECT 3547, 324, 14, N'z kluczem' UNION ALL 
SELECT 3548, 324, 15, N'kluczu' UNION ALL 
SELECT 3549, 324, 16, N'kluczu' UNION ALL 
SELECT 3550, 324, 19, N'klucze' UNION ALL 
SELECT 3551, 324, 20, N'kluczy' UNION ALL 
SELECT 3552, 324, 21, N'kluczom' UNION ALL 
SELECT 3553, 324, 22, N'klucze' UNION ALL 
SELECT 3554, 324, 23, N'z kluczami' UNION ALL 
SELECT 3555, 324, 24, N'kluczach' UNION ALL 
SELECT 3556, 324, 25, N'klucze' UNION ALL 
SELECT 3557, 325, 10, N'karta kredytowa' UNION ALL 
SELECT 3558, 325, 11, N'karty kredytowej' UNION ALL 
SELECT 3559, 325, 12, N'karcie kredytowej' UNION ALL 
SELECT 3560, 325, 13, N'kartę kredytową' UNION ALL 
SELECT 3561, 325, 14, N'z kartą kredytową' UNION ALL 
SELECT 3562, 325, 15, N'karcie kredytowej' UNION ALL 
SELECT 3563, 325, 16, N'karto kredytowa' UNION ALL 
SELECT 3564, 325, 19, N'karty kredytowe' UNION ALL 
SELECT 3565, 325, 20, N'kart kredytowych' UNION ALL 
SELECT 3566, 325, 21, N'kartom kredytowym' UNION ALL 
SELECT 3567, 325, 22, N'karty kredytowe' UNION ALL 
SELECT 3568, 325, 23, N'z kartami kredytowymi' UNION ALL 
SELECT 3569, 325, 24, N'kartach kredytowych' UNION ALL 
SELECT 3570, 325, 25, N'karty kredytowe' UNION ALL 
SELECT 3571, 326, 10, N'lot' UNION ALL 
SELECT 3572, 326, 11, N'lotu' UNION ALL 
SELECT 3573, 326, 12, N'lotowi' UNION ALL 
SELECT 3574, 326, 13, N'lot' UNION ALL 
SELECT 3575, 326, 14, N'z lotem' UNION ALL 
SELECT 3576, 326, 15, N'locie' UNION ALL 
SELECT 3577, 326, 16, N'locie' UNION ALL 
SELECT 3578, 326, 19, N'loty' UNION ALL 
SELECT 3579, 326, 20, N'lotów' UNION ALL 
SELECT 3580, 326, 21, N'lotom' UNION ALL 
SELECT 3581, 326, 22, N'loty' UNION ALL 
SELECT 3582, 326, 23, N'z lotami' UNION ALL 
SELECT 3583, 326, 24, N'lotach' UNION ALL 
SELECT 3584, 326, 25, N'loty' UNION ALL 
SELECT 3585, 327, 10, N'prezent' UNION ALL 
SELECT 3586, 327, 11, N'prezentu' UNION ALL 
SELECT 3587, 327, 12, N'prezentowi' UNION ALL 
SELECT 3588, 327, 13, N'prezent' UNION ALL 
SELECT 3589, 327, 14, N'z prezentem' UNION ALL 
SELECT 3590, 327, 15, N'prezencie' UNION ALL 
SELECT 3591, 327, 16, N'prezencie' UNION ALL 
SELECT 3592, 327, 19, N'prezenty' UNION ALL 
SELECT 3593, 327, 20, N'prezentów' UNION ALL 
SELECT 3594, 327, 21, N'prezentom' UNION ALL 
SELECT 3595, 327, 22, N'prezenty' UNION ALL 
SELECT 3596, 327, 23, N'z prezentami' UNION ALL 
SELECT 3597, 327, 24, N'prezentach' UNION ALL 
SELECT 3598, 327, 25, N'prezenty' UNION ALL 
SELECT 3599, 328, 10, N'odpowiedź' UNION ALL 
SELECT 3600, 328, 11, N'odpowiedzi' UNION ALL 
SELECT 3601, 328, 12, N'odpowiedzi' UNION ALL 
SELECT 3602, 328, 13, N'odpowiedź' UNION ALL 
SELECT 3603, 328, 14, N'z odpowiedzią' UNION ALL 
SELECT 3604, 328, 15, N'odpowiedzi' UNION ALL 
SELECT 3605, 328, 16, N'odpowiedzi' UNION ALL 
SELECT 3606, 328, 19, N'odpowiedzi' UNION ALL 
SELECT 3607, 328, 20, N'odpowiedzi' UNION ALL 
SELECT 3608, 328, 21, N'odpowiedziom' UNION ALL 
SELECT 3609, 328, 22, N'odpowiedzi' UNION ALL 
SELECT 3610, 328, 23, N'z odpowiedziami' UNION ALL 
SELECT 3611, 328, 24, N'odpowiedziach' UNION ALL 
SELECT 3612, 328, 25, N'odpowiedzi' UNION ALL 
SELECT 3613, 329, 10, N'to' UNION ALL 
SELECT 3614, 329, 11, N'tego' UNION ALL 
SELECT 3615, 329, 12, N'temu' UNION ALL 
SELECT 3616, 329, 13, N'to' UNION ALL 
SELECT 3617, 329, 14, N'z tym' UNION ALL 
SELECT 3618, 329, 15, N'tym' UNION ALL 
SELECT 3619, 329, 16, N'to' UNION ALL 
SELECT 3620, 330, 10, N'komputer' UNION ALL 
SELECT 3621, 330, 11, N'komputera' UNION ALL 
SELECT 3622, 330, 12, N'komputerowi' UNION ALL 
SELECT 3623, 330, 13, N'komputer' UNION ALL 
SELECT 3624, 330, 14, N'z komputerem' UNION ALL 
SELECT 3625, 330, 15, N'komputerze' UNION ALL 
SELECT 3626, 330, 16, N'komputerze' UNION ALL 
SELECT 3627, 330, 19, N'komputery' UNION ALL 
SELECT 3628, 330, 20, N'komputerów' UNION ALL 
SELECT 3629, 330, 21, N'komputerom' UNION ALL 
SELECT 3630, 330, 22, N'komputery' UNION ALL 
SELECT 3631, 330, 23, N'z komputerami' UNION ALL 
SELECT 3632, 330, 24, N'komputerach' UNION ALL 
SELECT 3633, 330, 25, N'komputery' UNION ALL 
SELECT 3634, 331, 10, N'gazeta' UNION ALL 
SELECT 3635, 331, 11, N'gazety' UNION ALL 
SELECT 3636, 331, 12, N'gazecie' UNION ALL 
SELECT 3637, 331, 13, N'gazetę' UNION ALL 
SELECT 3638, 331, 14, N'z gazetą' UNION ALL 
SELECT 3639, 331, 15, N'gazecie' UNION ALL 
SELECT 3640, 331, 16, N'gazeto' UNION ALL 
SELECT 3641, 331, 19, N'gazety' UNION ALL 
SELECT 3642, 331, 20, N'gazet' UNION ALL 
SELECT 3643, 331, 21, N'gazetom' UNION ALL 
SELECT 3644, 331, 22, N'gazety' UNION ALL 
SELECT 3645, 331, 23, N'z gazetami' UNION ALL 
SELECT 3646, 331, 24, N'gazetach' UNION ALL 
SELECT 3647, 331, 25, N'gazety' UNION ALL 
SELECT 3648, 332, 10, N'dokument' UNION ALL 
SELECT 3649, 332, 11, N'dokumentu' UNION ALL 
SELECT 3650, 332, 12, N'dokumentowi' UNION ALL 
SELECT 3651, 332, 13, N'dokument' UNION ALL 
SELECT 3652, 332, 14, N'z dokumentem' UNION ALL 
SELECT 3653, 332, 15, N'dokumencie' UNION ALL 
SELECT 3654, 332, 16, N'dokumencie' UNION ALL 
SELECT 3655, 332, 19, N'dokumenty' UNION ALL 
SELECT 3656, 332, 20, N'dokumentów' UNION ALL 
SELECT 3657, 332, 21, N'dokumentom' UNION ALL 
SELECT 3658, 332, 22, N'dokumenty' UNION ALL 
SELECT 3659, 332, 23, N'z dokumentami' UNION ALL 
SELECT 3660, 332, 24, N'dokumentach' UNION ALL 
SELECT 3661, 332, 25, N'dokumenty' UNION ALL 
SELECT 3662, 333, 10, N'wiersz' UNION ALL 
SELECT 3663, 333, 11, N'wiersza' UNION ALL 
SELECT 3664, 333, 12, N'wierszowi' UNION ALL 
SELECT 3665, 333, 13, N'wiersz' UNION ALL 
SELECT 3666, 333, 14, N'z wierszem' UNION ALL 
SELECT 3667, 333, 15, N'wierszu' UNION ALL 
SELECT 3668, 333, 16, N'wierszu' UNION ALL 
SELECT 3669, 333, 19, N'wiersze' UNION ALL 
SELECT 3670, 333, 20, N'wierszy' UNION ALL 
SELECT 3671, 333, 21, N'wierszom' UNION ALL 
SELECT 3672, 333, 22, N'wiersze' UNION ALL 
SELECT 3673, 333, 23, N'z wierszami' UNION ALL 
SELECT 3674, 333, 24, N'wierszach' UNION ALL 
SELECT 3675, 333, 25, N'wiersze' UNION ALL 
SELECT 3676, 334, 10, N'stół' UNION ALL 
SELECT 3677, 334, 11, N'stołu' UNION ALL 
SELECT 3678, 334, 12, N'stołowi' UNION ALL 
SELECT 3679, 334, 13, N'stół' UNION ALL 
SELECT 3680, 334, 14, N'ze stołem' UNION ALL 
SELECT 3681, 334, 15, N'stole' UNION ALL 
SELECT 3682, 334, 16, N'stole' UNION ALL 
SELECT 3683, 334, 19, N'stoły' UNION ALL 
SELECT 3684, 334, 20, N'stołów' UNION ALL 
SELECT 3685, 334, 21, N'stołom' UNION ALL 
SELECT 3686, 334, 22, N'stoły' UNION ALL 
SELECT 3687, 334, 23, N'ze stołami' UNION ALL 
SELECT 3688, 334, 24, N'stołach' UNION ALL 
SELECT 3689, 334, 25, N'stoły' UNION ALL 
SELECT 3690, 335, 10, N'krzesło' UNION ALL 
SELECT 3691, 335, 11, N'krzesła' UNION ALL 
SELECT 3692, 335, 12, N'krzesłu' UNION ALL 
SELECT 3693, 335, 13, N'krzesło' UNION ALL 
SELECT 3694, 335, 14, N'z krzesłem' UNION ALL 
SELECT 3695, 335, 15, N'krześle' UNION ALL 
SELECT 3696, 335, 16, N'krzesło' UNION ALL 
SELECT 3697, 335, 19, N'krzesła' UNION ALL 
SELECT 3698, 335, 20, N'krzeseł' UNION ALL 
SELECT 3699, 335, 21, N'krzesłom' UNION ALL 
SELECT 3700, 335, 22, N'krzesła' UNION ALL 
SELECT 3701, 335, 23, N'z krzesłami' UNION ALL 
SELECT 3702, 335, 24, N'krzesłach' UNION ALL 
SELECT 3703, 335, 25, N'krzesła' UNION ALL 
SELECT 3704, 336, 10, N'podłoga' UNION ALL 
SELECT 3705, 336, 11, N'podłogi' UNION ALL 
SELECT 3706, 336, 12, N'podłodze' UNION ALL 
SELECT 3707, 336, 13, N'podłogę' UNION ALL 
SELECT 3708, 336, 14, N'z podłogą' UNION ALL 
SELECT 3709, 336, 15, N'podłodze' UNION ALL 
SELECT 3710, 336, 16, N'podłogo' UNION ALL 
SELECT 3711, 336, 17, N'na podłogę' UNION ALL 
SELECT 3712, 336, 18, N'na podłodze' UNION ALL 
SELECT 3713, 336, 19, N'podłogi' UNION ALL 
SELECT 3714, 336, 20, N'podłóg' UNION ALL 
SELECT 3715, 336, 21, N'podłogom' UNION ALL 
SELECT 3716, 336, 22, N'podłogi' UNION ALL 
SELECT 3717, 336, 23, N'z podłogami' UNION ALL 
SELECT 3718, 336, 24, N'podłogach' UNION ALL 
SELECT 3719, 336, 25, N'podłogi' UNION ALL 
SELECT 3720, 337, 10, N'łóżko' UNION ALL 
SELECT 3721, 337, 11, N'łóżka' UNION ALL 
SELECT 3722, 337, 12, N'łóżku' UNION ALL 
SELECT 3723, 337, 13, N'łóżko' UNION ALL 
SELECT 3724, 337, 14, N'z łóżkiem' UNION ALL 
SELECT 3725, 337, 15, N'łóżku' UNION ALL 
SELECT 3726, 337, 16, N'łóżko' UNION ALL 
SELECT 3727, 337, 17, N'do łóżka' UNION ALL 
SELECT 3728, 337, 18, N'w łóżku' UNION ALL 
SELECT 3729, 337, 19, N'łóżka' UNION ALL 
SELECT 3730, 337, 20, N'łóżek' UNION ALL 
SELECT 3731, 337, 21, N'łóżkom' UNION ALL 
SELECT 3732, 337, 22, N'łóżka' UNION ALL 
SELECT 3733, 337, 23, N'z łóżkami' UNION ALL 
SELECT 3734, 337, 24, N'łóżkach' UNION ALL 
SELECT 3735, 337, 25, N'łóżka' UNION ALL 
SELECT 3736, 338, 10, N'zbrodnia' UNION ALL 
SELECT 3737, 338, 11, N'zbrodni' UNION ALL 
SELECT 3738, 338, 12, N'zbrodni' UNION ALL 
SELECT 3739, 338, 13, N'zbrodnię' UNION ALL 
SELECT 3740, 338, 14, N'ze zbrodnią' UNION ALL 
SELECT 3741, 338, 15, N'zbrodni' UNION ALL 
SELECT 3742, 338, 16, N'zbrodnio' UNION ALL 
SELECT 3743, 338, 19, N'zbrodnie' UNION ALL 
SELECT 3744, 338, 20, N'zbrodni' UNION ALL 
SELECT 3745, 338, 21, N'zbrodniom' UNION ALL 
SELECT 3746, 338, 22, N'zbrodnie' UNION ALL 
SELECT 3747, 338, 23, N'ze zbrodniami' UNION ALL 
SELECT 3748, 338, 24, N'zbrodniach' UNION ALL 
SELECT 3749, 338, 25, N'zbrodnie' UNION ALL 
SELECT 3750, 339, 10, N'przestępstwo' UNION ALL 
SELECT 3751, 339, 11, N'przestępstwa' UNION ALL 
SELECT 3752, 339, 12, N'przestępstwu' UNION ALL 
SELECT 3753, 339, 13, N'przestępstwo' UNION ALL 
SELECT 3754, 339, 14, N'z przestępstwem' UNION ALL 
SELECT 3755, 339, 15, N'przestępstwie' UNION ALL 
SELECT 3756, 339, 16, N'przestępstwo' UNION ALL 
SELECT 3757, 339, 19, N'przestępstwa' UNION ALL 
SELECT 3758, 339, 20, N'przestępstw' UNION ALL 
SELECT 3759, 339, 21, N'przestępstwom' UNION ALL 
SELECT 3760, 339, 22, N'przestępstwa' UNION ALL 
SELECT 3761, 339, 23, N'z przestępstwami' UNION ALL 
SELECT 3762, 339, 24, N'przestępstwach' UNION ALL 
SELECT 3763, 339, 25, N'przestępstwa' UNION ALL 
SELECT 3764, 340, 10, N'groźba' UNION ALL 
SELECT 3765, 340, 11, N'groźby' UNION ALL 
SELECT 3766, 340, 12, N'groźbie' UNION ALL 
SELECT 3767, 340, 13, N'groźbę' UNION ALL 
SELECT 3768, 340, 14, N'z groźbą' UNION ALL 
SELECT 3769, 340, 15, N'groźbie' UNION ALL 
SELECT 3770, 340, 16, N'groźbo' UNION ALL 
SELECT 3771, 340, 19, N'groźby' UNION ALL 
SELECT 3772, 340, 20, N'gróźb' UNION ALL 
SELECT 3773, 340, 21, N'groźbom' UNION ALL 
SELECT 3774, 340, 22, N'groźby' UNION ALL 
SELECT 3775, 340, 23, N'z groźbami' UNION ALL 
SELECT 3776, 340, 24, N'groźbach' UNION ALL 
SELECT 3777, 340, 25, N'groźby' UNION ALL 
SELECT 3778, 341, 10, N'podpucha' UNION ALL 
SELECT 3779, 341, 11, N'podpuchy' UNION ALL 
SELECT 3780, 341, 12, N'podpusze' UNION ALL 
SELECT 3781, 341, 13, N'podpuchę' UNION ALL 
SELECT 3782, 341, 14, N'z podpuchą' UNION ALL 
SELECT 3783, 341, 15, N'podpusze' UNION ALL 
SELECT 3784, 341, 16, N'podpucho' UNION ALL 
SELECT 3785, 341, 19, N'podpuchy' UNION ALL 
SELECT 3786, 341, 20, N'podpuch' UNION ALL 
SELECT 3787, 341, 21, N'podpuchom' UNION ALL 
SELECT 3788, 341, 22, N'podpuchy' UNION ALL 
SELECT 3789, 341, 23, N'z podpuchami' UNION ALL 
SELECT 3790, 341, 24, N'podpuchach' UNION ALL 
SELECT 3791, 341, 25, N'podpuchy' UNION ALL 
SELECT 3792, 342, 10, N'żart' UNION ALL 
SELECT 3793, 342, 11, N'żartu' UNION ALL 
SELECT 3794, 342, 12, N'żartowi' UNION ALL 
SELECT 3795, 342, 13, N'żart' UNION ALL 
SELECT 3796, 342, 14, N'z żartem' UNION ALL 
SELECT 3797, 342, 15, N'żarcie' UNION ALL 
SELECT 3798, 342, 16, N'żarcie' UNION ALL 
SELECT 3799, 342, 19, N'żarty' UNION ALL 
SELECT 3800, 342, 20, N'żartów' UNION ALL 
SELECT 3801, 342, 21, N'żartom' UNION ALL 
SELECT 3802, 342, 22, N'żarty' UNION ALL 
SELECT 3803, 342, 23, N'z żartami' UNION ALL 
SELECT 3804, 342, 24, N'żartach' UNION ALL 
SELECT 3805, 342, 25, N'żarty' UNION ALL 
SELECT 3806, 343, 10, N'koncert' UNION ALL 
SELECT 3807, 343, 11, N'koncertu' UNION ALL 
SELECT 3808, 343, 12, N'koncertowi' UNION ALL 
SELECT 3809, 343, 13, N'koncert' UNION ALL 
SELECT 3810, 343, 14, N'z koncertem' UNION ALL 
SELECT 3811, 343, 15, N'koncercie' UNION ALL 
SELECT 3812, 343, 16, N'koncercie' UNION ALL 
SELECT 3813, 343, 17, N'na koncert' UNION ALL 
SELECT 3814, 343, 18, N'na koncercie' UNION ALL 
SELECT 3815, 343, 19, N'koncerty' UNION ALL 
SELECT 3816, 343, 20, N'koncertów' UNION ALL 
SELECT 3817, 343, 21, N'koncertom' UNION ALL 
SELECT 3818, 343, 22, N'koncerty' UNION ALL 
SELECT 3819, 343, 23, N'z koncertami' UNION ALL 
SELECT 3820, 343, 24, N'koncertach' UNION ALL 
SELECT 3821, 343, 25, N'koncerty' UNION ALL 
SELECT 3822, 344, 10, N'Średniowiecze' UNION ALL 
SELECT 3823, 344, 11, N'Średniowiecza' UNION ALL 
SELECT 3824, 344, 12, N'Średniowieczu' UNION ALL 
SELECT 3825, 344, 13, N'Średniowiecze' UNION ALL 
SELECT 3826, 344, 14, N'ze Średniowieczem' UNION ALL 
SELECT 3827, 344, 15, N'Średniowieczu' UNION ALL 
SELECT 3828, 344, 16, N'Średniowiecze' UNION ALL 
SELECT 3829, 345, 10, N'wojna domowa' UNION ALL 
SELECT 3830, 345, 11, N'wojny domowej' UNION ALL 
SELECT 3831, 345, 12, N'wojnie domowej' UNION ALL 
SELECT 3832, 345, 13, N'wojnę domową' UNION ALL 
SELECT 3833, 345, 14, N'z wojną domową' UNION ALL 
SELECT 3834, 345, 15, N'wojnie domowej' UNION ALL 
SELECT 3835, 345, 16, N'wojno domowa' UNION ALL 
SELECT 3836, 345, 19, N'wojny domowe' UNION ALL 
SELECT 3837, 345, 20, N'wojen domowych' UNION ALL 
SELECT 3838, 345, 21, N'wojnom domowym' UNION ALL 
SELECT 3839, 345, 22, N'wojny domowe' UNION ALL 
SELECT 3840, 345, 23, N'z wojnami domowymi' UNION ALL 
SELECT 3841, 345, 24, N'wojnach domowych' UNION ALL 
SELECT 3842, 345, 25, N'wojny domowe' UNION ALL 
SELECT 3843, 346, 10, N'finał' UNION ALL 
SELECT 3844, 346, 11, N'finału' UNION ALL 
SELECT 3845, 346, 12, N'finałowi' UNION ALL 
SELECT 3846, 346, 13, N'finał' UNION ALL 
SELECT 3847, 346, 14, N'z finałem' UNION ALL 
SELECT 3848, 346, 15, N'finale' UNION ALL 
SELECT 3849, 346, 16, N'finale' UNION ALL 
SELECT 3850, 346, 19, N'finały' UNION ALL 
SELECT 3851, 346, 20, N'finałów' UNION ALL 
SELECT 3852, 346, 21, N'finałom' UNION ALL 
SELECT 3853, 346, 22, N'finały' UNION ALL 
SELECT 3854, 346, 23, N'z finałami' UNION ALL 
SELECT 3855, 346, 24, N'finałach' UNION ALL 
SELECT 3856, 346, 25, N'finały' UNION ALL 
SELECT 3857, 347, 10, N'życie' UNION ALL 
SELECT 3858, 347, 11, N'życia' UNION ALL 
SELECT 3859, 347, 12, N'życiu' UNION ALL 
SELECT 3860, 347, 13, N'życie' UNION ALL 
SELECT 3861, 347, 14, N'z życiem' UNION ALL 
SELECT 3862, 347, 15, N'życiu' UNION ALL 
SELECT 3863, 347, 16, N'życie' UNION ALL 
SELECT 3864, 347, 19, N'życia' UNION ALL 
SELECT 3865, 347, 20, N'żyć' UNION ALL 
SELECT 3866, 347, 21, N'życiom' UNION ALL 
SELECT 3867, 347, 22, N'życia' UNION ALL 
SELECT 3868, 347, 23, N'z życiami' UNION ALL 
SELECT 3869, 347, 24, N'życiach' UNION ALL 
SELECT 3870, 347, 25, N'życia' UNION ALL 
SELECT 3871, 348, 10, N'skorpion' UNION ALL 
SELECT 3872, 348, 11, N'skorpiona' UNION ALL 
SELECT 3873, 348, 12, N'skorpionowi' UNION ALL 
SELECT 3874, 348, 13, N'skorpiona' UNION ALL 
SELECT 3875, 348, 14, N'ze skorpionem' UNION ALL 
SELECT 3876, 348, 15, N'skorpionie' UNION ALL 
SELECT 3877, 348, 16, N'skorpionie' UNION ALL 
SELECT 3878, 348, 19, N'skorpiony' UNION ALL 
SELECT 3879, 348, 20, N'skorpionów' UNION ALL 
SELECT 3880, 348, 21, N'skorpionom' UNION ALL 
SELECT 3881, 348, 22, N'skorpiony' UNION ALL 
SELECT 3882, 348, 23, N'ze skorpionami' UNION ALL 
SELECT 3883, 348, 24, N'skorpionach' UNION ALL 
SELECT 3884, 348, 25, N'skorpiony' UNION ALL 
SELECT 3885, 349, 10, N'płaszczka' UNION ALL 
SELECT 3886, 349, 11, N'płaszczki' UNION ALL 
SELECT 3887, 349, 12, N'płaszczce' UNION ALL 
SELECT 3888, 349, 13, N'płaszczkę' UNION ALL 
SELECT 3889, 349, 14, N'z płaszczką' UNION ALL 
SELECT 3890, 349, 15, N'płaszczce' UNION ALL 
SELECT 3891, 349, 16, N'płaszczko' UNION ALL 
SELECT 3892, 349, 19, N'płaszczki' UNION ALL 
SELECT 3893, 349, 20, N'płaszczek' UNION ALL 
SELECT 3894, 349, 21, N'płaszczkom' UNION ALL 
SELECT 3895, 349, 22, N'płaszczki' UNION ALL 
SELECT 3896, 349, 23, N'z płaszczkami' UNION ALL 
SELECT 3897, 349, 24, N'płaszczkach' UNION ALL 
SELECT 3898, 349, 25, N'płaszczki' UNION ALL 
SELECT 3899, 350, 10, N'meduza' UNION ALL 
SELECT 3900, 350, 11, N'meduzy' UNION ALL 
SELECT 3901, 350, 12, N'meduzie' UNION ALL 
SELECT 3902, 350, 13, N'meduzę' UNION ALL 
SELECT 3903, 350, 14, N'z meduzą' UNION ALL 
SELECT 3904, 350, 15, N'meduzie' UNION ALL 
SELECT 3905, 350, 16, N'meduzo' UNION ALL 
SELECT 3906, 350, 19, N'meduzy' UNION ALL 
SELECT 3907, 350, 20, N'meduz' UNION ALL 
SELECT 3908, 350, 21, N'meduzom' UNION ALL 
SELECT 3909, 350, 22, N'meduzy' UNION ALL 
SELECT 3910, 350, 23, N'z meduzami' UNION ALL 
SELECT 3911, 350, 24, N'meduzach' UNION ALL 
SELECT 3912, 350, 25, N'meduzy' UNION ALL 
SELECT 3913, 351, 10, N'szerszeń' UNION ALL 
SELECT 3914, 351, 11, N'szerszenia' UNION ALL 
SELECT 3915, 351, 12, N'szerszeniowi' UNION ALL 
SELECT 3916, 351, 13, N'szerszenia' UNION ALL 
SELECT 3917, 351, 14, N'z szerszeniem' UNION ALL 
SELECT 3918, 351, 15, N'szerszeniu' UNION ALL 
SELECT 3919, 351, 16, N'szerszeniu' UNION ALL 
SELECT 3920, 351, 19, N'szerszenie' UNION ALL 
SELECT 3921, 351, 20, N'szerszeni' UNION ALL 
SELECT 3922, 351, 21, N'szerszeniom' UNION ALL 
SELECT 3923, 351, 22, N'szerszenie' UNION ALL 
SELECT 3924, 351, 23, N'z szerszeniami' UNION ALL 
SELECT 3925, 351, 24, N'szerszeniach' UNION ALL 
SELECT 3926, 351, 25, N'szerszenie' UNION ALL 
SELECT 3927, 352, 10, N'kleszcz' UNION ALL 
SELECT 3928, 352, 11, N'kleszcza' UNION ALL 
SELECT 3929, 352, 12, N'kleszczowi' UNION ALL 
SELECT 3930, 352, 13, N'kleszcza' UNION ALL 
SELECT 3931, 352, 14, N'z kleszczem' UNION ALL 
SELECT 3932, 352, 15, N'kleszczu' UNION ALL 
SELECT 3933, 352, 16, N'kleszczu' UNION ALL 
SELECT 3934, 352, 19, N'kleszcze' UNION ALL 
SELECT 3935, 352, 20, N'kleszczy' UNION ALL 
SELECT 3936, 352, 21, N'kleszczom' UNION ALL 
SELECT 3937, 352, 22, N'kleszcze' UNION ALL 
SELECT 3938, 352, 23, N'z kleszczami' UNION ALL 
SELECT 3939, 352, 24, N'kleszczach' UNION ALL 
SELECT 3940, 352, 25, N'kleszcze' UNION ALL 
SELECT 3941, 353, 10, N'grzechotnik' UNION ALL 
SELECT 3942, 353, 11, N'grzechotnika' UNION ALL 
SELECT 3943, 353, 12, N'grzechotnikowi' UNION ALL 
SELECT 3944, 353, 13, N'grzechotnika' UNION ALL 
SELECT 3945, 353, 14, N'z grzechotnikiem' UNION ALL 
SELECT 3946, 353, 15, N'grzechotniku' UNION ALL 
SELECT 3947, 353, 16, N'grzechotniku' UNION ALL 
SELECT 3948, 353, 19, N'grzechotniki' UNION ALL 
SELECT 3949, 353, 20, N'grzechotników' UNION ALL 
SELECT 3950, 353, 21, N'grzechotnikom' UNION ALL 
SELECT 3951, 353, 22, N'grzechotniki' UNION ALL 
SELECT 3952, 353, 23, N'z grzechotnikami' UNION ALL 
SELECT 3953, 353, 24, N'grzechotnikach' UNION ALL 
SELECT 3954, 353, 25, N'grzechotniki' UNION ALL 
SELECT 3955, 354, 10, N'żmija' UNION ALL 
SELECT 3956, 354, 11, N'żmii' UNION ALL 
SELECT 3957, 354, 12, N'żmii' UNION ALL 
SELECT 3958, 354, 13, N'żmiję' UNION ALL 
SELECT 3959, 354, 14, N'ze żmiją' UNION ALL 
SELECT 3960, 354, 15, N'żmii' UNION ALL 
SELECT 3961, 354, 16, N'żmijo' UNION ALL 
SELECT 3962, 354, 19, N'żmije' UNION ALL 
SELECT 3963, 354, 20, N'żmij' UNION ALL 
SELECT 3964, 354, 21, N'żmijom' UNION ALL 
SELECT 3965, 354, 22, N'żmije' UNION ALL 
SELECT 3966, 354, 23, N'ze żmijami' UNION ALL 
SELECT 3967, 354, 24, N'żmijach' UNION ALL 
SELECT 3968, 354, 25, N'żmije' UNION ALL 
SELECT 3969, 355, 10, N'dowód' UNION ALL 
SELECT 3970, 355, 11, N'dowodu' UNION ALL 
SELECT 3971, 355, 12, N'dowodowi' UNION ALL 
SELECT 3972, 355, 13, N'dowód' UNION ALL 
SELECT 3973, 355, 14, N'z dowodem' UNION ALL 
SELECT 3974, 355, 15, N'dowodzie' UNION ALL 
SELECT 3975, 355, 16, N'dowodzie' UNION ALL 
SELECT 3976, 355, 19, N'dowody' UNION ALL 
SELECT 3977, 355, 20, N'dowodów' UNION ALL 
SELECT 3978, 355, 21, N'dowodom' UNION ALL 
SELECT 3979, 355, 22, N'dowody' UNION ALL 
SELECT 3980, 355, 23, N'z dowodami' UNION ALL 
SELECT 3981, 355, 24, N'dowodach' UNION ALL 
SELECT 3982, 355, 25, N'dowody' UNION ALL 
SELECT 3983, 356, 19, N'dane' UNION ALL 
SELECT 3984, 356, 20, N'danych' UNION ALL 
SELECT 3985, 356, 21, N'danym' UNION ALL 
SELECT 3986, 356, 22, N'dane' UNION ALL 
SELECT 3987, 356, 23, N'z danymi' UNION ALL 
SELECT 3988, 356, 24, N'danych' UNION ALL 
SELECT 3989, 356, 25, N'dane' UNION ALL 
SELECT 3990, 357, 10, N'statystyka' UNION ALL 
SELECT 3991, 357, 11, N'statystyki' UNION ALL 
SELECT 3992, 357, 12, N'statystyce' UNION ALL 
SELECT 3993, 357, 13, N'statystykę' UNION ALL 
SELECT 3994, 357, 14, N'ze statystyką' UNION ALL 
SELECT 3995, 357, 15, N'statystyce' UNION ALL 
SELECT 3996, 357, 16, N'statystyko' UNION ALL 
SELECT 3997, 357, 19, N'statystyki' UNION ALL 
SELECT 3998, 357, 20, N'statystyk' UNION ALL 
SELECT 3999, 357, 21, N'statystykom' UNION ALL 
SELECT 4000, 357, 22, N'statystyki' UNION ALL 
SELECT 4001, 357, 23, N'ze statystykami' UNION ALL 
SELECT 4002, 357, 24, N'statystykach' UNION ALL 
SELECT 4003, 357, 25, N'statystyki' UNION ALL 
SELECT 4004, 358, 10, N'skóra' UNION ALL 
SELECT 4005, 358, 11, N'skóry' UNION ALL 
SELECT 4006, 358, 12, N'skórze' UNION ALL 
SELECT 4007, 358, 13, N'skórę' UNION ALL 
SELECT 4008, 358, 14, N'ze skórą' UNION ALL 
SELECT 4009, 358, 15, N'skórze' UNION ALL 
SELECT 4010, 358, 16, N'skóro' UNION ALL 
SELECT 4011, 358, 19, N'skóry' UNION ALL 
SELECT 4012, 358, 20, N'skór' UNION ALL 
SELECT 4013, 358, 21, N'skórom' UNION ALL 
SELECT 4014, 358, 22, N'skóry' UNION ALL 
SELECT 4015, 358, 23, N'ze skórami' UNION ALL 
SELECT 4016, 358, 24, N'skórach' UNION ALL 
SELECT 4017, 358, 25, N'skóry' UNION ALL 
SELECT 4018, 359, 10, N'miejsce' UNION ALL 
SELECT 4019, 359, 11, N'miejsca' UNION ALL 
SELECT 4020, 359, 12, N'miejscu' UNION ALL 
SELECT 4021, 359, 13, N'miejsce' UNION ALL 
SELECT 4022, 359, 14, N'z miejscem' UNION ALL 
SELECT 4023, 359, 15, N'miejscu' UNION ALL 
SELECT 4024, 359, 16, N'miejsce' UNION ALL 
SELECT 4025, 359, 17, N'do miejsca' UNION ALL 
SELECT 4026, 359, 18, N'w miejscu' UNION ALL 
SELECT 4027, 359, 19, N'miejsca' UNION ALL 
SELECT 4028, 359, 20, N'miejsc' UNION ALL 
SELECT 4029, 359, 21, N'miejscom' UNION ALL 
SELECT 4030, 359, 22, N'miejsca' UNION ALL 
SELECT 4031, 359, 23, N'z miejscami' UNION ALL 
SELECT 4032, 359, 24, N'miejscach' UNION ALL 
SELECT 4033, 359, 25, N'miejsca' UNION ALL 
SELECT 4034, 360, 10, N'ujęcie' UNION ALL 
SELECT 4035, 360, 11, N'ujęcia' UNION ALL 
SELECT 4036, 360, 12, N'ujęciu' UNION ALL 
SELECT 4037, 360, 13, N'ujęcie' UNION ALL 
SELECT 4038, 360, 14, N'z ujęciem' UNION ALL 
SELECT 4039, 360, 15, N'ujęciu' UNION ALL 
SELECT 4040, 360, 16, N'ujęcie' UNION ALL 
SELECT 4041, 360, 19, N'ujęcia' UNION ALL 
SELECT 4042, 360, 20, N'ujęć' UNION ALL 
SELECT 4043, 360, 21, N'ujęciom' UNION ALL 
SELECT 4044, 360, 22, N'ujęcia' UNION ALL 
SELECT 4045, 360, 23, N'z ujęciami' UNION ALL 
SELECT 4046, 360, 24, N'ujęciach' UNION ALL 
SELECT 4047, 360, 25, N'ujęcia' UNION ALL 
SELECT 4048, 361, 10, N'wyjaśnienie' UNION ALL 
SELECT 4049, 361, 11, N'wyjaśnienia' UNION ALL 
SELECT 4050, 361, 12, N'wyjaśnieniu' UNION ALL 
SELECT 4051, 361, 13, N'wyjaśnienie' UNION ALL 
SELECT 4052, 361, 14, N'z wyjaśnieniem' UNION ALL 
SELECT 4053, 361, 15, N'wyjaśnieniu' UNION ALL 
SELECT 4054, 361, 16, N'wyjaśnienie' UNION ALL 
SELECT 4055, 361, 19, N'wyjaśnienia' UNION ALL 
SELECT 4056, 361, 20, N'wyjaśnień' UNION ALL 
SELECT 4057, 361, 21, N'wyjaśnieniom' UNION ALL 
SELECT 4058, 361, 22, N'wyjaśnienia' UNION ALL 
SELECT 4059, 361, 23, N'z wyjaśnieniami' UNION ALL 
SELECT 4060, 361, 24, N'wyjaśnieniach' UNION ALL 
SELECT 4061, 361, 25, N'wyjaśnienia' UNION ALL 
SELECT 4062, 362, 10, N'powód' UNION ALL 
SELECT 4063, 362, 11, N'powódu' UNION ALL 
SELECT 4064, 362, 12, N'powódowi' UNION ALL 
SELECT 4065, 362, 13, N'powód' UNION ALL 
SELECT 4066, 362, 14, N'z powódem' UNION ALL 
SELECT 4067, 362, 15, N'powódzie' UNION ALL 
SELECT 4068, 362, 16, N'powódzie' UNION ALL 
SELECT 4069, 362, 19, N'powódy' UNION ALL 
SELECT 4070, 362, 20, N'powódów' UNION ALL 
SELECT 4071, 362, 21, N'powódom' UNION ALL 
SELECT 4072, 362, 22, N'powódy' UNION ALL 
SELECT 4073, 362, 23, N'z powódami' UNION ALL 
SELECT 4074, 362, 24, N'powódach' UNION ALL 
SELECT 4075, 362, 25, N'powódy' UNION ALL 
SELECT 4076, 363, 10, N'szansa' UNION ALL 
SELECT 4077, 363, 11, N'szansy' UNION ALL 
SELECT 4078, 363, 12, N'szansie' UNION ALL 
SELECT 4079, 363, 13, N'szansę' UNION ALL 
SELECT 4080, 363, 14, N'z szansą' UNION ALL 
SELECT 4081, 363, 15, N'szansie' UNION ALL 
SELECT 4082, 363, 16, N'szanso' UNION ALL 
SELECT 4083, 363, 19, N'szansy' UNION ALL 
SELECT 4084, 363, 20, N'szans' UNION ALL 
SELECT 4085, 363, 21, N'szansom' UNION ALL 
SELECT 4086, 363, 22, N'szansy' UNION ALL 
SELECT 4087, 363, 23, N'z szansami' UNION ALL 
SELECT 4088, 363, 24, N'szansach' UNION ALL 
SELECT 4089, 363, 25, N'szansy' UNION ALL 
SELECT 4090, 364, 10, N'osoba' UNION ALL 
SELECT 4091, 364, 11, N'osoby' UNION ALL 
SELECT 4092, 364, 12, N'osobie' UNION ALL 
SELECT 4093, 364, 13, N'osobę' UNION ALL 
SELECT 4094, 364, 14, N'z osobą' UNION ALL 
SELECT 4095, 364, 15, N'osobie' UNION ALL 
SELECT 4096, 364, 16, N'osobo' UNION ALL 
SELECT 4097, 364, 19, N'osoby' UNION ALL 
SELECT 4098, 364, 20, N'osób' UNION ALL 
SELECT 4099, 364, 21, N'osobom' UNION ALL 
SELECT 4100, 364, 22, N'osoby' UNION ALL 
SELECT 4101, 364, 23, N'z osobami' UNION ALL 
SELECT 4102, 364, 24, N'osobach' UNION ALL 
SELECT 4103, 364, 25, N'osoby' UNION ALL 
SELECT 4104, 365, 10, N'pytanie' UNION ALL 
SELECT 4105, 365, 11, N'pytania' UNION ALL 
SELECT 4106, 365, 12, N'pytaniu' UNION ALL 
SELECT 4107, 365, 13, N'pytanie' UNION ALL 
SELECT 4108, 365, 14, N'z pytaniem' UNION ALL 
SELECT 4109, 365, 15, N'pytaniu' UNION ALL 
SELECT 4110, 365, 16, N'pytanie' UNION ALL 
SELECT 4111, 365, 19, N'pytania' UNION ALL 
SELECT 4112, 365, 20, N'pytań' UNION ALL 
SELECT 4113, 365, 21, N'pytaniom' UNION ALL 
SELECT 4114, 365, 22, N'pytania' UNION ALL 
SELECT 4115, 365, 23, N'z pytaniami' UNION ALL 
SELECT 4116, 365, 24, N'pytaniach' UNION ALL 
SELECT 4117, 365, 25, N'pytania' UNION ALL 
SELECT 4118, 366, 10, N'wymóg' UNION ALL 
SELECT 4119, 366, 11, N'wymogu' UNION ALL 
SELECT 4120, 366, 12, N'wymogowi' UNION ALL 
SELECT 4121, 366, 13, N'wymóg' UNION ALL 
SELECT 4122, 366, 14, N'z wymogiem' UNION ALL 
SELECT 4123, 366, 15, N'wymogu' UNION ALL 
SELECT 4124, 366, 16, N'wymogu' UNION ALL 
SELECT 4125, 366, 19, N'wymogi' UNION ALL 
SELECT 4126, 366, 20, N'wymogów' UNION ALL 
SELECT 4127, 366, 21, N'wymogom' UNION ALL 
SELECT 4128, 366, 22, N'wymogi' UNION ALL 
SELECT 4129, 366, 23, N'z wymogami' UNION ALL 
SELECT 4130, 366, 24, N'wymogach' UNION ALL 
SELECT 4131, 366, 25, N'wymogi' UNION ALL 
SELECT 4132, 367, 10, N'różnica' UNION ALL 
SELECT 4133, 367, 11, N'różnicy' UNION ALL 
SELECT 4134, 367, 12, N'różnicy' UNION ALL 
SELECT 4135, 367, 13, N'różnicę' UNION ALL 
SELECT 4136, 367, 14, N'z różnicą' UNION ALL 
SELECT 4137, 367, 15, N'różnicy' UNION ALL 
SELECT 4138, 367, 16, N'różnico' UNION ALL 
SELECT 4139, 367, 19, N'różnice' UNION ALL 
SELECT 4140, 367, 20, N'różnic' UNION ALL 
SELECT 4141, 367, 21, N'różnicom' UNION ALL 
SELECT 4142, 367, 22, N'różnice' UNION ALL 
SELECT 4143, 367, 23, N'z różnicami' UNION ALL 
SELECT 4144, 367, 24, N'różnicach' UNION ALL 
SELECT 4145, 367, 25, N'różnicy' UNION ALL 
SELECT 4146, 368, 10, N'problem' UNION ALL 
SELECT 4147, 368, 11, N'problemu' UNION ALL 
SELECT 4148, 368, 12, N'problemowi' UNION ALL 
SELECT 4149, 368, 13, N'problem' UNION ALL 
SELECT 4150, 368, 14, N'z problemem' UNION ALL 
SELECT 4151, 368, 15, N'problemie' UNION ALL 
SELECT 4152, 368, 16, N'problemie' UNION ALL 
SELECT 4153, 368, 19, N'problemy' UNION ALL 
SELECT 4154, 368, 20, N'problemów' UNION ALL 
SELECT 4155, 368, 21, N'problemom' UNION ALL 
SELECT 4156, 368, 22, N'problemy' UNION ALL 
SELECT 4157, 368, 23, N'z problemami' UNION ALL 
SELECT 4158, 368, 24, N'problemach' UNION ALL 
SELECT 4159, 368, 25, N'problemy' UNION ALL 
SELECT 4160, 369, 10, N'wybór' UNION ALL 
SELECT 4161, 369, 11, N'wyboru' UNION ALL 
SELECT 4162, 369, 12, N'wyborowi' UNION ALL 
SELECT 4163, 369, 13, N'wybór' UNION ALL 
SELECT 4164, 369, 14, N'z wyborem' UNION ALL 
SELECT 4165, 369, 15, N'wyborze' UNION ALL 
SELECT 4166, 369, 16, N'wyborze' UNION ALL 
SELECT 4167, 369, 19, N'wybory' UNION ALL 
SELECT 4168, 369, 20, N'wyborów' UNION ALL 
SELECT 4169, 369, 21, N'wyborom' UNION ALL 
SELECT 4170, 369, 22, N'wybory' UNION ALL 
SELECT 4171, 369, 23, N'z wyborami' UNION ALL 
SELECT 4172, 369, 24, N'wyborach' UNION ALL 
SELECT 4173, 369, 25, N'wybory' UNION ALL 
SELECT 4174, 370, 10, N'mapa' UNION ALL 
SELECT 4175, 370, 11, N'mapy' UNION ALL 
SELECT 4176, 370, 12, N'mapie' UNION ALL 
SELECT 4177, 370, 13, N'mapę' UNION ALL 
SELECT 4178, 370, 14, N'z mapą' UNION ALL 
SELECT 4179, 370, 15, N'mapie' UNION ALL 
SELECT 4180, 370, 16, N'mapo' UNION ALL 
SELECT 4181, 370, 19, N'mapy' UNION ALL 
SELECT 4182, 370, 20, N'map' UNION ALL 
SELECT 4183, 370, 21, N'mapom' UNION ALL 
SELECT 4184, 370, 22, N'mapy' UNION ALL 
SELECT 4185, 370, 23, N'z mapami' UNION ALL 
SELECT 4186, 370, 24, N'mapach' UNION ALL 
SELECT 4187, 370, 25, N'mapy' UNION ALL 
SELECT 4188, 371, 10, N'wykres' UNION ALL 
SELECT 4189, 371, 11, N'wykresu' UNION ALL 
SELECT 4190, 371, 12, N'wykresowi' UNION ALL 
SELECT 4191, 371, 13, N'wykres' UNION ALL 
SELECT 4192, 371, 14, N'z wykresem' UNION ALL 
SELECT 4193, 371, 15, N'wykresie' UNION ALL 
SELECT 4194, 371, 16, N'wykresie' UNION ALL 
SELECT 4195, 371, 19, N'wykresy' UNION ALL 
SELECT 4196, 371, 20, N'wykresów' UNION ALL 
SELECT 4197, 371, 21, N'wykresom' UNION ALL 
SELECT 4198, 371, 22, N'wykresy' UNION ALL 
SELECT 4199, 371, 23, N'z wykresami' UNION ALL 
SELECT 4200, 371, 24, N'wykresach' UNION ALL 
SELECT 4201, 371, 25, N'wykresy' UNION ALL 
SELECT 4202, 372, 10, N'założenie' UNION ALL 
SELECT 4203, 372, 11, N'założenia' UNION ALL 
SELECT 4204, 372, 12, N'założeniu' UNION ALL 
SELECT 4205, 372, 13, N'założenie' UNION ALL 
SELECT 4206, 372, 14, N'z założeniem' UNION ALL 
SELECT 4207, 372, 15, N'założeniu' UNION ALL 
SELECT 4208, 372, 16, N'założenie' UNION ALL 
SELECT 4209, 372, 19, N'założenia' UNION ALL 
SELECT 4210, 372, 20, N'założeń' UNION ALL 
SELECT 4211, 372, 21, N'założeniom' UNION ALL 
SELECT 4212, 372, 22, N'założenia' UNION ALL 
SELECT 4213, 372, 23, N'z założeniami' UNION ALL 
SELECT 4214, 372, 24, N'założeniach' UNION ALL 
SELECT 4215, 372, 25, N'założenia' UNION ALL 
SELECT 4216, 373, 10, N'wynik' UNION ALL 
SELECT 4217, 373, 11, N'wyniku' UNION ALL 
SELECT 4218, 373, 12, N'wynikowi' UNION ALL 
SELECT 4219, 373, 13, N'wynik' UNION ALL 
SELECT 4220, 373, 14, N'z wynikiem' UNION ALL 
SELECT 4221, 373, 15, N'wyniku' UNION ALL 
SELECT 4222, 373, 16, N'wyniku' UNION ALL 
SELECT 4223, 373, 19, N'wyniki' UNION ALL 
SELECT 4224, 373, 20, N'wyników' UNION ALL 
SELECT 4225, 373, 21, N'wynikom' UNION ALL 
SELECT 4226, 373, 22, N'wyniki' UNION ALL 
SELECT 4227, 373, 23, N'z wynikami' UNION ALL 
SELECT 4228, 373, 24, N'wynikach' UNION ALL 
SELECT 4229, 373, 25, N'wyniki' UNION ALL 
SELECT 4230, 374, 10, N'wynik' UNION ALL 
SELECT 4231, 374, 11, N'wyniku' UNION ALL 
SELECT 4232, 374, 12, N'wynikowi' UNION ALL 
SELECT 4233, 374, 13, N'wynik' UNION ALL 
SELECT 4234, 374, 14, N'z wynikiem' UNION ALL 
SELECT 4235, 374, 15, N'wyniku' UNION ALL 
SELECT 4236, 374, 16, N'wyniku' UNION ALL 
SELECT 4237, 374, 19, N'wyniki' UNION ALL 
SELECT 4238, 374, 20, N'wyników' UNION ALL 
SELECT 4239, 374, 21, N'wynikom' UNION ALL 
SELECT 4240, 374, 22, N'wyniki' UNION ALL 
SELECT 4241, 374, 23, N'z wynikami' UNION ALL 
SELECT 4242, 374, 24, N'wynikach' UNION ALL 
SELECT 4243, 374, 25, N'wyniki' UNION ALL 
SELECT 4244, 375, 10, N'zdjęcie' UNION ALL 
SELECT 4245, 375, 11, N'zdjęcia' UNION ALL 
SELECT 4246, 375, 12, N'zdjęciu' UNION ALL 
SELECT 4247, 375, 13, N'zdjęcie' UNION ALL 
SELECT 4248, 375, 14, N'ze zdjęciem' UNION ALL 
SELECT 4249, 375, 15, N'zdjęciu' UNION ALL 
SELECT 4250, 375, 16, N'zdjęcie' UNION ALL 
SELECT 4251, 375, 19, N'zdjęcia' UNION ALL 
SELECT 4252, 375, 20, N'zdjęć' UNION ALL 
SELECT 4253, 375, 21, N'zdjęciom' UNION ALL 
SELECT 4254, 375, 22, N'zdjęcia' UNION ALL 
SELECT 4255, 375, 23, N'ze zdjęciami' UNION ALL 
SELECT 4256, 375, 24, N'zdjęciach' UNION ALL 
SELECT 4257, 375, 25, N'zdjęcia' UNION ALL 
SELECT 4258, 376, 10, N'młotek' UNION ALL 
SELECT 4259, 376, 11, N'młotka' UNION ALL 
SELECT 4260, 376, 12, N'młotkowi' UNION ALL 
SELECT 4261, 376, 13, N'młotek' UNION ALL 
SELECT 4262, 376, 14, N'z młotkiem' UNION ALL 
SELECT 4263, 376, 15, N'młotku' UNION ALL 
SELECT 4264, 376, 16, N'młotku' UNION ALL 
SELECT 4265, 376, 19, N'młotki' UNION ALL 
SELECT 4266, 376, 20, N'młotków' UNION ALL 
SELECT 4267, 376, 21, N'młotkom' UNION ALL 
SELECT 4268, 376, 22, N'młotki' UNION ALL 
SELECT 4269, 376, 23, N'z młotkami' UNION ALL 
SELECT 4270, 376, 24, N'młotkach' UNION ALL 
SELECT 4271, 376, 25, N'młotki' UNION ALL 
SELECT 4272, 377, 10, N'lina' UNION ALL 
SELECT 4273, 377, 11, N'liny' UNION ALL 
SELECT 4274, 377, 12, N'linie' UNION ALL 
SELECT 4275, 377, 13, N'linę' UNION ALL 
SELECT 4276, 377, 14, N'z liną' UNION ALL 
SELECT 4277, 377, 15, N'linie' UNION ALL 
SELECT 4278, 377, 16, N'lino' UNION ALL 
SELECT 4279, 377, 19, N'liny' UNION ALL 
SELECT 4280, 377, 20, N'lin' UNION ALL 
SELECT 4281, 377, 21, N'linom' UNION ALL 
SELECT 4282, 377, 22, N'liny' UNION ALL 
SELECT 4283, 377, 23, N'z linami' UNION ALL 
SELECT 4284, 377, 24, N'linach' UNION ALL 
SELECT 4285, 377, 25, N'liny' UNION ALL 
SELECT 4286, 378, 10, N'odwaga' UNION ALL 
SELECT 4287, 378, 11, N'odwagi' UNION ALL 
SELECT 4288, 378, 12, N'odwadze' UNION ALL 
SELECT 4289, 378, 13, N'odwagę' UNION ALL 
SELECT 4290, 378, 14, N'z odwagą' UNION ALL 
SELECT 4291, 378, 15, N'odwadze' UNION ALL 
SELECT 4292, 378, 16, N'odwago' UNION ALL 
SELECT 4293, 379, 10, N'przyjaciel' UNION ALL 
SELECT 4294, 379, 11, N'przyjaciela' UNION ALL 
SELECT 4295, 379, 12, N'przyjacielowi' UNION ALL 
SELECT 4296, 379, 13, N'przyjaciela' UNION ALL 
SELECT 4297, 379, 14, N'z przyjacielem' UNION ALL 
SELECT 4298, 379, 15, N'przyjacielu' UNION ALL 
SELECT 4299, 379, 16, N'przyjacielu' UNION ALL 
SELECT 4300, 379, 19, N'przyjaciele' UNION ALL 
SELECT 4301, 379, 20, N'przyjaciół' UNION ALL 
SELECT 4302, 379, 21, N'przyjaciołom' UNION ALL 
SELECT 4303, 379, 22, N'przyjaciół' UNION ALL 
SELECT 4304, 379, 23, N'z przyjaciółmi' UNION ALL 
SELECT 4305, 379, 24, N'przyjaciołach' UNION ALL 
SELECT 4306, 379, 25, N'przyjaciele' UNION ALL 
SELECT 4307, 380, 10, N'region' UNION ALL 
SELECT 4308, 380, 11, N'regionu' UNION ALL 
SELECT 4309, 380, 12, N'regionowi' UNION ALL 
SELECT 4310, 380, 13, N'region' UNION ALL 
SELECT 4311, 380, 14, N'z regionem' UNION ALL 
SELECT 4312, 380, 15, N'regionie' UNION ALL 
SELECT 4313, 380, 16, N'regionie' UNION ALL 
SELECT 4314, 380, 17, N'do regionu' UNION ALL 
SELECT 4315, 380, 18, N'w regionie' UNION ALL 
SELECT 4316, 380, 19, N'regiony' UNION ALL 
SELECT 4317, 380, 20, N'regionów' UNION ALL 
SELECT 4318, 380, 21, N'regionom' UNION ALL 
SELECT 4319, 380, 22, N'regiony' UNION ALL 
SELECT 4320, 380, 23, N'z regionami' UNION ALL 
SELECT 4321, 380, 24, N'regionach' UNION ALL 
SELECT 4322, 380, 25, N'regiony' UNION ALL 
SELECT 4323, 381, 10, N'miasto' UNION ALL 
SELECT 4324, 381, 11, N'miasta' UNION ALL 
SELECT 4325, 381, 12, N'miastu' UNION ALL 
SELECT 4326, 381, 13, N'miasto' UNION ALL 
SELECT 4327, 381, 14, N'z miastem' UNION ALL 
SELECT 4328, 381, 15, N'mieście' UNION ALL 
SELECT 4329, 381, 16, N'miasto' UNION ALL 
SELECT 4330, 381, 17, N'do miasta' UNION ALL 
SELECT 4331, 381, 18, N'w mieście' UNION ALL 
SELECT 4332, 381, 19, N'miasta' UNION ALL 
SELECT 4333, 381, 20, N'miast' UNION ALL 
SELECT 4334, 381, 21, N'miastom' UNION ALL 
SELECT 4335, 381, 22, N'miasta' UNION ALL 
SELECT 4336, 381, 23, N'z miastami' UNION ALL 
SELECT 4337, 381, 24, N'miastach' UNION ALL 
SELECT 4338, 381, 25, N'miasta' UNION ALL 
SELECT 4339, 382, 10, N'głowa' UNION ALL 
SELECT 4340, 382, 11, N'głowy' UNION ALL 
SELECT 4341, 382, 12, N'głowie' UNION ALL 
SELECT 4342, 382, 13, N'głowę' UNION ALL 
SELECT 4343, 382, 14, N'z głową' UNION ALL 
SELECT 4344, 382, 15, N'głowie' UNION ALL 
SELECT 4345, 382, 16, N'głowo' UNION ALL 
SELECT 4346, 382, 19, N'głowy' UNION ALL 
SELECT 4347, 382, 20, N'głów' UNION ALL 
SELECT 4348, 382, 21, N'głowom' UNION ALL 
SELECT 4349, 382, 22, N'głowy' UNION ALL 
SELECT 4350, 382, 23, N'z głowami' UNION ALL 
SELECT 4351, 382, 24, N'głowach' UNION ALL 
SELECT 4352, 382, 25, N'głowy' UNION ALL 
SELECT 4353, 383, 10, N'noga' UNION ALL 
SELECT 4354, 383, 11, N'nogi' UNION ALL 
SELECT 4355, 383, 12, N'nodze' UNION ALL 
SELECT 4356, 383, 13, N'nogę' UNION ALL 
SELECT 4357, 383, 14, N'z nogą' UNION ALL 
SELECT 4358, 383, 15, N'nodze' UNION ALL 
SELECT 4359, 383, 16, N'nogo' UNION ALL 
SELECT 4360, 383, 19, N'nogi' UNION ALL 
SELECT 4361, 383, 20, N'nóg' UNION ALL 
SELECT 4362, 383, 21, N'nogom' UNION ALL 
SELECT 4363, 383, 22, N'nogi' UNION ALL 
SELECT 4364, 383, 23, N'z nogami' UNION ALL 
SELECT 4365, 383, 24, N'nogach' UNION ALL 
SELECT 4366, 383, 25, N'nogi' UNION ALL 
SELECT 4367, 384, 10, N'brzuch' UNION ALL 
SELECT 4368, 384, 11, N'brzucha' UNION ALL 
SELECT 4369, 384, 12, N'brzuchowi' UNION ALL 
SELECT 4370, 384, 13, N'brzuch' UNION ALL 
SELECT 4371, 384, 14, N'z  brzuchem' UNION ALL 
SELECT 4372, 384, 15, N'brzuchu' UNION ALL 
SELECT 4373, 384, 16, N'brzuchu' UNION ALL 
SELECT 4374, 384, 19, N'brzuchy' UNION ALL 
SELECT 4375, 384, 20, N'brzuchó' UNION ALL 
SELECT 4376, 384, 21, N'brzuchom' UNION ALL 
SELECT 4377, 384, 22, N'brzuchy' UNION ALL 
SELECT 4378, 384, 23, N'z brzuchami' UNION ALL 
SELECT 4379, 384, 24, N'brzuchach' UNION ALL 
SELECT 4380, 384, 25, N'brzuchy' UNION ALL 
SELECT 4381, 385, 10, N'włos' UNION ALL 
SELECT 4382, 385, 11, N'włosa' UNION ALL 
SELECT 4383, 385, 12, N'włosowi' UNION ALL 
SELECT 4384, 385, 13, N'włos' UNION ALL 
SELECT 4385, 385, 14, N'z włosem' UNION ALL 
SELECT 4386, 385, 15, N'włosie' UNION ALL 
SELECT 4387, 385, 16, N'włosie' UNION ALL 
SELECT 4388, 385, 19, N'włosy' UNION ALL 
SELECT 4389, 385, 20, N'włosów' UNION ALL 
SELECT 4390, 385, 21, N'włosom' UNION ALL 
SELECT 4391, 385, 22, N'włosy' UNION ALL 
SELECT 4392, 385, 23, N'z włosami' UNION ALL 
SELECT 4393, 385, 24, N'włosach' UNION ALL 
SELECT 4394, 385, 25, N'włosy' UNION ALL 
SELECT 4395, 386, 10, N'okok.o' UNION ALL 
SELECT 4396, 386, 11, N'okok.a' UNION ALL 
SELECT 4397, 386, 12, N'okok.u' UNION ALL 
SELECT 4398, 386, 13, N'okok.o' UNION ALL 
SELECT 4399, 386, 14, N'z okok.iem' UNION ALL 
SELECT 4400, 386, 15, N'okok.u' UNION ALL 
SELECT 4401, 386, 16, N'okok.o' UNION ALL 
SELECT 4402, 386, 19, N'oczy' UNION ALL 
SELECT 4403, 386, 20, N'oczu' UNION ALL 
SELECT 4404, 386, 21, N'oczom' UNION ALL 
SELECT 4405, 386, 22, N'oczy' UNION ALL 
SELECT 4406, 386, 23, N'z oczami' UNION ALL 
SELECT 4407, 386, 24, N'oczach' UNION ALL 
SELECT 4408, 386, 25, N'oczy' UNION ALL 
SELECT 4409, 387, 10, N'ucho' UNION ALL 
SELECT 4410, 387, 11, N'ucha' UNION ALL 
SELECT 4411, 387, 12, N'uchu' UNION ALL 
SELECT 4412, 387, 13, N'ucho' UNION ALL 
SELECT 4413, 387, 14, N'z uchem' UNION ALL 
SELECT 4414, 387, 15, N'uchu' UNION ALL 
SELECT 4415, 387, 16, N'ucho' UNION ALL 
SELECT 4416, 387, 19, N'uszy' UNION ALL 
SELECT 4417, 387, 20, N'uszu' UNION ALL 
SELECT 4418, 387, 21, N'uszom' UNION ALL 
SELECT 4419, 387, 22, N'uszy' UNION ALL 
SELECT 4420, 387, 23, N'z uszami' UNION ALL 
SELECT 4421, 387, 24, N'uszach' UNION ALL 
SELECT 4422, 387, 25, N'uszy' UNION ALL 
SELECT 4423, 388, 10, N'nos' UNION ALL 
SELECT 4424, 388, 11, N'nosa' UNION ALL 
SELECT 4425, 388, 12, N'nosowi' UNION ALL 
SELECT 4426, 388, 13, N'nos' UNION ALL 
SELECT 4427, 388, 14, N'z nosem' UNION ALL 
SELECT 4428, 388, 15, N'nosie' UNION ALL 
SELECT 4429, 388, 16, N'nosie' UNION ALL 
SELECT 4430, 388, 19, N'nosy' UNION ALL 
SELECT 4431, 388, 20, N'nosów' UNION ALL 
SELECT 4432, 388, 21, N'nosom' UNION ALL 
SELECT 4433, 388, 22, N'nosy' UNION ALL 
SELECT 4434, 388, 23, N'z nosami' UNION ALL 
SELECT 4435, 388, 24, N'nosach' UNION ALL 
SELECT 4436, 388, 25, N'nosy' UNION ALL 
SELECT 4437, 389, 10, N'paznokieć' UNION ALL 
SELECT 4438, 389, 11, N'paznokcia' UNION ALL 
SELECT 4439, 389, 12, N'paznokciowi' UNION ALL 
SELECT 4440, 389, 13, N'paznokieć' UNION ALL 
SELECT 4441, 389, 14, N'z paznokciem' UNION ALL 
SELECT 4442, 389, 15, N'paznokciu' UNION ALL 
SELECT 4443, 389, 16, N'paznokciu' UNION ALL 
SELECT 4444, 389, 19, N'paznokcie' UNION ALL 
SELECT 4445, 389, 20, N'paznokci' UNION ALL 
SELECT 4446, 389, 21, N'paznokciom' UNION ALL 
SELECT 4447, 389, 22, N'paznokcie' UNION ALL 
SELECT 4448, 389, 23, N'z paznokciami' UNION ALL 
SELECT 4449, 389, 24, N'paznokciach' UNION ALL 
SELECT 4450, 389, 25, N'paznokcie' UNION ALL 
SELECT 4451, 390, 10, N'palec' UNION ALL 
SELECT 4452, 390, 11, N'palca' UNION ALL 
SELECT 4453, 390, 12, N'palcowi' UNION ALL 
SELECT 4454, 390, 13, N'palec' UNION ALL 
SELECT 4455, 390, 14, N'z palcem' UNION ALL 
SELECT 4456, 390, 15, N'palcu' UNION ALL 
SELECT 4457, 390, 16, N'palec' UNION ALL 
SELECT 4458, 390, 19, N'palce' UNION ALL 
SELECT 4459, 390, 20, N'palców' UNION ALL 
SELECT 4460, 390, 21, N'palcom' UNION ALL 
SELECT 4461, 390, 22, N'palce' UNION ALL 
SELECT 4462, 390, 23, N'z palcami' UNION ALL 
SELECT 4463, 390, 24, N'palcach' UNION ALL 
SELECT 4464, 390, 25, N'palce' UNION ALL 
SELECT 4465, 391, 10, N'ramię' UNION ALL 
SELECT 4466, 391, 11, N'ramienia' UNION ALL 
SELECT 4467, 391, 12, N'ramieniu' UNION ALL 
SELECT 4468, 391, 13, N'ramię' UNION ALL 
SELECT 4469, 391, 14, N'z ramieniem' UNION ALL 
SELECT 4470, 391, 15, N'ramieniu' UNION ALL 
SELECT 4471, 391, 16, N'ramię' UNION ALL 
SELECT 4472, 391, 19, N'ramiona' UNION ALL 
SELECT 4473, 391, 20, N'ramion' UNION ALL 
SELECT 4474, 391, 21, N'ramionom' UNION ALL 
SELECT 4475, 391, 22, N'ramiona' UNION ALL 
SELECT 4476, 391, 23, N'z ramionami' UNION ALL 
SELECT 4477, 391, 24, N'ramionach' UNION ALL 
SELECT 4478, 391, 25, N'ramiona' UNION ALL 
SELECT 4479, 392, 10, N'szyja' UNION ALL 
SELECT 4480, 392, 11, N'szyi' UNION ALL 
SELECT 4481, 392, 12, N'szyi' UNION ALL 
SELECT 4482, 392, 13, N'szyję' UNION ALL 
SELECT 4483, 392, 14, N'z szyją' UNION ALL 
SELECT 4484, 392, 15, N'szyi' UNION ALL 
SELECT 4485, 392, 16, N'szyjo' UNION ALL 
SELECT 4486, 392, 19, N'szyje' UNION ALL 
SELECT 4487, 392, 20, N'szyj' UNION ALL 
SELECT 4488, 392, 21, N'szyjom' UNION ALL 
SELECT 4489, 392, 22, N'szyje' UNION ALL 
SELECT 4490, 392, 23, N'z szyjami' UNION ALL 
SELECT 4491, 392, 24, N'szyjach' UNION ALL 
SELECT 4492, 392, 25, N'szyje' UNION ALL 
SELECT 4493, 393, 19, N'usta' UNION ALL 
SELECT 4494, 393, 20, N'ust' UNION ALL 
SELECT 4495, 393, 21, N'ustom' UNION ALL 
SELECT 4496, 393, 22, N'usta' UNION ALL 
SELECT 4497, 393, 23, N'z ustami' UNION ALL 
SELECT 4498, 393, 24, N'ustach' UNION ALL 
SELECT 4499, 393, 25, N'usta' UNION ALL 
SELECT 4500, 394, 10, N'ząb' UNION ALL 
SELECT 4501, 394, 11, N'zęba' UNION ALL 
SELECT 4502, 394, 12, N'zębowi' UNION ALL 
SELECT 4503, 394, 13, N'zęba' UNION ALL 
SELECT 4504, 394, 14, N'z zębęm' UNION ALL 
SELECT 4505, 394, 15, N'zębie' UNION ALL 
SELECT 4506, 394, 16, N'zębie' UNION ALL 
SELECT 4507, 394, 19, N'zęby' UNION ALL 
SELECT 4508, 394, 20, N'zębó' UNION ALL 
SELECT 4509, 394, 21, N'zębom' UNION ALL 
SELECT 4510, 394, 22, N'zęby' UNION ALL 
SELECT 4511, 394, 23, N'z zębami' UNION ALL 
SELECT 4512, 394, 24, N'zębach' UNION ALL 
SELECT 4513, 394, 25, N'zęby' UNION ALL 
SELECT 4514, 395, 10, N'język' UNION ALL 
SELECT 4515, 395, 11, N'języka' UNION ALL 
SELECT 4516, 395, 12, N'językowi' UNION ALL 
SELECT 4517, 395, 13, N'język' UNION ALL 
SELECT 4518, 395, 14, N'z językiem' UNION ALL 
SELECT 4519, 395, 15, N'języku' UNION ALL 
SELECT 4520, 395, 16, N'języku' UNION ALL 
SELECT 4521, 395, 19, N'języki' UNION ALL 
SELECT 4522, 395, 20, N'języków' UNION ALL 
SELECT 4523, 395, 21, N'językom' UNION ALL 
SELECT 4524, 395, 22, N'języki' UNION ALL 
SELECT 4525, 395, 23, N'z językami' UNION ALL 
SELECT 4526, 395, 24, N'językach' UNION ALL 
SELECT 4527, 395, 25, N'języki' UNION ALL 
SELECT 4528, 396, 10, N'serce' UNION ALL 
SELECT 4529, 396, 11, N'serca' UNION ALL 
SELECT 4530, 396, 12, N'sercu' UNION ALL 
SELECT 4531, 396, 13, N'serce' UNION ALL 
SELECT 4532, 396, 14, N'z sercem' UNION ALL 
SELECT 4533, 396, 15, N'sercu' UNION ALL 
SELECT 4534, 396, 16, N'serce' UNION ALL 
SELECT 4535, 396, 19, N'serca' UNION ALL 
SELECT 4536, 396, 20, N'serc' UNION ALL 
SELECT 4537, 396, 21, N'sercom' UNION ALL 
SELECT 4538, 396, 22, N'serca' UNION ALL 
SELECT 4539, 396, 23, N'z sercami' UNION ALL 
SELECT 4540, 396, 24, N'sercach' UNION ALL 
SELECT 4541, 396, 25, N'serca' UNION ALL 
SELECT 4542, 397, 10, N'wątroba' UNION ALL 
SELECT 4543, 397, 11, N'wątroby' UNION ALL 
SELECT 4544, 397, 12, N'wątrobie' UNION ALL 
SELECT 4545, 397, 13, N'wątrobę' UNION ALL 
SELECT 4546, 397, 14, N'z wątrobą' UNION ALL 
SELECT 4547, 397, 15, N'wątrobie' UNION ALL 
SELECT 4548, 397, 16, N'wątrobo' UNION ALL 
SELECT 4549, 397, 19, N'wątroby' UNION ALL 
SELECT 4550, 397, 20, N'wątrób' UNION ALL 
SELECT 4551, 397, 21, N'wątrobom' UNION ALL 
SELECT 4552, 397, 22, N'wątroby' UNION ALL 
SELECT 4553, 397, 23, N'z wątrobami' UNION ALL 
SELECT 4554, 397, 24, N'wątrobach' UNION ALL 
SELECT 4555, 397, 25, N'wątroby' UNION ALL 
SELECT 4556, 398, 10, N'żołądek' UNION ALL 
SELECT 4557, 398, 11, N'żołądka' UNION ALL 
SELECT 4558, 398, 12, N'żołądkowi' UNION ALL 
SELECT 4559, 398, 13, N'żołądek' UNION ALL 
SELECT 4560, 398, 14, N'z żołądkiem' UNION ALL 
SELECT 4561, 398, 15, N'żołądku' UNION ALL 
SELECT 4562, 398, 16, N'żołądku' UNION ALL 
SELECT 4563, 398, 19, N'żołądki' UNION ALL 
SELECT 4564, 398, 20, N'żołądków' UNION ALL 
SELECT 4565, 398, 21, N'żołądkom' UNION ALL 
SELECT 4566, 398, 22, N'żołądki' UNION ALL 
SELECT 4567, 398, 23, N'z żołądkami' UNION ALL 
SELECT 4568, 398, 24, N'żołądkach' UNION ALL 
SELECT 4569, 398, 25, N'żołądki' UNION ALL 
SELECT 4570, 399, 10, N'kolano' UNION ALL 
SELECT 4571, 399, 11, N'kolana' UNION ALL 
SELECT 4572, 399, 12, N'kolanu' UNION ALL 
SELECT 4573, 399, 13, N'kolano' UNION ALL 
SELECT 4574, 399, 14, N'z kolanem' UNION ALL 
SELECT 4575, 399, 15, N'kolanie' UNION ALL 
SELECT 4576, 399, 16, N'kolano' UNION ALL 
SELECT 4577, 399, 19, N'kolana' UNION ALL 
SELECT 4578, 399, 20, N'kolan' UNION ALL 
SELECT 4579, 399, 21, N'kolanom' UNION ALL 
SELECT 4580, 399, 22, N'kolana' UNION ALL 
SELECT 4581, 399, 23, N'z kolanami' UNION ALL 
SELECT 4582, 399, 24, N'kolanach' UNION ALL 
SELECT 4583, 399, 25, N'kolana' UNION ALL 
SELECT 4584, 400, 10, N'łokieć' UNION ALL 
SELECT 4585, 400, 11, N'łokcia' UNION ALL 
SELECT 4586, 400, 12, N'łokciowi' UNION ALL 
SELECT 4587, 400, 13, N'łokieć' UNION ALL 
SELECT 4588, 400, 14, N'z łokciem' UNION ALL 
SELECT 4589, 400, 15, N'łokciu' UNION ALL 
SELECT 4590, 400, 16, N'łokciu' UNION ALL 
SELECT 4591, 400, 19, N'łokcie' UNION ALL 
SELECT 4592, 400, 20, N'łokci' UNION ALL 
SELECT 4593, 400, 21, N'łokciom' UNION ALL 
SELECT 4594, 400, 22, N'łokcie' UNION ALL 
SELECT 4595, 400, 23, N'z łokciami' UNION ALL 
SELECT 4596, 400, 24, N'łokciach' UNION ALL 
SELECT 4597, 400, 25, N'łokcie' UNION ALL 
SELECT 4598, 401, 10, N'stopa' UNION ALL 
SELECT 4599, 401, 11, N'stopy' UNION ALL 
SELECT 4600, 401, 12, N'stopie' UNION ALL 
SELECT 4601, 401, 13, N'stopę' UNION ALL 
SELECT 4602, 401, 14, N'ze stopą' UNION ALL 
SELECT 4603, 401, 15, N'stopie' UNION ALL 
SELECT 4604, 401, 16, N'stopo' UNION ALL 
SELECT 4605, 401, 19, N'stopy' UNION ALL 
SELECT 4606, 401, 20, N'stóp' UNION ALL 
SELECT 4607, 401, 21, N'stopom' UNION ALL 
SELECT 4608, 401, 22, N'stopy' UNION ALL 
SELECT 4609, 401, 23, N'ze stopami' UNION ALL 
SELECT 4610, 401, 24, N'stopach' UNION ALL 
SELECT 4611, 401, 25, N'stopy' UNION ALL 
SELECT 4612, 402, 10, N'pięta' UNION ALL 
SELECT 4613, 402, 11, N'pięty' UNION ALL 
SELECT 4614, 402, 12, N'pięcie' UNION ALL 
SELECT 4615, 402, 13, N'piętę' UNION ALL 
SELECT 4616, 402, 14, N'z piętą' UNION ALL 
SELECT 4617, 402, 15, N'pięcie' UNION ALL 
SELECT 4618, 402, 16, N'pięto' UNION ALL 
SELECT 4619, 402, 19, N'pięty' UNION ALL 
SELECT 4620, 402, 20, N'pięt' UNION ALL 
SELECT 4621, 402, 21, N'piętom' UNION ALL 
SELECT 4622, 402, 22, N'pięty' UNION ALL 
SELECT 4623, 402, 23, N'z piętami' UNION ALL 
SELECT 4624, 402, 24, N'piętach' UNION ALL 
SELECT 4625, 402, 25, N'pięty' UNION ALL 
SELECT 4626, 403, 10, N'policzek' UNION ALL 
SELECT 4627, 403, 11, N'policzka' UNION ALL 
SELECT 4628, 403, 12, N'policzkowi' UNION ALL 
SELECT 4629, 403, 13, N'policzek' UNION ALL 
SELECT 4630, 403, 14, N'z policzkiem' UNION ALL 
SELECT 4631, 403, 15, N'policzku' UNION ALL 
SELECT 4632, 403, 16, N'policzku' UNION ALL 
SELECT 4633, 403, 19, N'policzki' UNION ALL 
SELECT 4634, 403, 20, N'policzków' UNION ALL 
SELECT 4635, 403, 21, N'policzkom' UNION ALL 
SELECT 4636, 403, 22, N'policzki' UNION ALL 
SELECT 4637, 403, 23, N'z policzkami' UNION ALL 
SELECT 4638, 403, 24, N'policzkach' UNION ALL 
SELECT 4639, 403, 25, N'policzki' UNION ALL 
SELECT 4640, 404, 10, N'brew' UNION ALL 
SELECT 4641, 404, 11, N'brwi' UNION ALL 
SELECT 4642, 404, 12, N'brwi' UNION ALL 
SELECT 4643, 404, 13, N'brew' UNION ALL 
SELECT 4644, 404, 14, N'z brwią' UNION ALL 
SELECT 4645, 404, 15, N'brwi' UNION ALL 
SELECT 4646, 404, 16, N'brwi' UNION ALL 
SELECT 4647, 404, 19, N'brwi' UNION ALL 
SELECT 4648, 404, 20, N'brwi' UNION ALL 
SELECT 4649, 404, 21, N'brwiom' UNION ALL 
SELECT 4650, 404, 22, N'brwi' UNION ALL 
SELECT 4651, 404, 23, N'z brwiami' UNION ALL 
SELECT 4652, 404, 24, N'brwiach' UNION ALL 
SELECT 4653, 404, 25, N'brwi' UNION ALL 
SELECT 4654, 405, 10, N'rzęsa' UNION ALL 
SELECT 4655, 405, 11, N'rzęsy' UNION ALL 
SELECT 4656, 405, 12, N'rzęsie' UNION ALL 
SELECT 4657, 405, 13, N'rzęsę' UNION ALL 
SELECT 4658, 405, 14, N'z rzęsą' UNION ALL 
SELECT 4659, 405, 15, N'rzęsie' UNION ALL 
SELECT 4660, 405, 16, N'rzęso' UNION ALL 
SELECT 4661, 405, 19, N'rzęsy' UNION ALL 
SELECT 4662, 405, 20, N'rzęs' UNION ALL 
SELECT 4663, 405, 21, N'rzęsom' UNION ALL 
SELECT 4664, 405, 22, N'rzęsy' UNION ALL 
SELECT 4665, 405, 23, N'z rzęsami' UNION ALL 
SELECT 4666, 405, 24, N'rzęsach' UNION ALL 
SELECT 4667, 405, 25, N'rzęsy' UNION ALL 
SELECT 4668, 406, 10, N'powieka' UNION ALL 
SELECT 4669, 406, 11, N'powieki' UNION ALL 
SELECT 4670, 406, 12, N'powiece' UNION ALL 
SELECT 4671, 406, 13, N'powiekę' UNION ALL 
SELECT 4672, 406, 14, N'z powieką' UNION ALL 
SELECT 4673, 406, 15, N'powiece' UNION ALL 
SELECT 4674, 406, 16, N'powieko' UNION ALL 
SELECT 4675, 406, 19, N'powieki' UNION ALL 
SELECT 4676, 406, 20, N'powiek' UNION ALL 
SELECT 4677, 406, 21, N'powiekom' UNION ALL 
SELECT 4678, 406, 22, N'powieki' UNION ALL 
SELECT 4679, 406, 23, N'z powiekami' UNION ALL 
SELECT 4680, 406, 24, N'powiekach' UNION ALL 
SELECT 4681, 406, 25, N'powieki' UNION ALL 
SELECT 4682, 407, 10, N'czoło' UNION ALL 
SELECT 4683, 407, 11, N'czoła' UNION ALL 
SELECT 4684, 407, 12, N'czołu' UNION ALL 
SELECT 4685, 407, 13, N'czoło' UNION ALL 
SELECT 4686, 407, 14, N'z czołem' UNION ALL 
SELECT 4687, 407, 15, N'czole' UNION ALL 
SELECT 4688, 407, 16, N'czoło' UNION ALL 
SELECT 4689, 407, 19, N'czoła' UNION ALL 
SELECT 4690, 407, 20, N'czół' UNION ALL 
SELECT 4691, 407, 21, N'czołom' UNION ALL 
SELECT 4692, 407, 22, N'czoła' UNION ALL 
SELECT 4693, 407, 23, N'z czołami' UNION ALL 
SELECT 4694, 407, 24, N'czołach' UNION ALL 
SELECT 4695, 407, 25, N'czoła' UNION ALL 
SELECT 4696, 408, 10, N'kręgosłup' UNION ALL 
SELECT 4697, 408, 11, N'kręgosłupa' UNION ALL 
SELECT 4698, 408, 12, N'kręgosłupowi' UNION ALL 
SELECT 4699, 408, 13, N'kręgosłup' UNION ALL 
SELECT 4700, 408, 14, N'z kręgosłupem' UNION ALL 
SELECT 4701, 408, 15, N'kręgosłupie' UNION ALL 
SELECT 4702, 408, 16, N'kręgosłupie' UNION ALL 
SELECT 4703, 408, 19, N'kręgosłupy' UNION ALL 
SELECT 4704, 408, 20, N'kręgosłupów' UNION ALL 
SELECT 4705, 408, 21, N'kręgosłupom' UNION ALL 
SELECT 4706, 408, 22, N'kręgosłupy' UNION ALL 
SELECT 4707, 408, 23, N'z kręgosłupami' UNION ALL 
SELECT 4708, 408, 24, N'kręgosłupach' UNION ALL 
SELECT 4709, 408, 25, N'kręgosłupy' UNION ALL 
SELECT 4710, 409, 10, N'płuco' UNION ALL 
SELECT 4711, 409, 11, N'płuca' UNION ALL 
SELECT 4712, 409, 12, N'płucu' UNION ALL 
SELECT 4713, 409, 13, N'płuco' UNION ALL 
SELECT 4714, 409, 14, N'z płucem' UNION ALL 
SELECT 4715, 409, 15, N'płucu' UNION ALL 
SELECT 4716, 409, 16, N'płuco' UNION ALL 
SELECT 4717, 409, 19, N'płuca' UNION ALL 
SELECT 4718, 409, 20, N'płuc' UNION ALL 
SELECT 4719, 409, 21, N'płucom' UNION ALL 
SELECT 4720, 409, 22, N'płuca' UNION ALL 
SELECT 4721, 409, 23, N'z płucami' UNION ALL 
SELECT 4722, 409, 24, N'płucach' UNION ALL 
SELECT 4723, 409, 25, N'płuca' UNION ALL 
SELECT 4724, 410, 10, N'żyła' UNION ALL 
SELECT 4725, 410, 11, N'żyły' UNION ALL 
SELECT 4726, 410, 12, N'żyle' UNION ALL 
SELECT 4727, 410, 13, N'żyłę' UNION ALL 
SELECT 4728, 410, 14, N'z żyłą' UNION ALL 
SELECT 4729, 410, 15, N'żyle' UNION ALL 
SELECT 4730, 410, 16, N'żyło' UNION ALL 
SELECT 4731, 410, 19, N'żyły' UNION ALL 
SELECT 4732, 410, 20, N'żyła' UNION ALL 
SELECT 4733, 410, 21, N'żyłom' UNION ALL 
SELECT 4734, 410, 22, N'żyły' UNION ALL 
SELECT 4735, 410, 23, N'z żyłami' UNION ALL 
SELECT 4736, 410, 24, N'żyłach' UNION ALL 
SELECT 4737, 410, 25, N'żyły' UNION ALL 
SELECT 4738, 411, 10, N'krew' UNION ALL 
SELECT 4739, 411, 11, N'krwi' UNION ALL 
SELECT 4740, 411, 12, N'krwi' UNION ALL 
SELECT 4741, 411, 13, N'krew' UNION ALL 
SELECT 4742, 411, 14, N'z krwią' UNION ALL 
SELECT 4743, 411, 15, N'krwi' UNION ALL 
SELECT 4744, 411, 16, N'krwi' UNION ALL 
SELECT 4745, 412, 10, N'gardło' UNION ALL 
SELECT 4746, 412, 11, N'gardła' UNION ALL 
SELECT 4747, 412, 12, N'gardłu' UNION ALL 
SELECT 4748, 412, 13, N'gardło' UNION ALL 
SELECT 4749, 412, 14, N'z gardłem' UNION ALL 
SELECT 4750, 412, 15, N'gardle' UNION ALL 
SELECT 4751, 412, 16, N'gardło' UNION ALL 
SELECT 4752, 412, 19, N'gardła' UNION ALL 
SELECT 4753, 412, 20, N'gardeł' UNION ALL 
SELECT 4754, 412, 21, N'gardłom' UNION ALL 
SELECT 4755, 412, 22, N'gardła' UNION ALL 
SELECT 4756, 412, 23, N'z gardłami' UNION ALL 
SELECT 4757, 412, 24, N'gardłach' UNION ALL 
SELECT 4758, 412, 25, N'gardła' UNION ALL 
SELECT 4759, 413, 10, N'mózg' UNION ALL 
SELECT 4760, 413, 11, N'mózgu' UNION ALL 
SELECT 4761, 413, 12, N'mózgowi' UNION ALL 
SELECT 4762, 413, 13, N'mózg' UNION ALL 
SELECT 4763, 413, 14, N'z mózgiem' UNION ALL 
SELECT 4764, 413, 15, N'mózgu' UNION ALL 
SELECT 4765, 413, 16, N'mózgu' UNION ALL 
SELECT 4766, 413, 19, N'mózgi' UNION ALL 
SELECT 4767, 413, 20, N'mózgów' UNION ALL 
SELECT 4768, 413, 21, N'mózgom' UNION ALL 
SELECT 4769, 413, 22, N'mózgi' UNION ALL 
SELECT 4770, 413, 23, N'z mózgami' UNION ALL 
SELECT 4771, 413, 24, N'mózgach' UNION ALL 
SELECT 4772, 413, 25, N'mózgi' UNION ALL 
SELECT 4773, 414, 10, N'Ameryka' UNION ALL 
SELECT 4774, 414, 11, N'Ameryki' UNION ALL 
SELECT 4775, 414, 12, N'Ameryce' UNION ALL 
SELECT 4776, 414, 13, N'Amerykę' UNION ALL 
SELECT 4777, 414, 14, N'z Ameryką' UNION ALL 
SELECT 4778, 414, 15, N'Ameryce' UNION ALL 
SELECT 4779, 414, 16, N'Ameryko' UNION ALL 
SELECT 4780, 414, 17, N'do Ameryki' UNION ALL 
SELECT 4781, 414, 18, N'w Ameryce' UNION ALL 
SELECT 4782, 415, 10, N'Ameryka' UNION ALL 
SELECT 4783, 415, 11, N'Ameryki' UNION ALL 
SELECT 4784, 415, 12, N'Ameryce' UNION ALL 
SELECT 4785, 415, 13, N'Amerykę' UNION ALL 
SELECT 4786, 415, 14, N'z Ameryką' UNION ALL 
SELECT 4787, 415, 15, N'Ameryce' UNION ALL 
SELECT 4788, 415, 16, N'Ameryko' UNION ALL 
SELECT 4789, 415, 17, N'do Ameryki' UNION ALL 
SELECT 4790, 415, 18, N'w Ameryce' UNION ALL 
SELECT 4791, 416, 10, N'Bałtyk' UNION ALL 
SELECT 4792, 416, 11, N'Bałtyku' UNION ALL 
SELECT 4793, 416, 12, N'Bałtykowi' UNION ALL 
SELECT 4794, 416, 13, N'Bałtyk' UNION ALL 
SELECT 4795, 416, 14, N'z Bałtykiem' UNION ALL 
SELECT 4796, 416, 15, N'Bałtyku' UNION ALL 
SELECT 4797, 416, 16, N'Bałtyku' UNION ALL 
SELECT 4798, 416, 17, N'nad Bałtyk' UNION ALL 
SELECT 4799, 416, 18, N'nad Bałtykiem' UNION ALL 
SELECT 4800, 417, 10, N'Atlantyk' UNION ALL 
SELECT 4801, 417, 11, N'Atlantyku' UNION ALL 
SELECT 4802, 417, 12, N'Atlantykowi' UNION ALL 
SELECT 4803, 417, 13, N'Atlantyk' UNION ALL 
SELECT 4804, 417, 14, N'z Atlantykiem' UNION ALL 
SELECT 4805, 417, 15, N'Atlantyku' UNION ALL 
SELECT 4806, 417, 16, N'Atlantyku' UNION ALL 
SELECT 4807, 417, 17, N'nad Atlantyk' UNION ALL 
SELECT 4808, 417, 18, N'nad Atlantykiem' UNION ALL 
SELECT 4809, 418, 10, N'Pacyfik' UNION ALL 
SELECT 4810, 418, 11, N'Pacyfiku' UNION ALL 
SELECT 4811, 418, 12, N'Pacyfikowi' UNION ALL 
SELECT 4812, 418, 13, N'Pacyfik' UNION ALL 
SELECT 4813, 418, 14, N'z Pacyfikiem' UNION ALL 
SELECT 4814, 418, 15, N'Pacyfiku' UNION ALL 
SELECT 4815, 418, 16, N'Pacyfiku' UNION ALL 
SELECT 4816, 418, 17, N'nad Pacyfik' UNION ALL 
SELECT 4817, 418, 18, N'nad Pacyfikiem' UNION ALL 
SELECT 4818, 419, 10, N'mysz' UNION ALL 
SELECT 4819, 419, 11, N'myszy' UNION ALL 
SELECT 4820, 419, 12, N'myszy' UNION ALL 
SELECT 4821, 419, 13, N'mysz' UNION ALL 
SELECT 4822, 419, 14, N'z myszą' UNION ALL 
SELECT 4823, 419, 15, N'myszy' UNION ALL 
SELECT 4824, 419, 16, N'mysz' UNION ALL 
SELECT 4825, 419, 19, N'myszy' UNION ALL 
SELECT 4826, 419, 20, N'myszy' UNION ALL 
SELECT 4827, 419, 21, N'myszom' UNION ALL 
SELECT 4828, 419, 22, N'myszy' UNION ALL 
SELECT 4829, 419, 23, N'z myszami' UNION ALL 
SELECT 4830, 419, 24, N'myszach' UNION ALL 
SELECT 4831, 419, 25, N'myszy' UNION ALL 
SELECT 4832, 420, 10, N'szczur' UNION ALL 
SELECT 4833, 420, 11, N'szczura' UNION ALL 
SELECT 4834, 420, 12, N'szczurowi' UNION ALL 
SELECT 4835, 420, 13, N'szczura' UNION ALL 
SELECT 4836, 420, 14, N'ze szczurem' UNION ALL 
SELECT 4837, 420, 15, N'szczurze' UNION ALL 
SELECT 4838, 420, 16, N'szczurze' UNION ALL 
SELECT 4839, 420, 19, N'szczury' UNION ALL 
SELECT 4840, 420, 20, N'szczurów' UNION ALL 
SELECT 4841, 420, 21, N'szczurom' UNION ALL 
SELECT 4842, 420, 22, N'szczury' UNION ALL 
SELECT 4843, 420, 23, N'ze szczurami' UNION ALL 
SELECT 4844, 420, 24, N'szczurach' UNION ALL 
SELECT 4845, 420, 25, N'szczury' UNION ALL 
SELECT 4846, 421, 17, N'na Bałkany' UNION ALL 
SELECT 4847, 421, 18, N'na Bałkanach' UNION ALL 
SELECT 4848, 421, 19, N'Bałkany' UNION ALL 
SELECT 4849, 421, 20, N'Bałkanów' UNION ALL 
SELECT 4850, 421, 21, N'Bałkanom' UNION ALL 
SELECT 4851, 421, 22, N'Bałkany' UNION ALL 
SELECT 4852, 421, 23, N'z Bałkanami' UNION ALL 
SELECT 4853, 421, 24, N'Bałkanach' UNION ALL 
SELECT 4854, 421, 25, N'Bałkany' UNION ALL 
SELECT 4855, 422, 10, N'palec' UNION ALL 
SELECT 4856, 422, 11, N'palca' UNION ALL 
SELECT 4857, 422, 12, N'palcowi' UNION ALL 
SELECT 4858, 422, 13, N'palec' UNION ALL 
SELECT 4859, 422, 14, N'z palcem' UNION ALL 
SELECT 4860, 422, 15, N'palcu' UNION ALL 
SELECT 4861, 422, 16, N'palec' UNION ALL 
SELECT 4862, 422, 19, N'palce' UNION ALL 
SELECT 4863, 422, 20, N'palców' UNION ALL 
SELECT 4864, 422, 21, N'palcom' UNION ALL 
SELECT 4865, 422, 22, N'palce' UNION ALL 
SELECT 4866, 422, 23, N'z palcami' UNION ALL 
SELECT 4867, 422, 24, N'palcach' UNION ALL 
SELECT 4868, 422, 25, N'palce' UNION ALL 
SELECT 4869, 423, 31, N'a' UNION ALL 
SELECT 4870, 423, 32, N'Poland' UNION ALL 
SELECT 4871, 423, 34, N'to Poland' UNION ALL 
SELECT 4872, 423, 35, N'in Poland' UNION ALL 
SELECT 4873, 424, 31, N'a' UNION ALL 
SELECT 4874, 424, 32, N'dog' UNION ALL 
SELECT 4875, 424, 33, N'dogs' UNION ALL 
SELECT 4876, 425, 31, N'an' UNION ALL 
SELECT 4877, 425, 32, N'Italy' UNION ALL 
SELECT 4878, 425, 34, N'to Italy' UNION ALL 
SELECT 4879, 425, 35, N'in Italy' UNION ALL 
SELECT 4880, 426, 31, N'a' UNION ALL 
SELECT 4881, 426, 32, N'Spain' UNION ALL 
SELECT 4882, 426, 34, N'to Spain' UNION ALL 
SELECT 4883, 426, 35, N'in Spain' UNION ALL 
SELECT 4884, 427, 31, N'a' UNION ALL 
SELECT 4885, 427, 32, N'France' UNION ALL 
SELECT 4886, 427, 34, N'to France' UNION ALL 
SELECT 4887, 427, 35, N'in France' UNION ALL 
SELECT 4888, 428, 31, N'a' UNION ALL 
SELECT 4889, 428, 32, N'Germany' UNION ALL 
SELECT 4890, 428, 34, N'to Germany' UNION ALL 
SELECT 4891, 428, 35, N'in Germany' UNION ALL 
SELECT 4892, 429, 31, N'an' UNION ALL 
SELECT 4893, 429, 32, N'England' UNION ALL 
SELECT 4894, 429, 34, N'to England' UNION ALL 
SELECT 4895, 429, 35, N'in England' UNION ALL 
SELECT 4896, 430, 31, N'a' UNION ALL 
SELECT 4897, 430, 32, N'Russia' UNION ALL 
SELECT 4898, 430, 34, N'to Russia' UNION ALL 
SELECT 4899, 430, 35, N'in Russia' UNION ALL 
SELECT 4900, 431, 31, N'an' UNION ALL 
SELECT 4901, 431, 32, N'Albania' UNION ALL 
SELECT 4902, 431, 34, N'to Albania' UNION ALL 
SELECT 4903, 431, 35, N'in Albania' UNION ALL 
SELECT 4904, 432, 31, N'an' UNION ALL 
SELECT 4905, 432, 32, N'Andorra' UNION ALL 
SELECT 4906, 432, 34, N'to Andorra' UNION ALL 
SELECT 4907, 432, 35, N'in Andorra' UNION ALL 
SELECT 4908, 433, 31, N'an' UNION ALL 
SELECT 4909, 433, 32, N'Armenia' UNION ALL 
SELECT 4910, 433, 34, N'to Armenia' UNION ALL 
SELECT 4911, 433, 35, N'in Armenia' UNION ALL 
SELECT 4912, 434, 31, N'an' UNION ALL 
SELECT 4913, 434, 32, N'Austria' UNION ALL 
SELECT 4914, 434, 34, N'to Austria' UNION ALL 
SELECT 4915, 434, 35, N'in Austria' UNION ALL 
SELECT 4916, 435, 31, N'an' UNION ALL 
SELECT 4917, 435, 32, N'Azerbaijan' UNION ALL 
SELECT 4918, 435, 34, N'to Azerbaijan' UNION ALL 
SELECT 4919, 435, 35, N'in Azerbaijan' UNION ALL 
SELECT 4920, 436, 31, N'a' UNION ALL 
SELECT 4921, 436, 32, N'Belarus' UNION ALL 
SELECT 4922, 436, 34, N'to Belarus' UNION ALL 
SELECT 4923, 436, 35, N'in Belarus' UNION ALL 
SELECT 4924, 437, 31, N'a' UNION ALL 
SELECT 4925, 437, 32, N'Belgium' UNION ALL 
SELECT 4926, 437, 34, N'to Belgium' UNION ALL 
SELECT 4927, 437, 35, N'in Belgium' UNION ALL 
SELECT 4928, 438, 31, N'a' UNION ALL 
SELECT 4929, 438, 32, N'Bosnia & Herzegovina' UNION ALL 
SELECT 4930, 438, 34, N'to Bosnia & Herzegovina' UNION ALL 
SELECT 4931, 438, 35, N'in Bosnia & Herzegovina' UNION ALL 
SELECT 4932, 439, 31, N'a' UNION ALL 
SELECT 4933, 439, 32, N'Bulgaria' UNION ALL 
SELECT 4934, 439, 34, N'to Bulgaria' UNION ALL 
SELECT 4935, 439, 35, N'in Bulgaria' UNION ALL 
SELECT 4936, 440, 31, N'a' UNION ALL 
SELECT 4937, 440, 32, N'Croatia' UNION ALL 
SELECT 4938, 440, 34, N'to Croatia' UNION ALL 
SELECT 4939, 440, 35, N'in Croatia' UNION ALL 
SELECT 4940, 441, 31, N'a' UNION ALL 
SELECT 4941, 441, 32, N'Cyprus' UNION ALL 
SELECT 4942, 441, 34, N'to Cyprus' UNION ALL 
SELECT 4943, 441, 35, N'in Cyprus' UNION ALL 
SELECT 4944, 442, 31, N'-' UNION ALL 
SELECT 4945, 442, 32, N'the Czech Republic' UNION ALL 
SELECT 4946, 442, 34, N'to the Czech Republic' UNION ALL 
SELECT 4947, 442, 35, N'in the Czech Republic' UNION ALL 
SELECT 4948, 443, 31, N'a' UNION ALL 
SELECT 4949, 443, 32, N'Denmark' UNION ALL 
SELECT 4950, 443, 34, N'to Denmark' UNION ALL 
SELECT 4951, 443, 35, N'in Denmark' UNION ALL 
SELECT 4952, 444, 31, N'an' UNION ALL 
SELECT 4953, 444, 32, N'Estonia' UNION ALL 
SELECT 4954, 444, 34, N'to Estonia' UNION ALL 
SELECT 4955, 444, 35, N'in Estonia' UNION ALL 
SELECT 4956, 445, 31, N'a' UNION ALL 
SELECT 4957, 445, 32, N'Finland' UNION ALL 
SELECT 4958, 445, 34, N'to Finland' UNION ALL 
SELECT 4959, 445, 35, N'in Finland' UNION ALL 
SELECT 4960, 446, 31, N'a' UNION ALL 
SELECT 4961, 446, 32, N'Georgia' UNION ALL 
SELECT 4962, 446, 34, N'to Georgia' UNION ALL 
SELECT 4963, 446, 35, N'in Georgia' UNION ALL 
SELECT 4964, 447, 31, N'a' UNION ALL 
SELECT 4965, 447, 32, N'Greece' UNION ALL 
SELECT 4966, 447, 34, N'to Greece' UNION ALL 
SELECT 4967, 447, 35, N'in Greece' UNION ALL 
SELECT 4968, 448, 31, N'a' UNION ALL 
SELECT 4969, 448, 32, N'Hungary' UNION ALL 
SELECT 4970, 448, 34, N'to Hungary' UNION ALL 
SELECT 4971, 448, 35, N'in Hungary' UNION ALL 
SELECT 4972, 449, 31, N'an' UNION ALL 
SELECT 4973, 449, 32, N'Iceland' UNION ALL 
SELECT 4974, 449, 34, N'to Iceland' UNION ALL 
SELECT 4975, 449, 35, N'in Iceland' UNION ALL 
SELECT 4976, 450, 31, N'an' UNION ALL 
SELECT 4977, 450, 32, N'Ireland' UNION ALL 
SELECT 4978, 450, 34, N'to Ireland' UNION ALL 
SELECT 4979, 450, 35, N'in Ireland' UNION ALL 
SELECT 4980, 451, 31, N'a' UNION ALL 
SELECT 4981, 451, 32, N'Kazakhstan' UNION ALL 
SELECT 4982, 451, 34, N'to Kazakhstan' UNION ALL 
SELECT 4983, 451, 35, N'in Kazakhstan' UNION ALL 
SELECT 4984, 452, 31, N'a' UNION ALL 
SELECT 4985, 452, 32, N'Latvia' UNION ALL 
SELECT 4986, 452, 34, N'to Latvia' UNION ALL 
SELECT 4987, 452, 35, N'in Latvia' UNION ALL 
SELECT 4988, 453, 31, N'a' UNION ALL 
SELECT 4989, 453, 32, N'Liechtenstein' UNION ALL 
SELECT 4990, 453, 34, N'to Liechtenstein' UNION ALL 
SELECT 4991, 453, 35, N'in Liechtenstein' UNION ALL 
SELECT 4992, 454, 31, N'a' UNION ALL 
SELECT 4993, 454, 32, N'Lithuania' UNION ALL 
SELECT 4994, 454, 34, N'to Lithuania' UNION ALL 
SELECT 4995, 454, 35, N'in Lithuania' UNION ALL 
SELECT 4996, 455, 31, N'a' UNION ALL 
SELECT 4997, 455, 32, N'Luxembourg' UNION ALL 
SELECT 4998, 455, 34, N'to Luxembourg' UNION ALL 
SELECT 4999, 455, 35, N'in Luxembourg' UNION ALL 
SELECT 5000, 456, 31, N'a' UNION ALL 
SELECT 5001, 456, 32, N'Macedonia' UNION ALL 
SELECT 5002, 456, 34, N'to Macedonia' UNION ALL 
SELECT 5003, 456, 35, N'in Macedonia' UNION ALL 
SELECT 5004, 457, 31, N'a' UNION ALL 
SELECT 5005, 457, 32, N'Malta' UNION ALL 
SELECT 5006, 457, 34, N'to Malta' UNION ALL 
SELECT 5007, 457, 35, N'in Malta' UNION ALL 
SELECT 5008, 458, 31, N'a' UNION ALL 
SELECT 5009, 458, 32, N'Moldova' UNION ALL 
SELECT 5010, 458, 34, N'to Moldova' UNION ALL 
SELECT 5011, 458, 35, N'in Moldova' UNION ALL 
SELECT 5012, 459, 31, N'a' UNION ALL 
SELECT 5013, 459, 32, N'Monaco' UNION ALL 
SELECT 5014, 459, 34, N'to Monaco' UNION ALL 
SELECT 5015, 459, 35, N'in Monaco' UNION ALL 
SELECT 5016, 460, 31, N'a' UNION ALL 
SELECT 5017, 460, 32, N'Montenegro' UNION ALL 
SELECT 5018, 460, 34, N'to Montenegro' UNION ALL 
SELECT 5019, 460, 35, N'in Montenegro' UNION ALL 
SELECT 5020, 461, 33, N'the Netherlands' UNION ALL 
SELECT 5021, 461, 34, N'to the Netherlands' UNION ALL 
SELECT 5022, 461, 35, N'in the Netherlands' UNION ALL 
SELECT 5023, 462, 31, N'a' UNION ALL 
SELECT 5024, 462, 32, N'Norway' UNION ALL 
SELECT 5025, 462, 34, N'to Norway' UNION ALL 
SELECT 5026, 462, 35, N'in Norway' UNION ALL 
SELECT 5027, 463, 31, N'a' UNION ALL 
SELECT 5028, 463, 32, N'Portugal' UNION ALL 
SELECT 5029, 463, 34, N'to Portugal' UNION ALL 
SELECT 5030, 463, 35, N'in Portugal' UNION ALL 
SELECT 5031, 464, 31, N'a' UNION ALL 
SELECT 5032, 464, 32, N'Romania' UNION ALL 
SELECT 5033, 464, 34, N'to Romania' UNION ALL 
SELECT 5034, 464, 35, N'in Romania' UNION ALL 
SELECT 5035, 465, 31, N'a' UNION ALL 
SELECT 5036, 465, 32, N'San Marino' UNION ALL 
SELECT 5037, 465, 34, N'to San Marino' UNION ALL 
SELECT 5038, 465, 35, N'in San Marino' UNION ALL 
SELECT 5039, 466, 31, N'a' UNION ALL 
SELECT 5040, 466, 32, N'Serbia' UNION ALL 
SELECT 5041, 466, 34, N'to Serbia' UNION ALL 
SELECT 5042, 466, 35, N'in Serbia' UNION ALL 
SELECT 5043, 467, 31, N'a' UNION ALL 
SELECT 5044, 467, 32, N'Slovakia' UNION ALL 
SELECT 5045, 467, 34, N'to Slovakia' UNION ALL 
SELECT 5046, 467, 35, N'in Slovakia' UNION ALL 
SELECT 5047, 468, 31, N'a' UNION ALL 
SELECT 5048, 468, 32, N'Slovenia' UNION ALL 
SELECT 5049, 468, 34, N'to Slovenia' UNION ALL 
SELECT 5050, 468, 35, N'in Slovenia' UNION ALL 
SELECT 5051, 469, 31, N'a' UNION ALL 
SELECT 5052, 469, 32, N'Sweden' UNION ALL 
SELECT 5053, 469, 34, N'to Sweden' UNION ALL 
SELECT 5054, 469, 35, N'in Sweden' UNION ALL 
SELECT 5055, 470, 31, N'a' UNION ALL 
SELECT 5056, 470, 32, N'Switzerland' UNION ALL 
SELECT 5057, 470, 34, N'to Switzerland' UNION ALL 
SELECT 5058, 470, 35, N'in Switzerland' UNION ALL 
SELECT 5059, 471, 31, N'a' UNION ALL 
SELECT 5060, 471, 32, N'Turkey' UNION ALL 
SELECT 5061, 471, 34, N'to Turkey' UNION ALL 
SELECT 5062, 471, 35, N'in Turkey' UNION ALL 
SELECT 5063, 472, 31, N'a' UNION ALL 
SELECT 5064, 472, 32, N'Ukraine' UNION ALL 
SELECT 5065, 472, 34, N'to Ukraine' UNION ALL 
SELECT 5066, 472, 35, N'in Ukraine' UNION ALL 
SELECT 5067, 473, 31, N'a' UNION ALL 
SELECT 5068, 473, 32, N'Vatican City' UNION ALL 
SELECT 5069, 473, 34, N'to Vatican City' UNION ALL 
SELECT 5070, 473, 35, N'in Vatican City' UNION ALL 
SELECT 5071, 474, 31, N'a' UNION ALL 
SELECT 5072, 474, 32, N'Scotland' UNION ALL 
SELECT 5073, 474, 34, N'to Scotland' UNION ALL 
SELECT 5074, 474, 35, N'in Scotland' UNION ALL 
SELECT 5075, 475, 31, N'a' UNION ALL 
SELECT 5076, 475, 32, N'Brazil' UNION ALL 
SELECT 5077, 475, 34, N'to Brazil' UNION ALL 
SELECT 5078, 475, 35, N'in Brazil' UNION ALL 
SELECT 5079, 476, 31, N'an' UNION ALL 
SELECT 5080, 476, 32, N'Argentina' UNION ALL 
SELECT 5081, 476, 34, N'to Argentina' UNION ALL 
SELECT 5082, 476, 35, N'in Argentina' UNION ALL 
SELECT 5083, 477, 31, N'a' UNION ALL 
SELECT 5084, 477, 32, N'Peru' UNION ALL 
SELECT 5085, 477, 34, N'to Peru' UNION ALL 
SELECT 5086, 477, 35, N'in Peru' UNION ALL 
SELECT 5087, 478, 31, N'a' UNION ALL 
SELECT 5088, 478, 32, N'Bolivia' UNION ALL 
SELECT 5089, 478, 34, N'to Bolivia' UNION ALL 
SELECT 5090, 478, 35, N'in Bolivia' UNION ALL 
SELECT 5091, 479, 31, N'a' UNION ALL 
SELECT 5092, 479, 32, N'Chile' UNION ALL 
SELECT 5093, 479, 34, N'to Chile' UNION ALL 
SELECT 5094, 479, 35, N'in Chile' UNION ALL 
SELECT 5095, 480, 31, N'a' UNION ALL 
SELECT 5096, 480, 32, N'Colombia' UNION ALL 
SELECT 5097, 480, 34, N'to Colombia' UNION ALL 
SELECT 5098, 480, 35, N'in Colombia' UNION ALL 
SELECT 5099, 481, 31, N'a' UNION ALL 
SELECT 5100, 481, 32, N'Venezuela' UNION ALL 
SELECT 5101, 481, 34, N'to Venezuela' UNION ALL 
SELECT 5102, 481, 35, N'in Venezuela' UNION ALL 
SELECT 5103, 482, 31, N'a' UNION ALL 
SELECT 5104, 482, 32, N'Uruguay' UNION ALL 
SELECT 5105, 482, 34, N'to Uruguay' UNION ALL 
SELECT 5106, 482, 35, N'in Uruguay' UNION ALL 
SELECT 5107, 483, 31, N'a' UNION ALL 
SELECT 5108, 483, 32, N'Paraguay' UNION ALL 
SELECT 5109, 483, 34, N'to Paraguay' UNION ALL 
SELECT 5110, 483, 35, N'in Paraguay' UNION ALL 
SELECT 5111, 484, 31, N'an' UNION ALL 
SELECT 5112, 484, 32, N'Ecuador' UNION ALL 
SELECT 5113, 484, 34, N'to Ecuador' UNION ALL 
SELECT 5114, 484, 35, N'in Ecuador' UNION ALL 
SELECT 5115, 485, 31, N'a' UNION ALL 
SELECT 5116, 485, 32, N'China' UNION ALL 
SELECT 5117, 485, 34, N'to China' UNION ALL 
SELECT 5118, 485, 35, N'in China' UNION ALL 
SELECT 5119, 486, 31, N'a' UNION ALL 
SELECT 5120, 486, 32, N'Japan' UNION ALL 
SELECT 5121, 486, 34, N'to Japan' UNION ALL 
SELECT 5122, 486, 35, N'in Japan' UNION ALL 
SELECT 5123, 487, 31, N'an' UNION ALL 
SELECT 5124, 487, 32, N'India' UNION ALL 
SELECT 5125, 487, 34, N'to India' UNION ALL 
SELECT 5126, 487, 35, N'in India' UNION ALL 
SELECT 5127, 488, 31, N'a' UNION ALL 
SELECT 5128, 488, 32, N'Thailand' UNION ALL 
SELECT 5129, 488, 34, N'to Thailand' UNION ALL 
SELECT 5130, 488, 35, N'in Thailand' UNION ALL 
SELECT 5131, 489, 31, N'an' UNION ALL 
SELECT 5132, 489, 32, N'Israel' UNION ALL 
SELECT 5133, 489, 34, N'to Israel' UNION ALL 
SELECT 5134, 489, 35, N'in Israel' UNION ALL 
SELECT 5135, 490, 31, N'a' UNION ALL 
SELECT 5136, 490, 32, N'Lebanon' UNION ALL 
SELECT 5137, 490, 34, N'to Lebanon' UNION ALL 
SELECT 5138, 490, 35, N'in Lebanon' UNION ALL 
SELECT 5139, 491, 31, N'a' UNION ALL 
SELECT 5140, 491, 32, N'Jordan' UNION ALL 
SELECT 5141, 491, 34, N'to Jordan' UNION ALL 
SELECT 5142, 491, 35, N'in Jordan' UNION ALL 
SELECT 5143, 492, 31, N'a' UNION ALL 
SELECT 5144, 492, 32, N'Syria' UNION ALL 
SELECT 5145, 492, 34, N'to Syria' UNION ALL 
SELECT 5146, 492, 35, N'in Syria' UNION ALL 
SELECT 5147, 493, 31, N'a' UNION ALL 
SELECT 5148, 493, 32, N'Saudi Arabia' UNION ALL 
SELECT 5149, 493, 34, N'to Saudi Arabia' UNION ALL 
SELECT 5150, 493, 35, N'in Saudi Arabia' UNION ALL 
SELECT 5151, 494, 31, N'a' UNION ALL 
SELECT 5152, 494, 32, N'Yemen' UNION ALL 
SELECT 5153, 494, 34, N'to Yemen' UNION ALL 
SELECT 5154, 494, 35, N'in Yemen' UNION ALL 
SELECT 5155, 495, 31, N'an' UNION ALL 
SELECT 5156, 495, 32, N'Oman' UNION ALL 
SELECT 5157, 495, 34, N'to Oman' UNION ALL 
SELECT 5158, 495, 35, N'in Oman' UNION ALL 
SELECT 5159, 496, 33, N'the United Arab Emirates' UNION ALL 
SELECT 5160, 496, 34, N'to the United Arab Emirates' UNION ALL 
SELECT 5161, 496, 35, N'in the United Arab Emirates' UNION ALL 
SELECT 5162, 497, 31, N'a' UNION ALL 
SELECT 5163, 497, 32, N'Kuwait' UNION ALL 
SELECT 5164, 497, 34, N'to Kuwait' UNION ALL 
SELECT 5165, 497, 35, N'in Kuwait' UNION ALL 
SELECT 5166, 498, 31, N'a' UNION ALL 
SELECT 5167, 498, 32, N'Bahrain' UNION ALL 
SELECT 5168, 498, 34, N'to Bahrain' UNION ALL 
SELECT 5169, 498, 35, N'in Bahrain' UNION ALL 
SELECT 5170, 499, 31, N'a' UNION ALL 
SELECT 5171, 499, 32, N'Qatar' UNION ALL 
SELECT 5172, 499, 34, N'to Qatar' UNION ALL 
SELECT 5173, 499, 35, N'in Qatar' UNION ALL 
SELECT 5174, 500, 31, N'an' UNION ALL 
SELECT 5175, 500, 32, N'Iraq' UNION ALL 
SELECT 5176, 500, 34, N'to Iraq' UNION ALL 
SELECT 5177, 500, 35, N'in Iraq' UNION ALL 
SELECT 5178, 501, 31, N'an' UNION ALL 
SELECT 5179, 501, 32, N'Iran' UNION ALL 
SELECT 5180, 501, 34, N'to Iran' UNION ALL 
SELECT 5181, 501, 35, N'in Iran' UNION ALL 
SELECT 5182, 502, 31, N'an' UNION ALL 
SELECT 5183, 502, 32, N'Afghanistan' UNION ALL 
SELECT 5184, 502, 34, N'to Afghanistan' UNION ALL 
SELECT 5185, 502, 35, N'in Afghanistan' UNION ALL 
SELECT 5186, 503, 31, N'a' UNION ALL 
SELECT 5187, 503, 32, N'Pakistan' UNION ALL 
SELECT 5188, 503, 34, N'to Pakistan' UNION ALL 
SELECT 5189, 503, 35, N'in Pakistan' UNION ALL 
SELECT 5190, 504, 31, N'an' UNION ALL 
SELECT 5191, 504, 32, N'Uzbekistan' UNION ALL 
SELECT 5192, 504, 34, N'to Uzbekistan' UNION ALL 
SELECT 5193, 504, 35, N'in Uzbekistan' UNION ALL 
SELECT 5194, 505, 31, N'a' UNION ALL 
SELECT 5195, 505, 32, N'Turkmenistan' UNION ALL 
SELECT 5196, 505, 34, N'to Turkmenistan' UNION ALL 
SELECT 5197, 505, 35, N'in Turkmenistan' UNION ALL 
SELECT 5198, 506, 31, N'a' UNION ALL 
SELECT 5199, 506, 32, N'Tajikistan' UNION ALL 
SELECT 5200, 506, 34, N'to Tajikistan' UNION ALL 
SELECT 5201, 506, 35, N'in Tajikistan' UNION ALL 
SELECT 5202, 507, 31, N'a' UNION ALL 
SELECT 5203, 507, 32, N'Kyrgyzstan' UNION ALL 
SELECT 5204, 507, 34, N'to Kyrgyzstan' UNION ALL 
SELECT 5205, 507, 35, N'in Kyrgyzstan' UNION ALL 
SELECT 5206, 508, 31, N'a' UNION ALL 
SELECT 5207, 508, 32, N'Nepal' UNION ALL 
SELECT 5208, 508, 34, N'to Nepal' UNION ALL 
SELECT 5209, 508, 35, N'in Nepal' UNION ALL 
SELECT 5210, 509, 31, N'a' UNION ALL 
SELECT 5211, 509, 32, N'Bhutan' UNION ALL 
SELECT 5212, 509, 34, N'to Bhutan' UNION ALL 
SELECT 5213, 509, 35, N'in Bhutan' UNION ALL 
SELECT 5214, 510, 31, N'a' UNION ALL 
SELECT 5215, 510, 32, N'Bangladesh' UNION ALL 
SELECT 5216, 510, 34, N'to Bangladesh' UNION ALL 
SELECT 5217, 510, 35, N'in Bangladesh' UNION ALL 
SELECT 5218, 511, 31, N'a' UNION ALL 
SELECT 5219, 511, 32, N'Sri Lanka' UNION ALL 
SELECT 5220, 511, 34, N'to Sri Lanka' UNION ALL 
SELECT 5221, 511, 35, N'in Sri Lanka' UNION ALL 
SELECT 5222, 512, 31, N'a' UNION ALL 
SELECT 5223, 512, 32, N'Mongolia' UNION ALL 
SELECT 5224, 512, 34, N'to Mongolia' UNION ALL 
SELECT 5225, 512, 35, N'in Mongolia' UNION ALL 
SELECT 5226, 513, 31, N'a' UNION ALL 
SELECT 5227, 513, 32, N'Laos' UNION ALL 
SELECT 5228, 513, 34, N'to Laos' UNION ALL 
SELECT 5229, 513, 35, N'in Laos' UNION ALL 
SELECT 5230, 514, 31, N'a' UNION ALL 
SELECT 5231, 514, 32, N'Cambodia' UNION ALL 
SELECT 5232, 514, 34, N'to Cambodia' UNION ALL 
SELECT 5233, 514, 35, N'in Cambodia' UNION ALL 
SELECT 5234, 515, 31, N'a' UNION ALL 
SELECT 5235, 515, 32, N'Vietnam' UNION ALL 
SELECT 5236, 515, 34, N'to Vietnam' UNION ALL 
SELECT 5237, 515, 35, N'in Vietnam' UNION ALL 
SELECT 5238, 516, 31, N'a' UNION ALL 
SELECT 5239, 516, 32, N'Myanmar' UNION ALL 
SELECT 5240, 516, 34, N'to Myanmar' UNION ALL 
SELECT 5241, 516, 35, N'in Myanmar' UNION ALL 
SELECT 5242, 517, 31, N'a' UNION ALL 
SELECT 5243, 517, 32, N'South Korea' UNION ALL 
SELECT 5244, 517, 34, N'to South Korea' UNION ALL 
SELECT 5245, 517, 35, N'in South Korea' UNION ALL 
SELECT 5246, 518, 31, N'a' UNION ALL 
SELECT 5247, 518, 32, N'North Korea' UNION ALL 
SELECT 5248, 518, 34, N'to North Korea' UNION ALL 
SELECT 5249, 518, 35, N'in North Korea' UNION ALL 
SELECT 5250, 519, 31, N'a' UNION ALL 
SELECT 5251, 519, 32, N'Malaysia' UNION ALL 
SELECT 5252, 519, 34, N'to Malaysia' UNION ALL 
SELECT 5253, 519, 35, N'in Malaysia' UNION ALL 
SELECT 5254, 520, 31, N'an' UNION ALL 
SELECT 5255, 520, 32, N'Indonesia' UNION ALL 
SELECT 5256, 520, 34, N'to Indonesia' UNION ALL 
SELECT 5257, 520, 35, N'in Indonesia' UNION ALL 
SELECT 5258, 521, 33, N'the Philippines' UNION ALL 
SELECT 5259, 521, 34, N'to the Philippines' UNION ALL 
SELECT 5260, 521, 35, N'in the Philippines' UNION ALL 
SELECT 5261, 522, 31, N'a' UNION ALL 
SELECT 5262, 522, 32, N'Taiwan' UNION ALL 
SELECT 5263, 522, 34, N'to Taiwan' UNION ALL 
SELECT 5264, 522, 35, N'in Taiwan' UNION ALL 
SELECT 5265, 523, 31, N'a' UNION ALL 
SELECT 5266, 523, 32, N'Hongkong' UNION ALL 
SELECT 5267, 523, 34, N'to Hongkong' UNION ALL 
SELECT 5268, 523, 35, N'in Hongkong' UNION ALL 
SELECT 5269, 524, 31, N'a' UNION ALL 
SELECT 5270, 524, 32, N'Singapur' UNION ALL 
SELECT 5271, 524, 34, N'to Singapur' UNION ALL 
SELECT 5272, 524, 35, N'in Singapur' UNION ALL 
SELECT 5273, 525, 31, N'an' UNION ALL 
SELECT 5274, 525, 32, N'Australia' UNION ALL 
SELECT 5275, 525, 34, N'to Australia' UNION ALL 
SELECT 5276, 525, 35, N'in Australia' UNION ALL 
SELECT 5277, 526, 31, N'a' UNION ALL 
SELECT 5278, 526, 32, N'New Zealand' UNION ALL 
SELECT 5279, 526, 34, N'to New Zealand' UNION ALL 
SELECT 5280, 526, 35, N'in New Zealand' UNION ALL 
SELECT 5281, 527, 31, N'a' UNION ALL 
SELECT 5282, 527, 32, N'Fiji' UNION ALL 
SELECT 5283, 527, 34, N'to Fiji' UNION ALL 
SELECT 5284, 527, 35, N'in Fiji' UNION ALL 
SELECT 5285, 528, 31, N'an' UNION ALL 
SELECT 5286, 528, 32, N'Egypt' UNION ALL 
SELECT 5287, 528, 34, N'to Egypt' UNION ALL 
SELECT 5288, 528, 35, N'in Egypt' UNION ALL 
SELECT 5289, 529, 31, N'a' UNION ALL 
SELECT 5290, 529, 32, N'Libya' UNION ALL 
SELECT 5291, 529, 34, N'to Libya' UNION ALL 
SELECT 5292, 529, 35, N'in Libya' UNION ALL 
SELECT 5293, 530, 31, N'a' UNION ALL 
SELECT 5294, 530, 32, N'Tunisia' UNION ALL 
SELECT 5295, 530, 34, N'to Tunisia' UNION ALL 
SELECT 5296, 530, 35, N'in Tunisia' UNION ALL 
SELECT 5297, 531, 31, N'a' UNION ALL 
SELECT 5298, 531, 32, N'Morocco' UNION ALL 
SELECT 5299, 531, 34, N'to Morocco' UNION ALL 
SELECT 5300, 531, 35, N'in Morocco' UNION ALL 
SELECT 5301, 532, 31, N'an' UNION ALL 
SELECT 5302, 532, 32, N'Algeria' UNION ALL 
SELECT 5303, 532, 34, N'to Algeria' UNION ALL 
SELECT 5304, 532, 35, N'in Algeria' UNION ALL 
SELECT 5305, 533, 31, N'a' UNION ALL 
SELECT 5306, 533, 32, N'Sudan' UNION ALL 
SELECT 5307, 533, 34, N'to Sudan' UNION ALL 
SELECT 5308, 533, 35, N'in Sudan' UNION ALL 
SELECT 5309, 534, 31, N'an' UNION ALL 
SELECT 5310, 534, 32, N'Ethiopia' UNION ALL 
SELECT 5311, 534, 34, N'to Ethiopia' UNION ALL 
SELECT 5312, 534, 35, N'in Ethiopia' UNION ALL 
SELECT 5313, 535, 31, N'an' UNION ALL 
SELECT 5314, 535, 32, N'Eritrea' UNION ALL 
SELECT 5315, 535, 34, N'to Eritrea' UNION ALL 
SELECT 5316, 535, 35, N'in Eritrea' UNION ALL 
SELECT 5317, 536, 31, N'a' UNION ALL 
SELECT 5318, 536, 32, N'Djibuti' UNION ALL 
SELECT 5319, 536, 34, N'to Djibuti' UNION ALL 
SELECT 5320, 536, 35, N'in Djibuti' UNION ALL 
SELECT 5321, 537, 31, N'a' UNION ALL 
SELECT 5322, 537, 32, N'Chad' UNION ALL 
SELECT 5323, 537, 34, N'to Chad' UNION ALL 
SELECT 5324, 537, 35, N'in Chad' UNION ALL 
SELECT 5325, 538, 31, N'a' UNION ALL 
SELECT 5326, 538, 32, N'Mauretania' UNION ALL 
SELECT 5327, 538, 34, N'to Mauretania' UNION ALL 
SELECT 5328, 538, 35, N'in Mauretania' UNION ALL 
SELECT 5329, 539, 31, N'a' UNION ALL 
SELECT 5330, 539, 32, N'Burkina Faso' UNION ALL 
SELECT 5331, 539, 34, N'to Burkina Faso' UNION ALL 
SELECT 5332, 539, 35, N'in Burkina Faso' UNION ALL 
SELECT 5333, 540, 31, N'a' UNION ALL 
SELECT 5334, 540, 32, N'Mali' UNION ALL 
SELECT 5335, 540, 34, N'to Mali' UNION ALL 
SELECT 5336, 540, 35, N'in Mali' UNION ALL 
SELECT 5337, 541, 31, N'a' UNION ALL 
SELECT 5338, 541, 32, N'Senegal' UNION ALL 
SELECT 5339, 541, 34, N'to Senegal' UNION ALL 
SELECT 5340, 541, 35, N'in Senegal' UNION ALL 
SELECT 5341, 542, 31, N'a' UNION ALL 
SELECT 5342, 542, 32, N'Gambia' UNION ALL 
SELECT 5343, 542, 34, N'to Gambia' UNION ALL 
SELECT 5344, 542, 35, N'in Gambia' UNION ALL 
SELECT 5345, 543, 31, N'a' UNION ALL 
SELECT 5346, 543, 32, N'Guinea' UNION ALL 
SELECT 5347, 543, 34, N'to Guinea' UNION ALL 
SELECT 5348, 543, 35, N'in Guinea' UNION ALL 
SELECT 5349, 544, 31, N'a' UNION ALL 
SELECT 5350, 544, 32, N'Ghana' UNION ALL 
SELECT 5351, 544, 34, N'to Ghana' UNION ALL 
SELECT 5352, 544, 35, N'in Ghana' UNION ALL 
SELECT 5353, 545, 31, N'a' UNION ALL 
SELECT 5354, 545, 32, N'Somalia' UNION ALL 
SELECT 5355, 545, 34, N'to Somalia' UNION ALL 
SELECT 5356, 545, 35, N'in Somalia' UNION ALL 
SELECT 5357, 546, 31, N'an' UNION ALL 
SELECT 5358, 546, 32, N'Ivory Coast' UNION ALL 
SELECT 5359, 546, 34, N'to Ivory Coast' UNION ALL 
SELECT 5360, 546, 35, N'in Ivory Coast' UNION ALL 
SELECT 5361, 547, 31, N'a' UNION ALL 
SELECT 5362, 547, 32, N'Togo' UNION ALL 
SELECT 5363, 547, 34, N'to Togo' UNION ALL 
SELECT 5364, 547, 35, N'in Togo' UNION ALL 
SELECT 5365, 548, 31, N'a' UNION ALL 
SELECT 5366, 548, 32, N'Liberia' UNION ALL 
SELECT 5367, 548, 34, N'to Liberia' UNION ALL 
SELECT 5368, 548, 35, N'in Liberia' UNION ALL 
SELECT 5369, 549, 31, N'a' UNION ALL 
SELECT 5370, 549, 32, N'Sierra Leone' UNION ALL 
SELECT 5371, 549, 34, N'to Sierra Leone' UNION ALL 
SELECT 5372, 549, 35, N'in Sierra Leone' UNION ALL 
SELECT 5373, 550, 31, N'a' UNION ALL 
SELECT 5374, 550, 32, N'Niger' UNION ALL 
SELECT 5375, 550, 34, N'to Niger' UNION ALL 
SELECT 5376, 550, 35, N'in Niger' UNION ALL 
SELECT 5377, 551, 31, N'a' UNION ALL 
SELECT 5378, 551, 32, N'Nigeria' UNION ALL 
SELECT 5379, 551, 34, N'to Nigeria' UNION ALL 
SELECT 5380, 551, 35, N'in Nigeria' UNION ALL 
SELECT 5381, 552, 31, N'a' UNION ALL 
SELECT 5382, 552, 32, N'Cameroon' UNION ALL 
SELECT 5383, 552, 34, N'to Cameroon' UNION ALL 
SELECT 5384, 552, 35, N'in Cameroon' UNION ALL 
SELECT 5385, 553, 31, N'a' UNION ALL 
SELECT 5386, 553, 32, N'Gabon' UNION ALL 
SELECT 5387, 553, 34, N'to Gabon' UNION ALL 
SELECT 5388, 553, 35, N'in Gabon' UNION ALL 
SELECT 5389, 554, 31, N'a' UNION ALL 
SELECT 5390, 554, 32, N'Congo' UNION ALL 
SELECT 5391, 554, 34, N'to Congo' UNION ALL 
SELECT 5392, 554, 35, N'in Congo' UNION ALL 
SELECT 5393, 555, 31, N'a' UNION ALL 
SELECT 5394, 555, 32, N'the Democratic Republic of Congo' UNION ALL 
SELECT 5395, 555, 34, N'to the Democratic Republic of Congo' UNION ALL 
SELECT 5396, 555, 35, N'in the Democratic Republic of Congo' UNION ALL 
SELECT 5397, 556, 31, N'an' UNION ALL 
SELECT 5398, 556, 32, N'Uganda' UNION ALL 
SELECT 5399, 556, 34, N'to Uganda' UNION ALL 
SELECT 5400, 556, 35, N'in Uganda' UNION ALL 
SELECT 5401, 557, 31, N'a' UNION ALL 
SELECT 5402, 557, 32, N'Burundi' UNION ALL 
SELECT 5403, 557, 34, N'to Burundi' UNION ALL 
SELECT 5404, 557, 35, N'in Burundi' UNION ALL 
SELECT 5405, 558, 31, N'a' UNION ALL 
SELECT 5406, 558, 32, N'Kenya' UNION ALL 
SELECT 5407, 558, 34, N'to Kenya' UNION ALL 
SELECT 5408, 558, 35, N'in Kenya' UNION ALL 
SELECT 5409, 559, 31, N'a' UNION ALL 
SELECT 5410, 559, 32, N'Tanzania' UNION ALL 
SELECT 5411, 559, 34, N'to Tanzania' UNION ALL 
SELECT 5412, 559, 35, N'in Tanzania' UNION ALL 
SELECT 5413, 560, 31, N'a' UNION ALL 
SELECT 5414, 560, 32, N'Mozambique' UNION ALL 
SELECT 5415, 560, 34, N'to Mozambique' UNION ALL 
SELECT 5416, 560, 35, N'in Mozambique' UNION ALL 
SELECT 5417, 561, 31, N'a' UNION ALL 
SELECT 5418, 561, 32, N'Rwanda' UNION ALL 
SELECT 5419, 561, 34, N'to Rwanda' UNION ALL 
SELECT 5420, 561, 35, N'in Rwanda' UNION ALL 
SELECT 5421, 562, 31, N'a' UNION ALL 
SELECT 5422, 562, 32, N'Madagascar' UNION ALL 
SELECT 5423, 562, 34, N'to Madagascar' UNION ALL 
SELECT 5424, 562, 35, N'in Madagascar' UNION ALL 
SELECT 5425, 563, 31, N'an' UNION ALL 
SELECT 5426, 563, 32, N'Angola' UNION ALL 
SELECT 5427, 563, 34, N'to Angola' UNION ALL 
SELECT 5428, 563, 35, N'in Angola' UNION ALL 
SELECT 5429, 564, 31, N'a' UNION ALL 
SELECT 5430, 564, 32, N'Namibia' UNION ALL 
SELECT 5431, 564, 34, N'to Namibia' UNION ALL 
SELECT 5432, 564, 35, N'in Namibia' UNION ALL 
SELECT 5433, 565, 31, N'a' UNION ALL 
SELECT 5434, 565, 32, N'South Africa' UNION ALL 
SELECT 5435, 565, 34, N'to South Africa' UNION ALL 
SELECT 5436, 565, 35, N'in South Africa' UNION ALL 
SELECT 5437, 566, 31, N'a' UNION ALL 
SELECT 5438, 566, 32, N'Zambia' UNION ALL 
SELECT 5439, 566, 34, N'to Zambia' UNION ALL 
SELECT 5440, 566, 35, N'in Zambia' UNION ALL 
SELECT 5441, 567, 31, N'a' UNION ALL 
SELECT 5442, 567, 32, N'Zimbabwe' UNION ALL 
SELECT 5443, 567, 34, N'to Zimbabwe' UNION ALL 
SELECT 5444, 567, 35, N'in Zimbabwe' UNION ALL 
SELECT 5445, 568, 31, N'a' UNION ALL 
SELECT 5446, 568, 32, N'Botswana' UNION ALL 
SELECT 5447, 568, 34, N'to Botswana' UNION ALL 
SELECT 5448, 568, 35, N'in Botswana' UNION ALL 
SELECT 5449, 569, 33, N'the Seychelles' UNION ALL 
SELECT 5450, 569, 34, N'to the Seychelles' UNION ALL 
SELECT 5451, 569, 35, N'in the Seychelles' UNION ALL 
SELECT 5452, 570, 31, N'a' UNION ALL 
SELECT 5453, 570, 32, N'Mauritius' UNION ALL 
SELECT 5454, 570, 34, N'to Mauritius' UNION ALL 
SELECT 5455, 570, 35, N'in Mauritius' UNION ALL 
SELECT 5456, 571, 33, N'the USA' UNION ALL 
SELECT 5457, 571, 34, N'to the USA' UNION ALL 
SELECT 5458, 571, 35, N'in the USA' UNION ALL 
SELECT 5459, 572, 31, N'a' UNION ALL 
SELECT 5460, 572, 32, N'Canada' UNION ALL 
SELECT 5461, 572, 34, N'to Canada' UNION ALL 
SELECT 5462, 572, 35, N'in Canada' UNION ALL 
SELECT 5463, 573, 31, N'a' UNION ALL 
SELECT 5464, 573, 32, N'Mexico' UNION ALL 
SELECT 5465, 573, 34, N'to Mexico' UNION ALL 
SELECT 5466, 573, 35, N'in Mexico' UNION ALL 
SELECT 5467, 574, 31, N'a' UNION ALL 
SELECT 5468, 574, 32, N'Greenland' UNION ALL 
SELECT 5469, 574, 34, N'to Greenland' UNION ALL 
SELECT 5470, 574, 35, N'in Greenland' UNION ALL 
SELECT 5471, 575, 31, N'a' UNION ALL 
SELECT 5472, 575, 32, N'Jamaica' UNION ALL 
SELECT 5473, 575, 34, N'to Jamaica' UNION ALL 
SELECT 5474, 575, 35, N'in Jamaica' UNION ALL 
SELECT 5475, 576, 31, N'a' UNION ALL 
SELECT 5476, 576, 32, N'Cuba' UNION ALL 
SELECT 5477, 576, 34, N'to Cuba' UNION ALL 
SELECT 5478, 576, 35, N'in Cuba' UNION ALL 
SELECT 5479, 577, 31, N'a' UNION ALL 
SELECT 5480, 577, 32, N'Honduras' UNION ALL 
SELECT 5481, 577, 34, N'to Honduras' UNION ALL 
SELECT 5482, 577, 35, N'in Honduras' UNION ALL 
SELECT 5483, 578, 31, N'a' UNION ALL 
SELECT 5484, 578, 32, N'Salvador' UNION ALL 
SELECT 5485, 578, 34, N'to Salvador' UNION ALL 
SELECT 5486, 578, 35, N'in Salvador' UNION ALL 
SELECT 5487, 579, 31, N'a' UNION ALL 
SELECT 5488, 579, 32, N'Guatemala' UNION ALL 
SELECT 5489, 579, 34, N'to Guatemala' UNION ALL 
SELECT 5490, 579, 35, N'in Guatemala' UNION ALL 
SELECT 5491, 580, 31, N'a' UNION ALL 
SELECT 5492, 580, 32, N'Nicaragua' UNION ALL 
SELECT 5493, 580, 34, N'to Nicaragua' UNION ALL 
SELECT 5494, 580, 35, N'in Nicaragua' UNION ALL 
SELECT 5495, 581, 31, N'a' UNION ALL 
SELECT 5496, 581, 32, N'Panama' UNION ALL 
SELECT 5497, 581, 34, N'to Panama' UNION ALL 
SELECT 5498, 581, 35, N'in Panama' UNION ALL 
SELECT 5499, 582, 31, N'a' UNION ALL 
SELECT 5500, 582, 32, N'the Dominican Republic' UNION ALL 
SELECT 5501, 582, 34, N'to the Dominican Republic' UNION ALL 
SELECT 5502, 582, 35, N'in the Dominican Republic' UNION ALL 
SELECT 5503, 583, 31, N'a' UNION ALL 
SELECT 5504, 583, 32, N'Haiti' UNION ALL 
SELECT 5505, 583, 34, N'to Haiti' UNION ALL 
SELECT 5506, 583, 35, N'in Haiti' UNION ALL 
SELECT 5507, 584, 31, N'a' UNION ALL 
SELECT 5508, 584, 32, N'Puerto Rico' UNION ALL 
SELECT 5509, 584, 34, N'to Puerto Rico' UNION ALL 
SELECT 5510, 584, 35, N'in Puerto Rico' UNION ALL 
SELECT 5511, 585, 31, N'a' UNION ALL 
SELECT 5512, 585, 32, N'Costa Rica' UNION ALL 
SELECT 5513, 585, 34, N'to Costa Rica' UNION ALL 
SELECT 5514, 585, 35, N'in Costa Rica' UNION ALL 
SELECT 5515, 586, 31, N'a' UNION ALL 
SELECT 5516, 586, 32, N'Belize' UNION ALL 
SELECT 5517, 586, 34, N'to Belize' UNION ALL 
SELECT 5518, 586, 35, N'in Belize' UNION ALL 
SELECT 5519, 587, 33, N'the Bahamas' UNION ALL 
SELECT 5520, 587, 34, N'to the Bahamas' UNION ALL 
SELECT 5521, 587, 35, N'in the Bahamas' UNION ALL 
SELECT 5522, 588, 31, N'an' UNION ALL 
SELECT 5523, 588, 32, N'Europe' UNION ALL 
SELECT 5524, 588, 34, N'to Europe' UNION ALL 
SELECT 5525, 588, 35, N'in Europe' UNION ALL 
SELECT 5526, 589, 31, N'a' UNION ALL 
SELECT 5527, 589, 32, N'South America' UNION ALL 
SELECT 5528, 589, 34, N'to South America' UNION ALL 
SELECT 5529, 589, 35, N'in South America' UNION ALL 
SELECT 5530, 590, 31, N'a' UNION ALL 
SELECT 5531, 590, 32, N'North America' UNION ALL 
SELECT 5532, 590, 34, N'to North America' UNION ALL 
SELECT 5533, 590, 35, N'in North America' UNION ALL 
SELECT 5534, 591, 31, N'an' UNION ALL 
SELECT 5535, 591, 32, N'Africa' UNION ALL 
SELECT 5536, 591, 34, N'to Africa' UNION ALL 
SELECT 5537, 591, 35, N'in Africa' UNION ALL 
SELECT 5538, 592, 31, N'an' UNION ALL 
SELECT 5539, 592, 32, N'Asia' UNION ALL 
SELECT 5540, 592, 34, N'to Asia' UNION ALL 
SELECT 5541, 592, 35, N'in Asia' UNION ALL 
SELECT 5542, 593, 31, N'an' UNION ALL 
SELECT 5543, 593, 32, N'Oceania' UNION ALL 
SELECT 5544, 593, 34, N'to Oceania' UNION ALL 
SELECT 5545, 593, 35, N'in Oceania' UNION ALL 
SELECT 5546, 594, 31, N'a' UNION ALL 
SELECT 5547, 594, 32, N'Scandinavia' UNION ALL 
SELECT 5548, 594, 34, N'to Scandinavia' UNION ALL 
SELECT 5549, 594, 35, N'in Scandinavia' UNION ALL 
SELECT 5550, 595, 31, N'a' UNION ALL 
SELECT 5551, 595, 32, N'the Caucasus' UNION ALL 
SELECT 5552, 595, 34, N'to the Caucasus' UNION ALL 
SELECT 5553, 595, 35, N'in the Caucasus' UNION ALL 
SELECT 5554, 596, 33, N'the Caribbean' UNION ALL 
SELECT 5555, 596, 34, N'to the Caribbean' UNION ALL 
SELECT 5556, 596, 35, N'in the Caribbean' UNION ALL 
SELECT 5557, 597, 31, N'a' UNION ALL 
SELECT 5558, 597, 32, N'cat' UNION ALL 
SELECT 5559, 597, 33, N'cats' UNION ALL 
SELECT 5560, 598, 31, N'a' UNION ALL 
SELECT 5561, 598, 32, N'hamster' UNION ALL 
SELECT 5562, 598, 33, N'hamsters' UNION ALL 
SELECT 5563, 599, 31, N'a' UNION ALL 
SELECT 5564, 599, 32, N'cow' UNION ALL 
SELECT 5565, 599, 33, N'cows' UNION ALL 
SELECT 5566, 600, 31, N'a' UNION ALL 
SELECT 5567, 600, 32, N'horse' UNION ALL 
SELECT 5568, 600, 33, N'horses' UNION ALL 
SELECT 5569, 601, 31, N'a' UNION ALL 
SELECT 5570, 601, 32, N'fly' UNION ALL 
SELECT 5571, 601, 33, N'flies' UNION ALL 
SELECT 5572, 602, 31, N'a' UNION ALL 
SELECT 5573, 602, 32, N'bee' UNION ALL 
SELECT 5574, 602, 33, N'bees' UNION ALL 
SELECT 5575, 603, 31, N'a' UNION ALL 
SELECT 5576, 603, 32, N'wasp' UNION ALL 
SELECT 5577, 603, 33, N'wasps' UNION ALL 
SELECT 5578, 604, 31, N'a' UNION ALL 
SELECT 5579, 604, 32, N'mosquito' UNION ALL 
SELECT 5580, 604, 33, N'mosquitoes' UNION ALL 
SELECT 5581, 605, 31, N'a' UNION ALL 
SELECT 5582, 605, 32, N'frog' UNION ALL 
SELECT 5583, 605, 33, N'frogs' UNION ALL 
SELECT 5584, 606, 31, N'a' UNION ALL 
SELECT 5585, 606, 32, N'bird' UNION ALL 
SELECT 5586, 606, 33, N'birds' UNION ALL 
SELECT 5587, 607, 31, N'a' UNION ALL 
SELECT 5588, 607, 32, N'fish' UNION ALL 
SELECT 5589, 607, 33, N'fishes' UNION ALL 
SELECT 5590, 608, 31, N'a' UNION ALL 
SELECT 5591, 608, 32, N'stork' UNION ALL 
SELECT 5592, 608, 33, N'storks' UNION ALL 
SELECT 5593, 609, 31, N'a' UNION ALL 
SELECT 5594, 609, 32, N'sparrow' UNION ALL 
SELECT 5595, 609, 33, N'sparrows' UNION ALL 
SELECT 5596, 610, 31, N'a' UNION ALL 
SELECT 5597, 610, 32, N'butterfly' UNION ALL 
SELECT 5598, 610, 33, N'butterflies' UNION ALL 
SELECT 5599, 611, 31, N'a' UNION ALL 
SELECT 5600, 611, 32, N'monkey' UNION ALL 
SELECT 5601, 611, 33, N'monkeys' UNION ALL 
SELECT 5602, 612, 31, N'a' UNION ALL 
SELECT 5603, 612, 32, N'elephant' UNION ALL 
SELECT 5604, 612, 33, N'elephants' UNION ALL 
SELECT 5605, 613, 31, N'a' UNION ALL 
SELECT 5606, 613, 32, N'lion' UNION ALL 
SELECT 5607, 613, 33, N'lions' UNION ALL 
SELECT 5608, 614, 31, N'a' UNION ALL 
SELECT 5609, 614, 32, N'giraffe' UNION ALL 
SELECT 5610, 614, 33, N'giraffes' UNION ALL 
SELECT 5611, 615, 31, N'a' UNION ALL 
SELECT 5612, 615, 32, N'camel' UNION ALL 
SELECT 5613, 615, 33, N'camels' UNION ALL 
SELECT 5614, 616, 31, N'a' UNION ALL 
SELECT 5615, 616, 32, N'tiger' UNION ALL 
SELECT 5616, 616, 33, N'tigers' UNION ALL 
SELECT 5617, 617, 31, N'a' UNION ALL 
SELECT 5618, 617, 32, N'snake' UNION ALL 
SELECT 5619, 617, 33, N'snakes' UNION ALL 
SELECT 5620, 618, 31, N'a' UNION ALL 
SELECT 5621, 618, 32, N'shark' UNION ALL 
SELECT 5622, 618, 33, N'sharks' UNION ALL 
SELECT 5623, 619, 31, N'a' UNION ALL 
SELECT 5624, 619, 32, N'whale' UNION ALL 
SELECT 5625, 619, 33, N'whales' UNION ALL 
SELECT 5626, 620, 31, N'a' UNION ALL 
SELECT 5627, 620, 32, N'donkey' UNION ALL 
SELECT 5628, 620, 33, N'donkeys' UNION ALL 
SELECT 5629, 621, 31, N'a' UNION ALL 
SELECT 5630, 621, 32, N'sheep' UNION ALL 
SELECT 5631, 621, 33, N'sheep' UNION ALL 
SELECT 5632, 622, 31, N'a' UNION ALL 
SELECT 5633, 622, 32, N'pigeon' UNION ALL 
SELECT 5634, 622, 33, N'pigeons' UNION ALL 
SELECT 5635, 623, 31, N'a' UNION ALL 
SELECT 5636, 623, 32, N'falcon' UNION ALL 
SELECT 5637, 623, 33, N'falcons' UNION ALL 
SELECT 5638, 624, 31, N'an' UNION ALL 
SELECT 5639, 624, 32, N'eagle' UNION ALL 
SELECT 5640, 624, 33, N'eagles' UNION ALL 
SELECT 5641, 625, 31, N'a' UNION ALL 
SELECT 5642, 625, 32, N'hawk' UNION ALL 
SELECT 5643, 625, 33, N'hawks' UNION ALL 
SELECT 5644, 626, 33, N'the Andes' UNION ALL 
SELECT 5645, 626, 34, N'to the Andes' UNION ALL 
SELECT 5646, 626, 35, N'in the Andes' UNION ALL 
SELECT 5647, 627, 33, N'the Himalayas' UNION ALL 
SELECT 5648, 627, 34, N'to the Himalayas' UNION ALL 
SELECT 5649, 627, 35, N'in the Himalayas' UNION ALL 
SELECT 5650, 628, 33, N'the Alps' UNION ALL 
SELECT 5651, 628, 34, N'to the Alps' UNION ALL 
SELECT 5652, 628, 35, N'in the Alps' UNION ALL 
SELECT 5653, 629, 31, N'-' UNION ALL 
SELECT 5654, 629, 32, N'the Mediterranean Sea' UNION ALL 
SELECT 5655, 629, 34, N'to the Mediterranean Sea/to the Mediterranean' UNION ALL 
SELECT 5656, 629, 35, N'at the Mediterranean Sea' UNION ALL 
SELECT 5657, 630, 31, N'-' UNION ALL 
SELECT 5658, 630, 32, N'the Atlantic' UNION ALL 
SELECT 5659, 630, 34, N'to the Atlantic' UNION ALL 
SELECT 5660, 630, 35, N'at the Atlantic' UNION ALL 
SELECT 5661, 631, 31, N'-' UNION ALL 
SELECT 5662, 631, 32, N'the Pacific' UNION ALL 
SELECT 5663, 631, 34, N'to the Pacific' UNION ALL 
SELECT 5664, 631, 35, N'at the Pacific' UNION ALL 
SELECT 5665, 632, 31, N'-' UNION ALL 
SELECT 5666, 632, 32, N'the Indian Ocean' UNION ALL 
SELECT 5667, 632, 34, N'to the Indian Ocean' UNION ALL 
SELECT 5668, 632, 35, N'at the Indian Ocean' UNION ALL 
SELECT 5669, 633, 31, N'-' UNION ALL 
SELECT 5670, 633, 32, N'the Persian Gulf' UNION ALL 
SELECT 5671, 633, 34, N'to the Persian Gulf' UNION ALL 
SELECT 5672, 633, 35, N'at the Persian Gulf' UNION ALL 
SELECT 5673, 634, 31, N'-' UNION ALL 
SELECT 5674, 634, 32, N'the Baltic Sea' UNION ALL 
SELECT 5675, 634, 34, N'to the Baltic Sea' UNION ALL 
SELECT 5676, 634, 35, N'at the Baltic Sea' UNION ALL 
SELECT 5677, 635, 31, N'a' UNION ALL 
SELECT 5678, 635, 32, N'Sardinia' UNION ALL 
SELECT 5679, 635, 34, N'to Sardinia' UNION ALL 
SELECT 5680, 635, 35, N'in Sardinia' UNION ALL 
SELECT 5681, 636, 31, N'a' UNION ALL 
SELECT 5682, 636, 32, N'Sicily' UNION ALL 
SELECT 5683, 636, 34, N'to Sicily' UNION ALL 
SELECT 5684, 636, 35, N'in Sicily' UNION ALL 
SELECT 5685, 637, 31, N'a' UNION ALL 
SELECT 5686, 637, 32, N'Monday' UNION ALL 
SELECT 5687, 637, 33, N'Mondays' UNION ALL 
SELECT 5688, 638, 31, N'a' UNION ALL 
SELECT 5689, 638, 32, N'Tuesday' UNION ALL 
SELECT 5690, 638, 33, N'Tuesdays' UNION ALL 
SELECT 5691, 639, 31, N'a' UNION ALL 
SELECT 5692, 639, 32, N'Wednesday' UNION ALL 
SELECT 5693, 639, 33, N'Wednesdays' UNION ALL 
SELECT 5694, 640, 31, N'a' UNION ALL 
SELECT 5695, 640, 32, N'Thursday' UNION ALL 
SELECT 5696, 640, 33, N'Thursdays' UNION ALL 
SELECT 5697, 641, 31, N'a' UNION ALL 
SELECT 5698, 641, 32, N'Friday' UNION ALL 
SELECT 5699, 641, 33, N'Fridays' UNION ALL 
SELECT 5700, 642, 31, N'a' UNION ALL 
SELECT 5701, 642, 32, N'Saturday' UNION ALL 
SELECT 5702, 642, 33, N'Saturdays' UNION ALL 
SELECT 5703, 643, 31, N'a' UNION ALL 
SELECT 5704, 643, 32, N'Sunday' UNION ALL 
SELECT 5705, 643, 33, N'Sundays' UNION ALL 
SELECT 5706, 644, 31, N'a' UNION ALL 
SELECT 5707, 644, 32, N'January' UNION ALL 
SELECT 5708, 644, 33, N'Januaries' UNION ALL 
SELECT 5709, 645, 31, N'a' UNION ALL 
SELECT 5710, 645, 32, N'February' UNION ALL 
SELECT 5711, 645, 33, N'Februaries' UNION ALL 
SELECT 5712, 646, 31, N'a' UNION ALL 
SELECT 5713, 646, 32, N'March' UNION ALL 
SELECT 5714, 646, 33, N'Marches' UNION ALL 
SELECT 5715, 647, 31, N'an' UNION ALL 
SELECT 5716, 647, 32, N'April' UNION ALL 
SELECT 5717, 647, 33, N'Aprils' UNION ALL 
SELECT 5718, 648, 31, N'a' UNION ALL 
SELECT 5719, 648, 32, N'May' UNION ALL 
SELECT 5720, 648, 33, N'Mays' UNION ALL 
SELECT 5721, 649, 31, N'a' UNION ALL 
SELECT 5722, 649, 32, N'June' UNION ALL 
SELECT 5723, 649, 33, N'Junes' UNION ALL 
SELECT 5724, 650, 31, N'a' UNION ALL 
SELECT 5725, 650, 32, N'July' UNION ALL 
SELECT 5726, 650, 33, N'Julies' UNION ALL 
SELECT 5727, 651, 31, N'an' UNION ALL 
SELECT 5728, 651, 32, N'August' UNION ALL 
SELECT 5729, 651, 33, N'Augusts' UNION ALL 
SELECT 5730, 652, 31, N'a' UNION ALL 
SELECT 5731, 652, 32, N'September' UNION ALL 
SELECT 5732, 652, 33, N'Septembers' UNION ALL 
SELECT 5733, 653, 31, N'an' UNION ALL 
SELECT 5734, 653, 32, N'October' UNION ALL 
SELECT 5735, 653, 33, N'Octobers' UNION ALL 
SELECT 5736, 654, 31, N'a' UNION ALL 
SELECT 5737, 654, 32, N'November' UNION ALL 
SELECT 5738, 654, 33, N'Novembers' UNION ALL 
SELECT 5739, 655, 31, N'a' UNION ALL 
SELECT 5740, 655, 32, N'December' UNION ALL 
SELECT 5741, 655, 33, N'Decembers' UNION ALL 
SELECT 5742, 656, 31, N'a' UNION ALL 
SELECT 5743, 656, 32, N'year' UNION ALL 
SELECT 5744, 656, 33, N'years' UNION ALL 
SELECT 5745, 657, 31, N'a' UNION ALL 
SELECT 5746, 657, 32, N'month' UNION ALL 
SELECT 5747, 657, 33, N'months' UNION ALL 
SELECT 5748, 658, 31, N'a' UNION ALL 
SELECT 5749, 658, 32, N'day' UNION ALL 
SELECT 5750, 658, 33, N'days' UNION ALL 
SELECT 5751, 659, 31, N'a' UNION ALL 
SELECT 5752, 659, 32, N'week' UNION ALL 
SELECT 5753, 659, 33, N'weeks' UNION ALL 
SELECT 5754, 660, 31, N'an' UNION ALL 
SELECT 5755, 660, 32, N'hour' UNION ALL 
SELECT 5756, 660, 33, N'hours' UNION ALL 
SELECT 5757, 661, 31, N'a' UNION ALL 
SELECT 5758, 661, 32, N'minute' UNION ALL 
SELECT 5759, 661, 33, N'minutes' UNION ALL 
SELECT 5760, 662, 31, N'a' UNION ALL 
SELECT 5761, 662, 32, N'second' UNION ALL 
SELECT 5762, 662, 33, N'seconds' UNION ALL 
SELECT 5763, 663, 31, N'a' UNION ALL 
SELECT 5764, 663, 32, N'weekend' UNION ALL 
SELECT 5765, 663, 33, N'weekends' UNION ALL 
SELECT 5766, 664, 31, N'a' UNION ALL 
SELECT 5767, 664, 32, N'tomorrow' UNION ALL 
SELECT 5768, 665, 31, N'a' UNION ALL 
SELECT 5769, 665, 32, N'today' UNION ALL 
SELECT 5770, 666, 31, N'a' UNION ALL 
SELECT 5771, 666, 32, N'yesterday' UNION ALL 
SELECT 5772, 667, 31, N'a' UNION ALL 
SELECT 5773, 667, 32, N'turtle' UNION ALL 
SELECT 5774, 667, 33, N'turtles' UNION ALL 
SELECT 5775, 668, 31, N'a' UNION ALL 
SELECT 5776, 668, 32, N'crocodile' UNION ALL 
SELECT 5777, 668, 33, N'crocodiles' UNION ALL 
SELECT 5778, 669, 31, N'a' UNION ALL 
SELECT 5779, 669, 32, N'kangaroo' UNION ALL 
SELECT 5780, 669, 33, N'kangaroos' UNION ALL 
SELECT 5781, 670, 31, N'a' UNION ALL 
SELECT 5782, 670, 32, N'reptile' UNION ALL 
SELECT 5783, 670, 33, N'reptiles' UNION ALL 
SELECT 5784, 671, 31, N'an' UNION ALL 
SELECT 5785, 671, 32, N'amphibian' UNION ALL 
SELECT 5786, 671, 33, N'amphibians' UNION ALL 
SELECT 5787, 672, 31, N'a' UNION ALL 
SELECT 5788, 672, 32, N'mammal' UNION ALL 
SELECT 5789, 672, 33, N'mammals' UNION ALL 
SELECT 5790, 673, 31, N'a' UNION ALL 
SELECT 5791, 673, 32, N'worm' UNION ALL 
SELECT 5792, 673, 33, N'worms' UNION ALL 
SELECT 5793, 674, 31, N'an' UNION ALL 
SELECT 5794, 674, 32, N'insect' UNION ALL 
SELECT 5795, 674, 33, N'insects' UNION ALL 
SELECT 5796, 675, 31, N'an' UNION ALL 
SELECT 5797, 675, 32, N'apple' UNION ALL 
SELECT 5798, 675, 33, N'apples' UNION ALL 
SELECT 5799, 676, 31, N'a' UNION ALL 
SELECT 5800, 676, 32, N'pear' UNION ALL 
SELECT 5801, 676, 33, N'pears' UNION ALL 
SELECT 5802, 677, 31, N'a' UNION ALL 
SELECT 5803, 677, 32, N'cherry' UNION ALL 
SELECT 5804, 677, 33, N'cherries' UNION ALL 
SELECT 5805, 678, 31, N'a' UNION ALL 
SELECT 5806, 678, 32, N'strawberry' UNION ALL 
SELECT 5807, 678, 33, N'strawberries' UNION ALL 
SELECT 5808, 679, 31, N'a' UNION ALL 
SELECT 5809, 679, 32, N'pineapple' UNION ALL 
SELECT 5810, 679, 33, N'pineapples' UNION ALL 
SELECT 5811, 680, 31, N'an' UNION ALL 
SELECT 5812, 680, 32, N'orange' UNION ALL 
SELECT 5813, 680, 33, N'oranges' UNION ALL 
SELECT 5814, 681, 31, N'a' UNION ALL 
SELECT 5815, 681, 32, N'cherry' UNION ALL 
SELECT 5816, 681, 33, N'cherries' UNION ALL 
SELECT 5817, 682, 31, N'a' UNION ALL 
SELECT 5818, 682, 32, N'currant' UNION ALL 
SELECT 5819, 682, 33, N'currants' UNION ALL 
SELECT 5820, 683, 31, N'a' UNION ALL 
SELECT 5821, 683, 32, N'raspberry' UNION ALL 
SELECT 5822, 683, 33, N'raspberries' UNION ALL 
SELECT 5823, 684, 31, N'a' UNION ALL 
SELECT 5824, 684, 32, N'banana' UNION ALL 
SELECT 5825, 684, 33, N'bananas' UNION ALL 
SELECT 5826, 685, 31, N'a' UNION ALL 
SELECT 5827, 685, 32, N'hand' UNION ALL 
SELECT 5828, 685, 33, N'hands' UNION ALL 
SELECT 5829, 686, 31, N'a' UNION ALL 
SELECT 5830, 686, 32, N'book' UNION ALL 
SELECT 5831, 686, 33, N'books' UNION ALL 
SELECT 5832, 687, 31, N'a' UNION ALL 
SELECT 5833, 687, 32, N'game' UNION ALL 
SELECT 5834, 687, 33, N'games' UNION ALL 
SELECT 5835, 688, 31, N'a' UNION ALL 
SELECT 5836, 688, 32, N'product' UNION ALL 
SELECT 5837, 688, 33, N'products' UNION ALL 
SELECT 5838, 689, 31, N'a' UNION ALL 
SELECT 5839, 689, 32, N'car' UNION ALL 
SELECT 5840, 689, 33, N'cars' UNION ALL 
SELECT 5841, 690, 31, N'a' UNION ALL 
SELECT 5842, 690, 32, N'software' UNION ALL 
SELECT 5843, 691, 31, N'a' UNION ALL 
SELECT 5844, 691, 32, N'tv' UNION ALL 
SELECT 5845, 692, 31, N'an' UNION ALL 
SELECT 5846, 692, 32, N'internet' UNION ALL 
SELECT 5847, 693, 31, N'a' UNION ALL 
SELECT 5848, 693, 32, N'press' UNION ALL 
SELECT 5849, 694, 31, N'a' UNION ALL 
SELECT 5850, 694, 32, N'hotel' UNION ALL 
SELECT 5851, 694, 33, N'hotels' UNION ALL 
SELECT 5852, 694, 34, N'to hotel' UNION ALL 
SELECT 5853, 694, 35, N'in hotel' UNION ALL 
SELECT 5854, 695, 31, N'an' UNION ALL 
SELECT 5855, 695, 32, N'electricity' UNION ALL 
SELECT 5856, 696, 31, N'a' UNION ALL 
SELECT 5857, 696, 32, N'phone' UNION ALL 
SELECT 5858, 696, 33, N'phones' UNION ALL 
SELECT 5859, 697, 31, N'a' UNION ALL 
SELECT 5860, 697, 32, N'heating' UNION ALL 
SELECT 5861, 698, 31, N'a' UNION ALL 
SELECT 5862, 698, 32, N'water' UNION ALL 
SELECT 5863, 699, 31, N'a' UNION ALL 
SELECT 5864, 699, 32, N'gas' UNION ALL 
SELECT 5865, 700, 31, N'a' UNION ALL 
SELECT 5866, 700, 32, N'plane' UNION ALL 
SELECT 5867, 700, 33, N'planes' UNION ALL 
SELECT 5868, 701, 31, N'a' UNION ALL 
SELECT 5869, 701, 32, N'train' UNION ALL 
SELECT 5870, 701, 33, N'trains' UNION ALL 
SELECT 5871, 702, 31, N'a' UNION ALL 
SELECT 5872, 702, 32, N'bus' UNION ALL 
SELECT 5873, 702, 33, N'buses' UNION ALL 
SELECT 5874, 703, 31, N'a' UNION ALL 
SELECT 5875, 703, 32, N'lesson' UNION ALL 
SELECT 5876, 703, 33, N'lessons' UNION ALL 
SELECT 5877, 704, 31, N'a' UNION ALL 
SELECT 5878, 704, 32, N'sea' UNION ALL 
SELECT 5879, 704, 33, N'seas' UNION ALL 
SELECT 5880, 704, 34, N'to the seaside' UNION ALL 
SELECT 5881, 704, 35, N'at the seaside' UNION ALL 
SELECT 5882, 705, 31, N'a' UNION ALL 
SELECT 5883, 705, 32, N'lake' UNION ALL 
SELECT 5884, 705, 33, N'lakes' UNION ALL 
SELECT 5885, 705, 34, N'to the lake' UNION ALL 
SELECT 5886, 705, 35, N'at the lake' UNION ALL 
SELECT 5887, 706, 31, N'a' UNION ALL 
SELECT 5888, 706, 32, N'beach' UNION ALL 
SELECT 5889, 706, 33, N'beaches' UNION ALL 
SELECT 5890, 706, 34, N'to the beach' UNION ALL 
SELECT 5891, 706, 35, N'on the beach' UNION ALL 
SELECT 5892, 707, 31, N'a' UNION ALL 
SELECT 5893, 707, 32, N'hospital' UNION ALL 
SELECT 5894, 707, 33, N'hospitals' UNION ALL 
SELECT 5895, 708, 31, N'a' UNION ALL 
SELECT 5896, 708, 32, N'school' UNION ALL 
SELECT 5897, 708, 33, N'schools' UNION ALL 
SELECT 5898, 709, 31, N'a' UNION ALL 
SELECT 5899, 709, 32, N'post office' UNION ALL 
SELECT 5900, 709, 33, N'post offices' UNION ALL 
SELECT 5901, 710, 31, N'a' UNION ALL 
SELECT 5902, 710, 32, N'police' UNION ALL 
SELECT 5903, 711, 31, N'an' UNION ALL 
SELECT 5904, 711, 32, N'Oscar' UNION ALL 
SELECT 5905, 711, 33, N'Oscars' UNION ALL 
SELECT 5906, 712, 31, N'a' UNION ALL 
SELECT 5907, 712, 32, N'Nobel Prize' UNION ALL 
SELECT 5908, 712, 33, N'Nobel Prizes' UNION ALL 
SELECT 5909, 713, 31, N'a' UNION ALL 
SELECT 5910, 713, 32, N'fireman' UNION ALL 
SELECT 5911, 713, 33, N'firemen' UNION ALL 
SELECT 5912, 714, 31, N'a' UNION ALL 
SELECT 5913, 714, 32, N'doctor' UNION ALL 
SELECT 5914, 714, 33, N'doctors' UNION ALL 
SELECT 5915, 715, 31, N'a' UNION ALL 
SELECT 5916, 715, 32, N'police officer' UNION ALL 
SELECT 5917, 715, 33, N'police officers' UNION ALL 
SELECT 5918, 716, 31, N'a' UNION ALL 
SELECT 5919, 716, 32, N'teacher' UNION ALL 
SELECT 5920, 716, 33, N'teachers' UNION ALL 
SELECT 5921, 717, 31, N'a' UNION ALL 
SELECT 5922, 717, 32, N'taxi driver' UNION ALL 
SELECT 5923, 717, 33, N'taxi drivers' UNION ALL 
SELECT 5924, 718, 31, N'a' UNION ALL 
SELECT 5925, 718, 32, N'driver' UNION ALL 
SELECT 5926, 718, 33, N'drivers' UNION ALL 
SELECT 5927, 793, 31, N'a' UNION ALL 
SELECT 5928, 793, 32, N'head' UNION ALL 
SELECT 5929, 793, 33, N'heads' UNION ALL 
SELECT 5930, 794, 31, N'a' UNION ALL 
SELECT 5931, 794, 32, N'leg' UNION ALL 
SELECT 5932, 794, 33, N'legs' UNION ALL 
SELECT 5933, 795, 31, N'a' UNION ALL 
SELECT 5934, 795, 32, N'stomach' UNION ALL 
SELECT 5935, 795, 33, N'stomachs' UNION ALL 
SELECT 5936, 796, 31, N'a' UNION ALL 
SELECT 5937, 796, 32, N'hair' UNION ALL 
SELECT 5938, 796, 33, N'hairs' UNION ALL 
SELECT 5939, 797, 31, N'an' UNION ALL 
SELECT 5940, 797, 32, N'eye' UNION ALL 
SELECT 5941, 797, 33, N'eyes' UNION ALL 
SELECT 5942, 798, 31, N'an' UNION ALL 
SELECT 5943, 798, 32, N'ear' UNION ALL 
SELECT 5944, 798, 33, N'ears' UNION ALL 
SELECT 5945, 799, 31, N'a' UNION ALL 
SELECT 5946, 799, 32, N'nose' UNION ALL 
SELECT 5947, 799, 33, N'noses' UNION ALL 
SELECT 5948, 800, 31, N'a' UNION ALL 
SELECT 5949, 800, 32, N'nail' UNION ALL 
SELECT 5950, 800, 33, N'nails' UNION ALL 
SELECT 5951, 801, 31, N'a' UNION ALL 
SELECT 5952, 801, 32, N'finger' UNION ALL 
SELECT 5953, 801, 33, N'fingers' UNION ALL 
SELECT 5954, 802, 31, N'a' UNION ALL 
SELECT 5955, 802, 32, N'shoulder' UNION ALL 
SELECT 5956, 802, 33, N'shoulders' UNION ALL 
SELECT 5957, 803, 31, N'a' UNION ALL 
SELECT 5958, 803, 32, N'neck' UNION ALL 
SELECT 5959, 803, 33, N'necks' UNION ALL 
SELECT 5960, 804, 31, N'a' UNION ALL 
SELECT 5961, 804, 32, N'mouth' UNION ALL 
SELECT 5962, 804, 33, N'mouths' UNION ALL 
SELECT 5963, 805, 31, N'a' UNION ALL 
SELECT 5964, 805, 32, N'tooth' UNION ALL 
SELECT 5965, 805, 33, N'teeth' UNION ALL 
SELECT 5966, 806, 31, N'a' UNION ALL 
SELECT 5967, 806, 32, N'tounge' UNION ALL 
SELECT 5968, 806, 33, N'tounges' UNION ALL 
SELECT 5969, 807, 31, N'a' UNION ALL 
SELECT 5970, 807, 32, N'heart' UNION ALL 
SELECT 5971, 807, 33, N'hearts' UNION ALL 
SELECT 5972, 808, 31, N'a' UNION ALL 
SELECT 5973, 808, 32, N'liver' UNION ALL 
SELECT 5974, 808, 33, N'livers' UNION ALL 
SELECT 5975, 809, 31, N'a' UNION ALL 
SELECT 5976, 809, 32, N'stomach' UNION ALL 
SELECT 5977, 809, 33, N'stomachs' UNION ALL 
SELECT 5978, 810, 31, N'a' UNION ALL 
SELECT 5979, 810, 32, N'knee' UNION ALL 
SELECT 5980, 810, 33, N'knees' UNION ALL 
SELECT 5981, 811, 31, N'an' UNION ALL 
SELECT 5982, 811, 32, N'elbow' UNION ALL 
SELECT 5983, 811, 33, N'elbows' UNION ALL 
SELECT 5984, 812, 31, N'a' UNION ALL 
SELECT 5985, 812, 32, N'foot' UNION ALL 
SELECT 5986, 812, 33, N'feet' UNION ALL 
SELECT 5987, 813, 31, N'a' UNION ALL 
SELECT 5988, 813, 32, N'heel' UNION ALL 
SELECT 5989, 813, 33, N'heels' UNION ALL 
SELECT 5990, 814, 31, N'a' UNION ALL 
SELECT 5991, 814, 32, N'cheek' UNION ALL 
SELECT 5992, 814, 33, N'cheeks' UNION ALL 
SELECT 5993, 815, 31, N'an' UNION ALL 
SELECT 5994, 815, 32, N'eyebrow' UNION ALL 
SELECT 5995, 815, 33, N'eyebrows' UNION ALL 
SELECT 5996, 816, 31, N'an' UNION ALL 
SELECT 5997, 816, 32, N'eyelash' UNION ALL 
SELECT 5998, 816, 33, N'eyelashes' UNION ALL 
SELECT 5999, 817, 31, N'an' UNION ALL 
SELECT 6000, 817, 32, N'eyelid' UNION ALL 
SELECT 6001, 817, 33, N'eyelids' UNION ALL 
SELECT 6002, 818, 31, N'a' UNION ALL 
SELECT 6003, 818, 32, N'forehead' UNION ALL 
SELECT 6004, 818, 33, N'foreheads' UNION ALL 
SELECT 6005, 819, 31, N'a' UNION ALL 
SELECT 6006, 819, 32, N'spine' UNION ALL 
SELECT 6007, 819, 33, N'spines' UNION ALL 
SELECT 6008, 820, 31, N'a' UNION ALL 
SELECT 6009, 820, 32, N'lung' UNION ALL 
SELECT 6010, 820, 33, N'lungs' UNION ALL 
SELECT 6011, 821, 31, N'a' UNION ALL 
SELECT 6012, 821, 32, N'vein' UNION ALL 
SELECT 6013, 821, 33, N'veins' UNION ALL 
SELECT 6014, 822, 31, N'a' UNION ALL 
SELECT 6015, 822, 32, N'blood' UNION ALL 
SELECT 6016, 823, 31, N'a' UNION ALL 
SELECT 6017, 823, 32, N'throat' UNION ALL 
SELECT 6018, 823, 33, N'throats' UNION ALL 
SELECT 6019, 824, 31, N'a' UNION ALL 
SELECT 6020, 824, 32, N'brain' UNION ALL 
SELECT 6021, 824, 33, N'brains' UNION ALL 
SELECT 6022, 825, 31, N'a' UNION ALL 
SELECT 6023, 825, 32, N'Bosnia and Herzegovina' UNION ALL 
SELECT 6024, 825, 34, N'to Bosnia and Herzegovina' UNION ALL 
SELECT 6025, 825, 35, N'in Bosnia and Herzegovina' UNION ALL 
SELECT 6026, 826, 31, N'a' UNION ALL 
SELECT 6027, 826, 32, N'Bosnia-Herzegovina' UNION ALL 
SELECT 6028, 826, 34, N'to Bosnia-Herzegovina' UNION ALL 
SELECT 6029, 826, 35, N'in Bosnia-Herzegovina' UNION ALL 
SELECT 6030, 827, 31, N'a' UNION ALL 
SELECT 6031, 827, 32, N'Bosnia' UNION ALL 
SELECT 6032, 827, 34, N'to Bosnia' UNION ALL 
SELECT 6033, 827, 35, N'in Bosnia' UNION ALL 
SELECT 6034, 828, 31, N'-' UNION ALL 
SELECT 6035, 828, 32, N'the United Kingdom' UNION ALL 
SELECT 6036, 828, 34, N'to the United Kingdom' UNION ALL 
SELECT 6037, 828, 35, N'in the United Kingdom' UNION ALL 
SELECT 6038, 829, 31, N'-' UNION ALL 
SELECT 6039, 829, 32, N'the UK' UNION ALL 
SELECT 6040, 829, 34, N'to the UK' UNION ALL 
SELECT 6041, 829, 35, N'in the UK' UNION ALL 
SELECT 6042, 830, 33, N'the UAE' UNION ALL 
SELECT 6043, 830, 34, N'to the UAE' UNION ALL 
SELECT 6044, 830, 35, N'in the UAE' UNION ALL 
SELECT 6045, 831, 33, N'the Emirates' UNION ALL 
SELECT 6046, 831, 34, N'to the Emirates' UNION ALL 
SELECT 6047, 831, 35, N'in the Emirates' UNION ALL 
SELECT 6048, 832, 31, N'a' UNION ALL 
SELECT 6049, 832, 32, N'Burma' UNION ALL 
SELECT 6050, 832, 34, N'to Burma' UNION ALL 
SELECT 6051, 832, 35, N'in Burma' UNION ALL 
SELECT 6052, 833, 31, N'a' UNION ALL 
SELECT 6053, 833, 32, N'DR Congo' UNION ALL 
SELECT 6054, 833, 34, N'to DR Congo' UNION ALL 
SELECT 6055, 833, 35, N'in DR Congo' UNION ALL 
SELECT 6056, 834, 31, N'a' UNION ALL 
SELECT 6057, 834, 32, N'DRC' UNION ALL 
SELECT 6058, 834, 34, N'to DRC' UNION ALL 
SELECT 6059, 834, 35, N'in DRC' UNION ALL 
SELECT 6060, 835, 31, N'a' UNION ALL 
SELECT 6061, 835, 32, N'Congo-Kinshasa' UNION ALL 
SELECT 6062, 835, 34, N'to Congo-Kinshasa' UNION ALL 
SELECT 6063, 835, 35, N'in Congo-Kinshasa' UNION ALL 
SELECT 6064, 836, 31, N'a' UNION ALL 
SELECT 6065, 836, 32, N'Congo-Zaire' UNION ALL 
SELECT 6066, 836, 34, N'to Congo-Zaire' UNION ALL 
SELECT 6067, 836, 35, N'in Congo-Zaire' UNION ALL 
SELECT 6068, 837, 31, N'a' UNION ALL 
SELECT 6069, 837, 32, N'DROC' UNION ALL 
SELECT 6070, 837, 34, N'to DROC' UNION ALL 
SELECT 6071, 837, 35, N'in DROC' UNION ALL 
SELECT 6072, 838, 33, N'the United States' UNION ALL 
SELECT 6073, 838, 34, N'to the United States' UNION ALL 
SELECT 6074, 838, 35, N'in the United States' UNION ALL 
SELECT 6075, 839, 31, N'a' UNION ALL 
SELECT 6076, 839, 32, N'dove' UNION ALL 
SELECT 6077, 839, 33, N'doves' UNION ALL 
SELECT 6078, 840, 31, N'a' UNION ALL 
SELECT 6079, 840, 32, N'mouse' UNION ALL 
SELECT 6080, 840, 33, N'mice' UNION ALL 
SELECT 6081, 841, 31, N'a' UNION ALL 
SELECT 6082, 841, 32, N'rat' UNION ALL 
SELECT 6083, 841, 33, N'rats' UNION ALL 
SELECT 6084, 842, 31, N'a' UNION ALL 
SELECT 6085, 842, 32, N'Himalaya' UNION ALL 
SELECT 6086, 842, 34, N'to Himalaya' UNION ALL 
SELECT 6087, 842, 35, N'in Himalaya' UNION ALL 
SELECT 6088, 843, 31, N'-' UNION ALL 
SELECT 6089, 843, 32, N'the Atlantic Ocean' UNION ALL 
SELECT 6090, 843, 34, N'to the Atlantic Ocean' UNION ALL 
SELECT 6091, 843, 35, N'at the Atlantic Ocean' UNION ALL 
SELECT 6092, 844, 31, N'-' UNION ALL 
SELECT 6093, 844, 32, N'the Pacific Ocean' UNION ALL 
SELECT 6094, 844, 34, N'to the Pacific Ocean' UNION ALL 
SELECT 6095, 844, 35, N'at the Pacific Ocean' UNION ALL 
SELECT 6096, 845, 33, N'the Balkans' UNION ALL 
SELECT 6097, 845, 34, N'to the Balkans' UNION ALL 
SELECT 6098, 845, 35, N'in the Balkans' UNION ALL 
SELECT 6099, 846, 31, N'a' UNION ALL 
SELECT 6100, 846, 32, N'bug' UNION ALL 
SELECT 6101, 846, 33, N'bugs' UNION ALL 
SELECT 6102, 847, 31, N'an' UNION ALL 
SELECT 6103, 847, 32, N'arm' UNION ALL 
SELECT 6104, 847, 33, N'arms' UNION ALL 
SELECT 6105, 848, 31, N'a' UNION ALL 
SELECT 6106, 848, 32, N'television' UNION ALL 
SELECT 6107, 849, 31, N'an' UNION ALL 
SELECT 6108, 849, 32, N'airplane' UNION ALL 
SELECT 6109, 849, 33, N'airplanes' UNION ALL 
SELECT 6110, 850, 31, N'a' UNION ALL 
SELECT 6111, 850, 32, N'toe' UNION ALL 
SELECT 6112, 850, 33, N'toes' UNION ALL 
SELECT 6113, 851, 31, N'a' UNION ALL 
SELECT 6114, 851, 32, N'fingernail' UNION ALL 
SELECT 6115, 851, 33, N'fingernails' 
COMMIT;
SET IDENTITY_INSERT [dbo].[GrammarForms] OFF


GO


-- Funkcja sprawdzająca typ dla danego wyrazu
CREATE FUNCTION [dbo].[checkWordtypeForWord] (@WordId INT) 
RETURNS INT 
AS BEGIN

	DECLARE @MetawordId INT
	DECLARE @WordtypeId INT

	SET @MetawordId = (SELECT [w].[MetawordId] FROM [dbo].[Words] AS [w] WHERE [w].[Id] = @WordId)
	SET @WordtypeId = (SELECT [m].[Type] FROM [dbo].[Metawords] as [m] WHERE [m].[Id] = @MetawordId)

	RETURN @WordtypeId

END

GO



-- QUESTIONS


-- Pytania
CREATE TABLE [dbo].[Questions] (
      [Id]			INT           IDENTITY (1, 1) NOT NULL
    , [Name]			VARCHAR (255) NOT NULL UNIQUE
    , [Weight]			INT           DEFAULT ((0)) NOT NULL
    , [IsComplex]		BIT           DEFAULT ((1)) NOT NULL
    , [WordType]		INT           NULL
    , [AskPlural]		BIT           DEFAULT ((1)) NOT NULL
    , [IsActive]		BIT           DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT           DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME      DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT           DEFAULT ((0)) NOT NULL
    , [Positive]		INT           DEFAULT ((0)) NOT NULL
    , [Negative]		INT           DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [FK_Questions_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [FK_Questions_WordType] FOREIGN KEY ([WordType]) REFERENCES [dbo].[WordTypes] ([Id])
    , CONSTRAINT [FK_Questions_Check_Weight] CHECK ([Weight] > (0) AND [Weight] <= (10))
);
GO
SET IDENTITY_INSERT [dbo].[Questions] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[Questions] ([Id], [Name], [Weight], [IsComplex], [WordType], [AskPlural])
SELECT 1, N'Idę do domu', 10, 1, NULL, 0 UNION ALL 
SELECT 2, N'Polska', 10, 0, 1, 0 UNION ALL 
SELECT 3, N'pies', 10, 0, 1, 5 UNION ALL 
SELECT 4, N'Włochy', 10, 0, 1, 0 UNION ALL 
SELECT 5, N'Hiszpania', 10, 0, 1, 0 UNION ALL 
SELECT 6, N'Francja', 10, 0, 1, 0 UNION ALL 
SELECT 7, N'Niemcy', 10, 0, 1, 0 UNION ALL 
SELECT 8, N'Anglia', 10, 0, 1, 0 UNION ALL 
SELECT 9, N'Rosja', 10, 0, 1, 0 UNION ALL 
SELECT 10, N'Albania', 6, 0, 1, 0 UNION ALL 
SELECT 11, N'Andora', 2, 0, 1, 0 UNION ALL 
SELECT 12, N'Armenia', 5, 0, 1, 0 UNION ALL 
SELECT 13, N'Austria', 8, 0, 1, 0 UNION ALL 
SELECT 14, N'Azerbejdżan', 5, 0, 1, 0 UNION ALL 
SELECT 15, N'Białoruś', 5, 0, 1, 0 UNION ALL 
SELECT 16, N'Belgia', 8, 0, 1, 0 UNION ALL 
SELECT 17, N'Bośnia i Hercegowina', 5, 0, 1, 0 UNION ALL 
SELECT 18, N'Bułgaria', 7, 0, 1, 0 UNION ALL 
SELECT 19, N'Chorwacja', 7, 0, 1, 0 UNION ALL 
SELECT 20, N'Cypr', 6, 0, 1, 0 UNION ALL 
SELECT 21, N'Czechy', 9, 0, 1, 0 UNION ALL 
SELECT 22, N'Dania', 9, 0, 1, 0 UNION ALL 
SELECT 23, N'Estonia', 6, 0, 1, 0 UNION ALL 
SELECT 24, N'Finlandia', 8, 0, 1, 0 UNION ALL 
SELECT 25, N'Gruzja', 5, 0, 1, 0 UNION ALL 
SELECT 26, N'Grecja', 9, 0, 1, 0 UNION ALL 
SELECT 27, N'Węgry', 8, 0, 1, 0 UNION ALL 
SELECT 28, N'Islandia', 6, 0, 1, 0 UNION ALL 
SELECT 29, N'Irlandia', 7, 0, 1, 0 UNION ALL 
SELECT 30, N'Kazachstan', 5, 0, 1, 0 UNION ALL 
SELECT 31, N'Łotwa', 5, 0, 1, 0 UNION ALL 
SELECT 32, N'Liechtenstein', 2, 0, 1, 0 UNION ALL 
SELECT 33, N'Litwa', 6, 0, 1, 0 UNION ALL 
SELECT 34, N'Luksemburg', 6, 0, 1, 0 UNION ALL 
SELECT 35, N'Macedonia', 5, 0, 1, 0 UNION ALL 
SELECT 36, N'Malta', 6, 0, 1, 0 UNION ALL 
SELECT 37, N'Mołdawia', 4, 0, 1, 0 UNION ALL 
SELECT 38, N'Monako', 3, 0, 1, 0 UNION ALL 
SELECT 39, N'Czarnogóra', 6, 0, 1, 0 UNION ALL 
SELECT 40, N'Holandia', 10, 0, 1, 0 UNION ALL 
SELECT 41, N'Norwegia', 9, 0, 1, 0 UNION ALL 
SELECT 42, N'Portugalia', 9, 0, 1, 0 UNION ALL 
SELECT 43, N'Rumunia', 8, 0, 1, 0 UNION ALL 
SELECT 44, N'San Marino', 2, 0, 1, 0 UNION ALL 
SELECT 45, N'Serbia', 7, 0, 1, 0 UNION ALL 
SELECT 46, N'Słowacja', 7, 0, 1, 0 UNION ALL 
SELECT 47, N'Słowenia', 6, 0, 1, 0 UNION ALL 
SELECT 48, N'Szwecja', 9, 0, 1, 0 UNION ALL 
SELECT 49, N'Szwajcaria', 10, 0, 1, 0 UNION ALL 
SELECT 50, N'Turcja', 9, 0, 1, 0 UNION ALL 
SELECT 51, N'Ukraina', 9, 0, 1, 0 UNION ALL 
SELECT 52, N'Wielka Brytania', 9, 0, 1, 0 UNION ALL 
SELECT 53, N'Watykan', 2, 0, 1, 0 UNION ALL 
SELECT 54, N'Szkocja', 6, 0, 1, 0 UNION ALL 
SELECT 55, N'Brazylia', 10, 0, 1, 0 UNION ALL 
SELECT 56, N'Argentyna', 9, 0, 1, 0 UNION ALL 
SELECT 57, N'Peru', 6, 0, 1, 0 UNION ALL 
SELECT 58, N'Boliwia', 5, 0, 1, 0 UNION ALL 
SELECT 59, N'Chile', 6, 0, 1, 0 UNION ALL 
SELECT 60, N'Kolumbia', 8, 0, 1, 0 UNION ALL 
SELECT 61, N'Wenezuela', 7, 0, 1, 0 UNION ALL 
SELECT 62, N'Urugwaj', 6, 0, 1, 0 UNION ALL 
SELECT 63, N'Paragwaj', 6, 0, 1, 0 UNION ALL 
SELECT 64, N'Ekwador', 6, 0, 1, 0 UNION ALL 
SELECT 65, N'Chiny', 10, 0, 1, 0 UNION ALL 
SELECT 66, N'Japonia', 10, 0, 1, 0 UNION ALL 
SELECT 67, N'Indie', 10, 0, 1, 0 UNION ALL 
SELECT 68, N'Tajlandia', 9, 0, 1, 0 UNION ALL 
SELECT 69, N'Izrael', 8, 0, 1, 0 UNION ALL 
SELECT 70, N'Liban', 6, 0, 1, 0 UNION ALL 
SELECT 71, N'Jordania', 5, 0, 1, 0 UNION ALL 
SELECT 72, N'Syria', 6, 0, 1, 0 UNION ALL 
SELECT 73, N'Arabia Saudyjska', 8, 0, 1, 0 UNION ALL 
SELECT 74, N'Jemen', 5, 0, 1, 0 UNION ALL 
SELECT 75, N'Oman', 5, 0, 1, 0 UNION ALL 
SELECT 76, N'Zjednoczone Emiraty Arabskie', 8, 0, 1, 0 UNION ALL 
SELECT 77, N'Kuwejt', 8, 0, 1, 0 UNION ALL 
SELECT 78, N'Bahrajn', 5, 0, 1, 0 UNION ALL 
SELECT 79, N'Katar', 7, 0, 1, 0 UNION ALL 
SELECT 80, N'Irak', 9, 0, 1, 0 UNION ALL 
SELECT 81, N'Iran', 9, 0, 1, 0 UNION ALL 
SELECT 82, N'Afganistan', 8, 0, 1, 0 UNION ALL 
SELECT 83, N'Pakistan', 8, 0, 1, 0 UNION ALL 
SELECT 84, N'Uzbekistan', 6, 0, 1, 0 UNION ALL 
SELECT 85, N'Turkmenistan', 3, 0, 1, 0 UNION ALL 
SELECT 86, N'Tadżykistan', 2, 0, 1, 0 UNION ALL 
SELECT 87, N'Kirgistan', 2, 0, 1, 0 UNION ALL 
SELECT 88, N'Nepal', 5, 0, 1, 0 UNION ALL 
SELECT 89, N'Bhutan', 2, 0, 1, 0 UNION ALL 
SELECT 90, N'Bangladesz', 4, 0, 1, 0 UNION ALL 
SELECT 91, N'Sri Lanka', 4, 0, 1, 0 UNION ALL 
SELECT 92, N'Mongolia', 5, 0, 1, 0 UNION ALL 
SELECT 93, N'Laos', 3, 0, 1, 0 UNION ALL 
SELECT 94, N'Kambodża', 4, 0, 1, 0 UNION ALL 
SELECT 95, N'Wietnam', 6, 0, 1, 0 UNION ALL 
SELECT 96, N'Myanmar', 2, 0, 1, 0 UNION ALL 
SELECT 97, N'Korea Południowa', 10, 0, 1, 0 UNION ALL 
SELECT 98, N'Korea Północna', 9, 0, 1, 0 UNION ALL 
SELECT 99, N'Malezja', 7, 0, 1, 0 UNION ALL 
SELECT 100, N'Indonezja', 7, 0, 1, 0 UNION ALL 
SELECT 101, N'Filipiny', 7, 0, 1, 0 UNION ALL 
SELECT 102, N'Tajwan', 8, 0, 1, 0 UNION ALL 
SELECT 103, N'Hongkong', 8, 0, 1, 0 UNION ALL 
SELECT 104, N'Singapur', 7, 0, 1, 0 UNION ALL 
SELECT 105, N'Australia', 10, 0, 1, 0 UNION ALL 
SELECT 106, N'Nowa Zelandia', 10, 0, 1, 0 UNION ALL 
SELECT 107, N'Fidżi', 6, 0, 1, 0 UNION ALL 
SELECT 108, N'Egipt', 10, 0, 1, 0 UNION ALL 
SELECT 109, N'Libia', 8, 0, 1, 0 UNION ALL 
SELECT 110, N'Tunezja', 9, 0, 1, 0 UNION ALL 
SELECT 111, N'Maroko', 10, 0, 1, 0 UNION ALL 
SELECT 112, N'Algieria', 8, 0, 1, 0 UNION ALL 
SELECT 113, N'Sudan', 7, 0, 1, 0 UNION ALL 
SELECT 114, N'Etiopia', 8, 0, 1, 0 UNION ALL 
SELECT 115, N'Erytrea', 2, 0, 1, 0 UNION ALL 
SELECT 116, N'Dżibuti', 2, 0, 1, 0 UNION ALL 
SELECT 117, N'Czad', 2, 0, 1, 0 UNION ALL 
SELECT 118, N'Mauretania', 2, 0, 1, 0 UNION ALL 
SELECT 119, N'Burkina Faso', 3, 0, 1, 0 UNION ALL 
SELECT 120, N'Mali', 4, 0, 1, 0 UNION ALL 
SELECT 121, N'Senegal', 8, 0, 1, 0 UNION ALL 
SELECT 122, N'Gambia', 2, 0, 1, 0 UNION ALL 
SELECT 123, N'Gwinea', 3, 0, 1, 0 UNION ALL 
SELECT 124, N'Ghana', 5, 0, 1, 0 UNION ALL 
SELECT 125, N'Somalia', 7, 0, 1, 0 UNION ALL 
SELECT 126, N'Wybrzeże Kości Słoniowej', 6, 0, 1, 0 UNION ALL 
SELECT 127, N'Togo', 3, 0, 1, 0 UNION ALL 
SELECT 128, N'Liberia', 4, 0, 1, 0 UNION ALL 
SELECT 129, N'Sierra Leone', 3, 0, 1, 0 UNION ALL 
SELECT 130, N'Niger', 3, 0, 1, 0 UNION ALL 
SELECT 131, N'Nigeria', 9, 0, 1, 0 UNION ALL 
SELECT 132, N'Kamerun', 8, 0, 1, 0 UNION ALL 
SELECT 133, N'Gabon', 7, 0, 1, 0 UNION ALL 
SELECT 134, N'Kongo', 8, 0, 1, 0 UNION ALL 
SELECT 135, N'Demokratyczna Republika Konga', 3, 0, 1, 0 UNION ALL 
SELECT 136, N'Uganda', 4, 0, 1, 0 UNION ALL 
SELECT 137, N'Burundi', 1, 0, 1, 0 UNION ALL 
SELECT 138, N'Kenia', 8, 0, 1, 0 UNION ALL 
SELECT 139, N'Tanzania', 6, 0, 1, 0 UNION ALL 
SELECT 140, N'Mozambik', 5, 0, 1, 0 UNION ALL 
SELECT 141, N'Ruanda', 3, 0, 1, 0 UNION ALL 
SELECT 142, N'Madagaskar', 7, 0, 1, 0 UNION ALL 
SELECT 143, N'Angola', 5, 0, 1, 0 UNION ALL 
SELECT 144, N'Namibia', 3, 0, 1, 0 UNION ALL 
SELECT 145, N'RPA', 9, 0, 1, 0 UNION ALL 
SELECT 146, N'Zambia', 7, 0, 1, 0 UNION ALL 
SELECT 147, N'Zimbabwe', 7, 0, 1, 0 UNION ALL 
SELECT 148, N'Botswana', 2, 0, 1, 0 UNION ALL 
SELECT 149, N'Seszele', 7, 0, 1, 0 UNION ALL 
SELECT 150, N'Mauritius', 8, 0, 1, 0 UNION ALL 
SELECT 151, N'USA', 10, 0, 1, 0 UNION ALL 
SELECT 152, N'Kanada', 10, 0, 1, 0 UNION ALL 
SELECT 153, N'Meksyk', 10, 0, 1, 0 UNION ALL 
SELECT 154, N'Grenlandia', 8, 0, 1, 0 UNION ALL 
SELECT 155, N'Jamajka', 9, 0, 1, 0 UNION ALL 
SELECT 156, N'Kuba', 10, 0, 1, 0 UNION ALL 
SELECT 157, N'Honduras', 6, 0, 1, 0 UNION ALL 
SELECT 158, N'Salwador', 6, 0, 1, 0 UNION ALL 
SELECT 159, N'Gwatemala', 6, 0, 1, 0 UNION ALL 
SELECT 160, N'Nikaragua', 6, 0, 1, 0 UNION ALL 
SELECT 161, N'Panama', 7, 0, 1, 0 UNION ALL 
SELECT 162, N'Dominikana', 8, 0, 1, 0 UNION ALL 
SELECT 163, N'Haiti', 7, 0, 1, 0 UNION ALL 
SELECT 164, N'Portoryko', 7, 0, 1, 0 UNION ALL 
SELECT 165, N'Kostaryka', 7, 0, 1, 0 UNION ALL 
SELECT 166, N'Belize', 3, 0, 1, 0 UNION ALL 
SELECT 167, N'Bahamy', 5, 0, 1, 0 UNION ALL 
SELECT 168, N'Europa', 10, 0, 1, 0 UNION ALL 
SELECT 169, N'Ameryka Południowa', 10, 0, 1, 0 UNION ALL 
SELECT 170, N'Ameryka Północna', 10, 0, 1, 0 UNION ALL 
SELECT 171, N'Afryka', 10, 0, 1, 0 UNION ALL 
SELECT 172, N'Azja', 10, 0, 1, 0 UNION ALL 
SELECT 173, N'Oceania', 10, 0, 1, 0 UNION ALL 
SELECT 174, N'Skandynawia', 9, 0, 1, 0 UNION ALL 
SELECT 175, N'Kaukaz', 9, 0, 1, 0 UNION ALL 
SELECT 176, N'Karaiby', 9, 0, 1, 0 UNION ALL 
SELECT 177, N'kot', 10, 0, 1, 5 UNION ALL 
SELECT 178, N'chomik', 8, 0, 1, 5 UNION ALL 
SELECT 179, N'krowa', 9, 0, 1, 5 UNION ALL 
SELECT 180, N'koń', 10, 0, 1, 5 UNION ALL 
SELECT 181, N'mucha', 9, 0, 1, 5 UNION ALL 
SELECT 182, N'pszczoła', 9, 0, 1, 5 UNION ALL 
SELECT 183, N'osa', 7, 0, 1, 5 UNION ALL 
SELECT 184, N'komar', 8, 0, 1, 5 UNION ALL 
SELECT 185, N'żaba', 8, 0, 1, 5 UNION ALL 
SELECT 186, N'ptak', 10, 0, 1, 5 UNION ALL 
SELECT 187, N'ryba', 10, 0, 1, 5 UNION ALL 
SELECT 188, N'bocian', 7, 0, 1, 5 UNION ALL 
SELECT 189, N'wróbel', 6, 0, 1, 5 UNION ALL 
SELECT 190, N'motyl', 10, 0, 1, 5 UNION ALL 
SELECT 191, N'małpa', 10, 0, 1, 5 UNION ALL 
SELECT 192, N'słoń', 10, 0, 1, 5 UNION ALL 
SELECT 193, N'lew', 10, 0, 1, 5 UNION ALL 
SELECT 194, N'żyrafa', 10, 0, 1, 5 UNION ALL 
SELECT 195, N'wielbłąd', 10, 0, 1, 5 UNION ALL 
SELECT 196, N'tygrys', 10, 0, 1, 5 UNION ALL 
SELECT 197, N'wąż', 10, 0, 1, 5 UNION ALL 
SELECT 198, N'rekin', 9, 0, 1, 5 UNION ALL 
SELECT 199, N'wieloryb', 7, 0, 1, 5 UNION ALL 
SELECT 200, N'osioł', 8, 0, 1, 5 UNION ALL 
SELECT 201, N'owca', 9, 0, 1, 5 UNION ALL 
SELECT 202, N'gołąb', 7, 0, 1, 5 UNION ALL 
SELECT 203, N'sokół', 8, 0, 1, 5 UNION ALL 
SELECT 204, N'orzeł', 10, 0, 1, 5 UNION ALL 
SELECT 205, N'jastrząb', 8, 0, 1, 5 UNION ALL 
SELECT 206, N'Andy', 10, 0, 1, 0 UNION ALL 
SELECT 207, N'Himalaje', 10, 0, 1, 0 UNION ALL 
SELECT 208, N'Alpy', 10, 0, 1, 0 UNION ALL 
SELECT 209, N'Morze Śródziemne', 10, 0, 1, 0 UNION ALL 
SELECT 210, N'Ocean Atlantycki', 10, 0, 1, 0 UNION ALL 
SELECT 211, N'Ocean Spokojny', 10, 0, 1, 0 UNION ALL 
SELECT 212, N'Ocean Indyjski', 10, 0, 1, 0 UNION ALL 
SELECT 213, N'Zatoka Perska', 8, 0, 1, 0 UNION ALL 
SELECT 214, N'Morze Bałtyckie', 10, 0, 1, 0 UNION ALL 
SELECT 215, N'Sardynia', 10, 0, 1, 0 UNION ALL 
SELECT 216, N'Sycylia', 10, 0, 1, 0 UNION ALL 
SELECT 217, N'czarny', 10, 0, 1, 0 UNION ALL 
SELECT 218, N'biały', 10, 0, 1, 0 UNION ALL 
SELECT 219, N'zielony', 10, 0, 1, 0 UNION ALL 
SELECT 220, N'czerwony', 10, 0, 1, 0 UNION ALL 
SELECT 221, N'żółty', 10, 0, 1, 0 UNION ALL 
SELECT 222, N'brązowy', 10, 0, 1, 0 UNION ALL 
SELECT 223, N'niebieski', 10, 0, 1, 0 UNION ALL 
SELECT 224, N'różowy', 10, 0, 1, 0 UNION ALL 
SELECT 225, N'pomarańczowy', 10, 0, 1, 0 UNION ALL 
SELECT 226, N'szary', 10, 0, 1, 0 UNION ALL 
SELECT 227, N'poniedziałek', 10, 0, 1, 2 UNION ALL 
SELECT 228, N'wtorek', 10, 0, 1, 2 UNION ALL 
SELECT 229, N'środa', 10, 0, 1, 2 UNION ALL 
SELECT 230, N'czwartek', 10, 0, 1, 2 UNION ALL 
SELECT 231, N'piątek', 10, 0, 1, 2 UNION ALL 
SELECT 232, N'sobota', 10, 0, 1, 2 UNION ALL 
SELECT 233, N'niedziela', 10, 0, 1, 2 UNION ALL 
SELECT 234, N'styczeń', 10, 0, 1, 1 UNION ALL 
SELECT 235, N'luty', 10, 0, 1, 1 UNION ALL 
SELECT 236, N'marzec', 10, 0, 1, 1 UNION ALL 
SELECT 237, N'kwiecień', 10, 0, 1, 1 UNION ALL 
SELECT 238, N'maj', 10, 0, 1, 1 UNION ALL 
SELECT 239, N'czerwiec', 10, 0, 1, 1 UNION ALL 
SELECT 240, N'lipiec', 10, 0, 1, 1 UNION ALL 
SELECT 241, N'sierpień', 10, 0, 1, 1 UNION ALL 
SELECT 242, N'wrzesień', 10, 0, 1, 1 UNION ALL 
SELECT 243, N'październik', 10, 0, 1, 1 UNION ALL 
SELECT 244, N'listopad', 10, 0, 1, 1 UNION ALL 
SELECT 245, N'grudzień', 10, 0, 1, 1 UNION ALL 
SELECT 246, N'rok', 10, 0, 1, 10 UNION ALL 
SELECT 247, N'miesiąc', 10, 0, 1, 10 UNION ALL 
SELECT 248, N'dzień', 10, 0, 1, 10 UNION ALL 
SELECT 249, N'tydzień', 10, 0, 1, 10 UNION ALL 
SELECT 250, N'godzina', 10, 0, 1, 10 UNION ALL 
SELECT 251, N'minuta', 10, 0, 1, 10 UNION ALL 
SELECT 252, N'sekunda', 10, 0, 1, 10 UNION ALL 
SELECT 253, N'weekend', 8, 0, 1, 5 UNION ALL 
SELECT 254, N'jutro', 10, 0, 1, 0 UNION ALL 
SELECT 255, N'dzisiaj', 10, 0, 1, 0 UNION ALL 
SELECT 256, N'wczoraj', 10, 0, 1, 0 UNION ALL 
SELECT 257, N'żółw', 10, 0, 1, 5 UNION ALL 
SELECT 258, N'krokodyl', 8, 0, 1, 5 UNION ALL 
SELECT 259, N'kangur', 8, 0, 1, 5 UNION ALL 
SELECT 260, N'gad', 9, 0, 1, 5 UNION ALL 
SELECT 261, N'płaz', 9, 0, 1, 5 UNION ALL 
SELECT 262, N'ssak', 9, 0, 1, 5 UNION ALL 
SELECT 263, N'robak', 10, 0, 1, 5 UNION ALL 
SELECT 264, N'owad', 10, 0, 1, 5 UNION ALL 
SELECT 265, N'jabłko', 10, 0, 1, 5 UNION ALL 
SELECT 266, N'gruszka', 10, 0, 1, 5 UNION ALL 
SELECT 267, N'wiśnia', 10, 0, 1, 5 UNION ALL 
SELECT 268, N'truskawka', 10, 0, 1, 5 UNION ALL 
SELECT 269, N'ananas', 9, 0, 1, 5 UNION ALL 
SELECT 270, N'pomarańcza', 10, 0, 1, 5 UNION ALL 
SELECT 271, N'czereśnia', 7, 0, 1, 5 UNION ALL 
SELECT 272, N'porzeczka', 7, 0, 1, 5 UNION ALL 
SELECT 273, N'malina', 9, 0, 1, 5 UNION ALL 
SELECT 274, N'banan', 10, 0, 1, 5 UNION ALL 
SELECT 275, N'robić', 10, 0, 2, 0 UNION ALL 
SELECT 276, N'polski', 10, 0, 1, 0 UNION ALL 
SELECT 277, N'ręka', 10, 0, 1, 5 UNION ALL 
SELECT 278, N'płacić', 10, 0, 2, 0 UNION ALL 
SELECT 279, N'szybki', 10, 0, 3, 0 UNION ALL 
SELECT 280, N'mówić', 10, 0, 2, 0 UNION ALL 
SELECT 281, N'czytać', 10, 0, 2, 0 UNION ALL 
SELECT 282, N'zdobywać', 10, 0, 2, 0 UNION ALL 
SELECT 283, N'próbować', 10, 0, 2, 0 UNION ALL 
SELECT 284, N'książka', 10, 0, 1, 5 UNION ALL 
SELECT 285, N'gra', 10, 0, 1, 5 UNION ALL 
SELECT 286, N'produkt', 10, 0, 1, 5 UNION ALL 
SELECT 287, N'samochód', 10, 0, 1, 5 UNION ALL 
SELECT 288, N'oprogramowanie', 1, 0, 1, 0 UNION ALL 
SELECT 289, N'gubić', 10, 0, 2, 0 UNION ALL 
SELECT 290, N'golić się', 8, 0, 2, 0 UNION ALL 
SELECT 291, N'spóźnić się', 9, 0, 2, 0 UNION ALL 
SELECT 292, N'dowiadywać się', 9, 0, 2, 0 UNION ALL 
SELECT 293, N'przeziębić się', 7, 0, 2, 0 UNION ALL 
SELECT 294, N'odkręcać', 8, 0, 2, 0 UNION ALL 
SELECT 295, N'zawiązywać', 8, 0, 2, 0 UNION ALL 
SELECT 296, N'nazywać się', 8, 0, 2, 0 UNION ALL 
SELECT 297, N'mieć', 10, 0, 2, 0 UNION ALL 
SELECT 298, N'musieć', 10, 0, 2, 0 UNION ALL 
SELECT 299, N'zauważyć', 10, 0, 2, 0 UNION ALL 
SELECT 300, N'gadać', 10, 0, 2, 0 UNION ALL 
SELECT 301, N'odzyskiwać', 10, 0, 2, 0 UNION ALL 
SELECT 302, N'chcieć', 10, 0, 2, 0 UNION ALL 
SELECT 303, N'dotykać', 10, 0, 2, 0 UNION ALL 
SELECT 304, N'telewizja', 10, 0, 1, 0 UNION ALL 
SELECT 305, N'internet', 10, 0, 1, 0 UNION ALL 
SELECT 306, N'prasa', 10, 0, 1, 0 UNION ALL 
SELECT 307, N'szukać', 10, 0, 2, 0 UNION ALL 
SELECT 308, N'spać', 10, 0, 2, 0 UNION ALL 
SELECT 309, N'rozpoznawać', 10, 0, 2, 0 UNION ALL 
SELECT 310, N'hotel', 10, 0, 1, 5 UNION ALL 
SELECT 311, N'prąd', 10, 0, 1, 0 UNION ALL 
SELECT 312, N'telefon', 10, 0, 1, 5 UNION ALL 
SELECT 313, N'ogrzewanie', 8, 0, 1, 0 UNION ALL 
SELECT 314, N'woda', 10, 0, 1, 0 UNION ALL 
SELECT 315, N'gaz', 10, 0, 1, 0 UNION ALL 
SELECT 316, N'samolot', 10, 0, 1, 5 UNION ALL 
SELECT 317, N'pociąg', 10, 0, 1, 5 UNION ALL 
SELECT 318, N'autobus', 10, 0, 1, 5 UNION ALL 
SELECT 319, N'lekcja', 10, 0, 1, 5 UNION ALL 
SELECT 320, N'dostawać', 10, 0, 2, 0 UNION ALL 
SELECT 321, N'pracować', 10, 0, 2, 0 UNION ALL 
SELECT 322, N'słuchać', 10, 0, 2, 0 UNION ALL 
SELECT 323, N'jeździć', 10, 0, 2, 0 UNION ALL 
SELECT 324, N'mieszkać', 10, 0, 2, 0 UNION ALL 
SELECT 325, N'parkować', 8, 0, 2, 0 UNION ALL 
SELECT 326, N'zarabiać', 10, 0, 2, 0 UNION ALL 
SELECT 327, N'biegać', 10, 0, 2, 0 UNION ALL 
SELECT 328, N'dotrzeć', 10, 0, 2, 0 UNION ALL 
SELECT 329, N'wyławiać (z wody)', 8, 0, 2, 0 UNION ALL 
SELECT 330, N'dawać', 10, 0, 2, 0 UNION ALL 
SELECT 331, N'wyglądać', 10, 0, 2, 0 UNION ALL 
SELECT 332, N'morze', 10, 0, 1, 5 UNION ALL 
SELECT 333, N'jezioro', 10, 0, 1, 5 UNION ALL 
SELECT 334, N'plaża', 10, 0, 1, 5 UNION ALL 
SELECT 335, N'sam', 10, 0, 5, 0 UNION ALL 
SELECT 336, N'słyszeć', 10, 0, 2, 0 UNION ALL 
SELECT 337, N'czuć', 10, 0, 2, 0 UNION ALL 
SELECT 338, N'oczekiwać', 10, 0, 2, 0 UNION ALL 
SELECT 339, N'informować', 10, 0, 2, 0 UNION ALL 
SELECT 340, N'uczyć się', 10, 0, 2, 0 UNION ALL 
SELECT 341, N'angielski', 10, 0, 1, 0 UNION ALL 
SELECT 342, N'hiszpański', 10, 0, 1, 0 UNION ALL 
SELECT 343, N'francuski', 10, 0, 1, 0 UNION ALL 
SELECT 344, N'rosyjski', 10, 0, 1, 0 UNION ALL 
SELECT 345, N'włoski', 10, 0, 1, 0 UNION ALL 
SELECT 346, N'portugalski', 10, 0, 1, 0 UNION ALL 
SELECT 347, N'arabski', 10, 0, 1, 0 UNION ALL 
SELECT 348, N'japoński', 10, 0, 1, 0 UNION ALL 
SELECT 349, N'chiński', 10, 0, 1, 0 UNION ALL 
SELECT 350, N'czeski', 7, 0, 1, 0 UNION ALL 
SELECT 351, N'reagować', 10, 0, 2, 0 UNION ALL 
SELECT 352, N'płakać', 10, 0, 2, 0 UNION ALL 
SELECT 353, N'myśleć', 10, 0, 2, 0 UNION ALL 
SELECT 354, N'zachowywać się', 10, 0, 2, 0 UNION ALL 
SELECT 355, N'ładny', 10, 0, 3, 0 UNION ALL 
SELECT 356, N'gruziński', 7, 0, 1, 0 UNION ALL 
SELECT 357, N'koreański', 8, 0, 1, 0 UNION ALL 
SELECT 358, N'wietnamski', 7, 0, 1, 0 UNION ALL 
SELECT 359, N'grecki', 8, 0, 1, 0 UNION ALL 
SELECT 360, N'bułgarski', 7, 0, 1, 0 UNION ALL 
SELECT 361, N'albański', 6, 0, 1, 0 UNION ALL 
SELECT 362, N'chorwacki', 8, 0, 1, 0 UNION ALL 
SELECT 363, N'szwajcarski', 10, 0, 1, 0 UNION ALL 
SELECT 364, N'austriacki', 8, 0, 1, 0 UNION ALL 
SELECT 365, N'australijski', 10, 0, 1, 0 UNION ALL 
SELECT 366, N'meksykański', 9, 0, 1, 0 UNION ALL 
SELECT 367, N'brazylijski', 10, 0, 1, 0 UNION ALL 
SELECT 368, N'argentyński', 8, 0, 1, 0 UNION ALL 
SELECT 369, N'kolumbijski', 6, 0, 1, 0 UNION ALL 
SELECT 370, N'kanadyjski', 10, 0, 1, 0 UNION ALL 
SELECT 371, N'amerykański', 10, 0, 1, 0 UNION ALL 
SELECT 372, N'irlandzki', 6, 0, 1, 0 UNION ALL 
SELECT 373, N'szkocki', 4, 0, 1, 0 UNION ALL 
SELECT 374, N'walijski', 4, 0, 1, 0 UNION ALL 
SELECT 375, N'islandzki', 5, 0, 1, 0 UNION ALL 
SELECT 376, N'duński', 8, 0, 1, 0 UNION ALL 
SELECT 377, N'norweski', 7, 0, 1, 0 UNION ALL 
SELECT 378, N'szwedzki', 9, 0, 1, 0 UNION ALL 
SELECT 379, N'fiński', 8, 0, 1, 0 UNION ALL 
SELECT 380, N'estoński', 4, 0, 1, 0 UNION ALL 
SELECT 381, N'łotewski', 4, 0, 1, 0 UNION ALL 
SELECT 382, N'litewski', 5, 0, 1, 0 UNION ALL 
SELECT 383, N'holenderski', 10, 0, 1, 0 UNION ALL 
SELECT 384, N'belgijski', 8, 0, 1, 0 UNION ALL 
SELECT 385, N'słowacki', 6, 0, 1, 0 UNION ALL 
SELECT 386, N'węgierski', 7, 0, 1, 0 UNION ALL 
SELECT 387, N'rumuński', 7, 0, 1, 0 UNION ALL 
SELECT 388, N'serbski', 7, 0, 1, 0 UNION ALL 
SELECT 389, N'macedoński', 4, 0, 1, 0 UNION ALL 
SELECT 390, N'bośniacki', 4, 0, 1, 0 UNION ALL 
SELECT 391, N'słoweński', 4, 0, 1, 0 UNION ALL 
SELECT 392, N'czarnogórski', 5, 0, 1, 0 UNION ALL 
SELECT 393, N'białoruski', 5, 0, 1, 0 UNION ALL 
SELECT 394, N'ukraiński', 8, 0, 1, 0 UNION ALL 
SELECT 395, N'mołdawski', 4, 0, 1, 0 UNION ALL 
SELECT 396, N'peruwiański', 7, 0, 1, 0 UNION ALL 
SELECT 397, N'chilijski', 7, 0, 1, 0 UNION ALL 
SELECT 398, N'wenezuelski', 7, 0, 1, 0 UNION ALL 
SELECT 399, N'urugwajski', 6, 0, 1, 0 UNION ALL 
SELECT 400, N'paragwajski', 7, 0, 1, 0 UNION ALL 
SELECT 401, N'ekwadorski', 5, 0, 1, 0 UNION ALL 
SELECT 402, N'boliwijski', 5, 0, 1, 0 UNION ALL 
SELECT 403, N'surinamski', 2, 0, 1, 0 UNION ALL 
SELECT 404, N'gujański', 2, 0, 1, 0 UNION ALL 
SELECT 405, N'ormiański', 6, 0, 1, 0 UNION ALL 
SELECT 406, N'azerbejdżański', 5, 0, 1, 0 UNION ALL 
SELECT 407, N'turecki', 8, 0, 1, 0 UNION ALL 
SELECT 408, N'jamajski', 5, 0, 1, 0 UNION ALL 
SELECT 409, N'grenlandzki', 5, 0, 1, 0 UNION ALL 
SELECT 410, N'algierski', 5, 0, 1, 0 UNION ALL 
SELECT 411, N'marokański', 6, 0, 1, 0 UNION ALL 
SELECT 412, N'etiopski', 5, 0, 1, 0 UNION ALL 
SELECT 413, N'kenijski', 5, 0, 1, 0 UNION ALL 
SELECT 414, N'malgaski', 4, 0, 1, 0 UNION ALL 
SELECT 415, N'somalijski', 4, 0, 1, 0 UNION ALL 
SELECT 416, N'angolski', 3, 0, 1, 0 UNION ALL 
SELECT 417, N'kameruński', 3, 0, 1, 0 UNION ALL 
SELECT 418, N'gaboński', 2, 0, 1, 0 UNION ALL 
SELECT 419, N'egipski', 6, 0, 1, 0 UNION ALL 
SELECT 420, N'libijski', 5, 0, 1, 0 UNION ALL 
SELECT 421, N'sudański', 3, 0, 1, 0 UNION ALL 
SELECT 422, N'tunezyjski', 5, 0, 1, 0 UNION ALL 
SELECT 423, N'południowoafrykański', 6, 0, 1, 0 UNION ALL 
SELECT 424, N'senegalski', 4, 0, 1, 0 UNION ALL 
SELECT 425, N'nigeryjski', 6, 0, 1, 0 UNION ALL 
SELECT 426, N'nowozelandzki', 7, 0, 1, 0 UNION ALL 
SELECT 427, N'wstawać', 10, 0, 2, 0 UNION ALL 
SELECT 428, N'irański', 6, 0, 1, 0 UNION ALL 
SELECT 429, N'perski', 6, 0, 1, 0 UNION ALL 
SELECT 430, N'iracki', 6, 0, 1, 0 UNION ALL 
SELECT 431, N'pakistański', 7, 0, 1, 0 UNION ALL 
SELECT 432, N'syryjski', 4, 0, 1, 0 UNION ALL 
SELECT 433, N'hinduski', 8, 0, 1, 0 UNION ALL 
SELECT 434, N'libański', 5, 0, 1, 0 UNION ALL 
SELECT 435, N'tajski', 7, 0, 1, 0 UNION ALL 
SELECT 436, N'mongolski', 5, 0, 1, 0 UNION ALL 
SELECT 437, N'twierdzić', 10, 0, 2, 0 UNION ALL 
SELECT 438, N'zamierzać', 10, 0, 2, 0 UNION ALL 
SELECT 439, N'przeżyć, przetrwać', 10, 0, 2, 0 UNION ALL 
SELECT 440, N'rodzić się', 10, 0, 2, 0 UNION ALL 
SELECT 441, N'jeden', 10, 0, 4, 0 UNION ALL 
SELECT 442, N'dwa', 10, 0, 4, 0 UNION ALL 
SELECT 443, N'trzy', 10, 0, 4, 0 UNION ALL 
SELECT 444, N'cztery', 10, 0, 4, 0 UNION ALL 
SELECT 445, N'pięć', 10, 0, 4, 0 UNION ALL 
SELECT 446, N'sześć', 10, 0, 4, 0 UNION ALL 
SELECT 447, N'szpital', 10, 0, 1, 5 UNION ALL 
SELECT 448, N'szkoła', 10, 0, 1, 5 UNION ALL 
SELECT 449, N'poczta', 10, 0, 1, 5 UNION ALL 
SELECT 450, N'policja', 8, 0, 1, 0 UNION ALL 
SELECT 451, N'wygrywać', 10, 0, 2, 0 UNION ALL 
SELECT 452, N'Oscar', 8, 0, 1, 5 UNION ALL 
SELECT 453, N'Nagroda Nobla', 9, 0, 1, 5 UNION ALL 
SELECT 454, N'strażak', 10, 0, 1, 5 UNION ALL 
SELECT 455, N'lekarz', 9, 0, 1, 5 UNION ALL 
SELECT 456, N'policjant', 9, 0, 1, 5 UNION ALL 
SELECT 457, N'nauczyciel', 9, 0, 1, 5 UNION ALL 
SELECT 458, N'taksówkarz', 9, 0, 1, 5 UNION ALL 
SELECT 459, N'kierowca', 9, 0, 1, 5 UNION ALL 
SELECT 460, N'mieszkanie', 10, 0, 1, 5 UNION ALL 
SELECT 461, N'pokój', 10, 0, 1, 5 UNION ALL 
SELECT 462, N'drzwi', 10, 0, 1, 5 UNION ALL 
SELECT 463, N'okno', 10, 0, 1, 5 UNION ALL 
SELECT 464, N'jeść', 10, 0, 2, 0 UNION ALL 
SELECT 465, N'śniadanie', 10, 0, 1, 0 UNION ALL 
SELECT 466, N'obiad', 10, 0, 1, 3 UNION ALL 
SELECT 467, N'żyć', 10, 0, 2, 0 UNION ALL 
SELECT 468, N'zaczynać się', 10, 0, 2, 0 UNION ALL 
SELECT 469, N'tracić', 10, 0, 2, 0 UNION ALL 
SELECT 470, N'wiedzieć', 10, 0, 2, 0 UNION ALL 
SELECT 471, N'stresować się', 7, 0, 2, 0 UNION ALL 
SELECT 472, N'głosować', 8, 0, 2, 0 UNION ALL 
SELECT 473, N'ten', 10, 0, 5, 0 UNION ALL 
SELECT 474, N'dom', 10, 0, 1, 5 UNION ALL 
SELECT 475, N'brzeg (jeziora, morza)', 9, 0, 1, 5 UNION ALL 
SELECT 476, N'ukrywać', 10, 0, 2, 0 UNION ALL 
SELECT 477, N'iść', 10, 0, 2, 0 UNION ALL 
SELECT 478, N'siedzieć', 10, 0, 2, 0 UNION ALL 
SELECT 479, N'brać', 10, 0, 2, 0 UNION ALL 
SELECT 480, N'śmiać się', 10, 0, 2, 0 UNION ALL 
SELECT 481, N'las', 10, 0, 1, 5 UNION ALL 
SELECT 482, N'lotnisko', 10, 0, 1, 5 UNION ALL 
SELECT 483, N'rzeka', 10, 0, 1, 5 UNION ALL 
SELECT 484, N'taksówka', 10, 0, 1, 5 UNION ALL 
SELECT 485, N'powstrzymywać', 10, 0, 2, 0 UNION ALL 
SELECT 486, N'prosić', 10, 0, 2, 0 UNION ALL 
SELECT 487, N'uznawać', 9, 0, 2, 0 UNION ALL 
SELECT 488, N'budzić się', 10, 0, 2, 0 UNION ALL 
SELECT 489, N'grozić', 10, 0, 2, 0 UNION ALL 
SELECT 490, N'wywiad', 9, 0, 1, 5 UNION ALL 
SELECT 491, N'spotkanie', 9, 0, 1, 5 UNION ALL 
SELECT 492, N'debata', 9, 0, 1, 5 UNION ALL 
SELECT 493, N'widzieć', 10, 0, 2, 0 UNION ALL 
SELECT 494, N'znajdować', 10, 0, 2, 0 UNION ALL 
SELECT 495, N'portfel', 9, 0, 1, 5 UNION ALL 
SELECT 496, N'klucz', 10, 0, 1, 5 UNION ALL 
SELECT 497, N'karta kredytowa', 8, 0, 1, 5 UNION ALL 
SELECT 498, N'lot', 9, 0, 1, 5 UNION ALL 
SELECT 499, N'prezent', 10, 0, 1, 5 UNION ALL 
SELECT 500, N'odpowiedź', 10, 0, 1, 5 UNION ALL 
SELECT 501, N'to', 10, 0, 5, 0 UNION ALL 
SELECT 502, N'komputer', 10, 0, 1, 5 UNION ALL 
SELECT 503, N'przypuszczać', 8, 0, 2, 0 UNION ALL 
SELECT 504, N'gazeta', 10, 0, 1, 5 UNION ALL 
SELECT 505, N'dokument', 9, 0, 1, 5 UNION ALL 
SELECT 506, N'wiersz', 8, 0, 1, 5 UNION ALL 
SELECT 507, N'pisać', 10, 0, 2, 0 UNION ALL 
SELECT 508, N'stół', 10, 0, 1, 5 UNION ALL 
SELECT 509, N'krzesło', 10, 0, 1, 5 UNION ALL 
SELECT 510, N'podłoga', 10, 0, 1, 5 UNION ALL 
SELECT 511, N'łóżko', 10, 0, 1, 5 UNION ALL 
SELECT 512, N'kontaktować się', 8, 0, 2, 0 UNION ALL 
SELECT 513, N'spotykać', 10, 0, 2, 0 UNION ALL 
SELECT 514, N'uderzać', 10, 0, 2, 0 UNION ALL 
SELECT 515, N'czekać', 10, 0, 2, 0 UNION ALL 
SELECT 516, N'znać', 10, 0, 2, 0 UNION ALL 
SELECT 517, N'wyjeżdżać', 10, 0, 2, 0 UNION ALL 
SELECT 518, N'rozmawiać', 8, 0, 2, 0 UNION ALL 
SELECT 519, N'nosić (ubrania)', 9, 0, 2, 0 UNION ALL 
SELECT 520, N'brakować', 9, 0, 2, 0 UNION ALL 
SELECT 521, N'jakiś', 10, 0, 5, 0 UNION ALL 
SELECT 522, N'zbrodnia', 9, 0, 1, 5 UNION ALL 
SELECT 523, N'przestępstwo', 10, 0, 1, 5 UNION ALL 
SELECT 524, N'groźba', 10, 0, 1, 5 UNION ALL 
SELECT 525, N'żart', 10, 0, 1, 5 UNION ALL 
SELECT 526, N'koncert', 9, 0, 1, 5 UNION ALL 
SELECT 527, N'Średniowiecze', 9, 0, 1, 0 UNION ALL 
SELECT 528, N'wojna domowa', 8, 0, 1, 5 UNION ALL 
SELECT 529, N'finał', 9, 0, 1, 5 UNION ALL 
SELECT 530, N'tamten', 10, 0, 5, 0 UNION ALL 
SELECT 531, N'życie', 10, 0, 1, 5 UNION ALL 
SELECT 532, N'przybywać', 8, 0, 2, 0 UNION ALL 
SELECT 533, N'skorpion', 8, 0, 1, 5 UNION ALL 
SELECT 534, N'płaszczka', 7, 0, 1, 5 UNION ALL 
SELECT 535, N'meduza', 8, 0, 1, 5 UNION ALL 
SELECT 536, N'szerszeń', 8, 0, 1, 5 UNION ALL 
SELECT 537, N'kleszcz', 8, 0, 1, 5 UNION ALL 
SELECT 538, N'grzechotnik', 6, 0, 1, 5 UNION ALL 
SELECT 539, N'żmija', 9, 0, 1, 5 UNION ALL 
SELECT 540, N'dowód', 10, 0, 1, 5 UNION ALL 
SELECT 541, N'dane', 9, 0, 1, 0 UNION ALL 
SELECT 542, N'statystyka', 9, 0, 1, 5 UNION ALL 
SELECT 543, N'siedem', 10, 0, 4, 0 UNION ALL 
SELECT 544, N'osiem', 10, 0, 4, 0 UNION ALL 
SELECT 545, N'skóra', 10, 0, 1, 5 UNION ALL 
SELECT 546, N'miejsce', 10, 0, 1, 5 UNION ALL 
SELECT 547, N'wierzyć', 10, 0, 2, 0 UNION ALL 
SELECT 548, N'potrzebować', 10, 0, 2, 0 UNION ALL 
SELECT 549, N'lubić', 10, 0, 2, 0 UNION ALL 
SELECT 550, N'jedyny', 10, 0, 3, 0 UNION ALL 
SELECT 551, N'ujęcie (zdjęcia)', 8, 0, 1, 5 UNION ALL 
SELECT 552, N'wyjaśnienie', 10, 0, 1, 5 UNION ALL 
SELECT 553, N'powód', 10, 0, 1, 5 UNION ALL 
SELECT 554, N'szansa', 10, 0, 1, 5 UNION ALL 
SELECT 555, N'osoba', 10, 0, 1, 5 UNION ALL 
SELECT 556, N'pytanie', 10, 0, 1, 5 UNION ALL 
SELECT 557, N'wymóg', 9, 0, 1, 5 UNION ALL 
SELECT 558, N'różnica', 10, 0, 1, 5 UNION ALL 
SELECT 559, N'problem', 10, 0, 1, 5 UNION ALL 
SELECT 560, N'wybór', 10, 0, 1, 0 UNION ALL 
SELECT 561, N'mapa', 10, 0, 1, 5 UNION ALL 
SELECT 562, N'wykres', 10, 0, 1, 5 UNION ALL 
SELECT 563, N'założenie', 9, 0, 1, 5 UNION ALL 
SELECT 564, N'wynik (gry, meczu)', 9, 0, 1, 5 UNION ALL 
SELECT 565, N'wynik (badania, pomiaru)', 10, 0, 1, 5 UNION ALL 
SELECT 566, N'zdjęcie', 10, 0, 1, 5 UNION ALL 
SELECT 567, N'młotek', 9, 0, 1, 5 UNION ALL 
SELECT 568, N'lina', 9, 0, 1, 5 UNION ALL 
SELECT 569, N'odwaga', 10, 0, 1, 0 UNION ALL 
SELECT 570, N'przyjaciel', 9, 0, 1, 5 UNION ALL 
SELECT 571, N'zabierać', 7, 0, 2, 0 UNION ALL 
SELECT 572, N'region', 9, 0, 1, 5 UNION ALL 
SELECT 573, N'miasto', 10, 0, 1, 5 UNION ALL 
SELECT 574, N'głowa', 10, 0, 1, 5 UNION ALL 
SELECT 575, N'noga', 10, 0, 1, 5 UNION ALL 
SELECT 576, N'brzuch', 10, 0, 1, 5 UNION ALL 
SELECT 577, N'włos', 10, 0, 1, 5 UNION ALL 
SELECT 578, N'oko', 10, 0, 1, 5 UNION ALL 
SELECT 579, N'ucho', 10, 0, 1, 0 UNION ALL 
SELECT 580, N'nos', 10, 0, 1, 5 UNION ALL 
SELECT 581, N'paznokieć', 7, 0, 1, 5 UNION ALL 
SELECT 582, N'palec (od ręki)', 9, 0, 1, 5 UNION ALL 
SELECT 583, N'ramię', 9, 0, 1, 5 UNION ALL 
SELECT 584, N'szyja', 9, 0, 1, 5 UNION ALL 
SELECT 585, N'usta', 10, 0, 1, 5 UNION ALL 
SELECT 586, N'ząb', 10, 0, 1, 5 UNION ALL 
SELECT 587, N'język', 10, 0, 1, 5 UNION ALL 
SELECT 588, N'serce', 10, 0, 1, 5 UNION ALL 
SELECT 589, N'wątroba', 8, 0, 1, 5 UNION ALL 
SELECT 590, N'żołądek', 7, 0, 1, 5 UNION ALL 
SELECT 591, N'kolano', 7, 0, 1, 5 UNION ALL 
SELECT 592, N'łokieć', 7, 0, 1, 5 UNION ALL 
SELECT 593, N'stopa', 8, 0, 1, 5 UNION ALL 
SELECT 594, N'pięta', 7, 0, 1, 5 UNION ALL 
SELECT 595, N'policzek', 8, 0, 1, 5 UNION ALL 
SELECT 596, N'brew', 6, 0, 1, 5 UNION ALL 
SELECT 597, N'rzęsa', 6, 0, 1, 5 UNION ALL 
SELECT 598, N'powieka', 6, 0, 1, 5 UNION ALL 
SELECT 599, N'czoło', 8, 0, 1, 5 UNION ALL 
SELECT 600, N'kręgosłup', 8, 0, 1, 5 UNION ALL 
SELECT 601, N'płuco', 8, 0, 1, 5 UNION ALL 
SELECT 602, N'żyła', 9, 0, 1, 5 UNION ALL 
SELECT 603, N'krew', 10, 0, 1, 0 UNION ALL 
SELECT 604, N'gardło', 9, 0, 1, 5 UNION ALL 
SELECT 605, N'mózg', 10, 0, 1, 5 UNION ALL 
SELECT 606, N'mysz', 10, 0, 1, 5 UNION ALL 
SELECT 607, N'szczur', 10, 0, 1, 5 UNION ALL 
SELECT 608, N'Bałkany', 10, 0, 1, 0 UNION ALL 
SELECT 609, N'palec (od nogi)', 9, 0, 1, 5 UNION ALL 
SELECT 610, N'tamto', 10, 0, 5, 0 
COMMIT;
SET IDENTITY_INSERT [dbo].[Questions] OFF

GO

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
GO
SET IDENTITY_INSERT [dbo].[MatchQuestionCategory] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[MatchQuestionCategory]([Id], [QuestionId], [CategoryId])
SELECT 1, 2, 4 UNION ALL 
SELECT 2, 3, 18 UNION ALL 
SELECT 3, 4, 4 UNION ALL 
SELECT 4, 5, 4 UNION ALL 
SELECT 5, 6, 4 UNION ALL 
SELECT 6, 7, 4 UNION ALL 
SELECT 7, 8, 4 UNION ALL 
SELECT 8, 9, 8 UNION ALL 
SELECT 9, 10, 4 UNION ALL 
SELECT 10, 11, 4 UNION ALL 
SELECT 11, 12, 4 UNION ALL 
SELECT 12, 12, 8 UNION ALL 
SELECT 13, 13, 4 UNION ALL 
SELECT 14, 14, 4 UNION ALL 
SELECT 15, 14, 8 UNION ALL 
SELECT 16, 15, 4 UNION ALL 
SELECT 17, 16, 4 UNION ALL 
SELECT 18, 17, 4 UNION ALL 
SELECT 19, 18, 4 UNION ALL 
SELECT 20, 19, 4 UNION ALL 
SELECT 21, 20, 4 UNION ALL 
SELECT 22, 20, 42 UNION ALL 
SELECT 23, 21, 4 UNION ALL 
SELECT 24, 22, 4 UNION ALL 
SELECT 25, 23, 4 UNION ALL 
SELECT 26, 24, 4 UNION ALL 
SELECT 27, 25, 4 UNION ALL 
SELECT 28, 26, 4 UNION ALL 
SELECT 29, 27, 4 UNION ALL 
SELECT 30, 28, 4 UNION ALL 
SELECT 31, 28, 42 UNION ALL 
SELECT 32, 29, 4 UNION ALL 
SELECT 33, 29, 42 UNION ALL 
SELECT 34, 30, 4 UNION ALL 
SELECT 35, 31, 4 UNION ALL 
SELECT 36, 32, 4 UNION ALL 
SELECT 37, 33, 4 UNION ALL 
SELECT 38, 34, 4 UNION ALL 
SELECT 39, 35, 4 UNION ALL 
SELECT 40, 36, 4 UNION ALL 
SELECT 41, 36, 42 UNION ALL 
SELECT 42, 37, 4 UNION ALL 
SELECT 43, 38, 4 UNION ALL 
SELECT 44, 39, 4 UNION ALL 
SELECT 45, 40, 4 UNION ALL 
SELECT 46, 41, 4 UNION ALL 
SELECT 47, 42, 4 UNION ALL 
SELECT 48, 43, 4 UNION ALL 
SELECT 49, 44, 4 UNION ALL 
SELECT 50, 45, 4 UNION ALL 
SELECT 51, 46, 4 UNION ALL 
SELECT 52, 47, 4 UNION ALL 
SELECT 53, 48, 4 UNION ALL 
SELECT 54, 49, 4 UNION ALL 
SELECT 55, 50, 4 UNION ALL 
SELECT 56, 50, 8 UNION ALL 
SELECT 57, 51, 4 UNION ALL 
SELECT 58, 52, 4 UNION ALL 
SELECT 59, 53, 4 UNION ALL 
SELECT 60, 54, 4 UNION ALL 
SELECT 61, 55, 6 UNION ALL 
SELECT 62, 56, 6 UNION ALL 
SELECT 63, 57, 6 UNION ALL 
SELECT 64, 58, 6 UNION ALL 
SELECT 65, 59, 6 UNION ALL 
SELECT 66, 60, 6 UNION ALL 
SELECT 67, 61, 6 UNION ALL 
SELECT 68, 62, 6 UNION ALL 
SELECT 69, 63, 6 UNION ALL 
SELECT 70, 64, 6 UNION ALL 
SELECT 71, 65, 8 UNION ALL 
SELECT 72, 66, 8 UNION ALL 
SELECT 73, 67, 8 UNION ALL 
SELECT 74, 68, 8 UNION ALL 
SELECT 75, 69, 8 UNION ALL 
SELECT 76, 70, 8 UNION ALL 
SELECT 77, 71, 8 UNION ALL 
SELECT 78, 72, 8 UNION ALL 
SELECT 79, 73, 8 UNION ALL 
SELECT 80, 74, 8 UNION ALL 
SELECT 81, 75, 8 UNION ALL 
SELECT 82, 76, 8 UNION ALL 
SELECT 83, 77, 8 UNION ALL 
SELECT 84, 78, 8 UNION ALL 
SELECT 85, 79, 8 UNION ALL 
SELECT 86, 80, 8 UNION ALL 
SELECT 87, 81, 8 UNION ALL 
SELECT 88, 82, 8 UNION ALL 
SELECT 89, 83, 8 UNION ALL 
SELECT 90, 84, 8 UNION ALL 
SELECT 91, 85, 8 UNION ALL 
SELECT 92, 86, 8 UNION ALL 
SELECT 93, 87, 8 UNION ALL 
SELECT 94, 88, 8 UNION ALL 
SELECT 95, 89, 8 UNION ALL 
SELECT 96, 90, 8 UNION ALL 
SELECT 97, 91, 8 UNION ALL 
SELECT 98, 91, 42 UNION ALL 
SELECT 99, 92, 8 UNION ALL 
SELECT 100, 93, 8 UNION ALL 
SELECT 101, 94, 8 UNION ALL 
SELECT 102, 95, 8 UNION ALL 
SELECT 103, 96, 8 UNION ALL 
SELECT 104, 97, 8 UNION ALL 
SELECT 105, 98, 8 UNION ALL 
SELECT 106, 99, 8 UNION ALL 
SELECT 107, 100, 8 UNION ALL 
SELECT 108, 101, 8 UNION ALL 
SELECT 109, 102, 8 UNION ALL 
SELECT 110, 102, 42 UNION ALL 
SELECT 111, 103, 8 UNION ALL 
SELECT 112, 104, 8 UNION ALL 
SELECT 113, 105, 9 UNION ALL 
SELECT 114, 105, 42 UNION ALL 
SELECT 115, 106, 9 UNION ALL 
SELECT 116, 106, 42 UNION ALL 
SELECT 117, 107, 9 UNION ALL 
SELECT 118, 107, 42 UNION ALL 
SELECT 119, 108, 7 UNION ALL 
SELECT 120, 109, 7 UNION ALL 
SELECT 121, 110, 7 UNION ALL 
SELECT 122, 111, 7 UNION ALL 
SELECT 123, 112, 7 UNION ALL 
SELECT 124, 113, 7 UNION ALL 
SELECT 125, 114, 7 UNION ALL 
SELECT 126, 115, 7 UNION ALL 
SELECT 127, 116, 7 UNION ALL 
SELECT 128, 117, 7 UNION ALL 
SELECT 129, 118, 7 UNION ALL 
SELECT 130, 119, 7 UNION ALL 
SELECT 131, 120, 7 UNION ALL 
SELECT 132, 121, 7 UNION ALL 
SELECT 133, 122, 7 UNION ALL 
SELECT 134, 123, 7 UNION ALL 
SELECT 135, 124, 7 UNION ALL 
SELECT 136, 125, 7 UNION ALL 
SELECT 137, 126, 7 UNION ALL 
SELECT 138, 127, 7 UNION ALL 
SELECT 139, 128, 7 UNION ALL 
SELECT 140, 129, 7 UNION ALL 
SELECT 141, 130, 7 UNION ALL 
SELECT 142, 131, 7 UNION ALL 
SELECT 143, 132, 7 UNION ALL 
SELECT 144, 133, 7 UNION ALL 
SELECT 145, 134, 7 UNION ALL 
SELECT 146, 135, 7 UNION ALL 
SELECT 147, 136, 7 UNION ALL 
SELECT 148, 137, 7 UNION ALL 
SELECT 149, 138, 7 UNION ALL 
SELECT 150, 139, 7 UNION ALL 
SELECT 151, 140, 7 UNION ALL 
SELECT 152, 141, 7 UNION ALL 
SELECT 153, 142, 7 UNION ALL 
SELECT 154, 142, 42 UNION ALL 
SELECT 155, 143, 7 UNION ALL 
SELECT 156, 144, 7 UNION ALL 
SELECT 157, 145, 7 UNION ALL 
SELECT 158, 146, 7 UNION ALL 
SELECT 159, 147, 7 UNION ALL 
SELECT 160, 148, 7 UNION ALL 
SELECT 161, 149, 7 UNION ALL 
SELECT 162, 149, 42 UNION ALL 
SELECT 163, 150, 7 UNION ALL 
SELECT 164, 150, 42 UNION ALL 
SELECT 165, 151, 5 UNION ALL 
SELECT 166, 152, 5 UNION ALL 
SELECT 167, 153, 5 UNION ALL 
SELECT 168, 154, 5 UNION ALL 
SELECT 169, 154, 42 UNION ALL 
SELECT 170, 155, 5 UNION ALL 
SELECT 171, 155, 42 UNION ALL 
SELECT 172, 156, 5 UNION ALL 
SELECT 173, 156, 42 UNION ALL 
SELECT 174, 157, 5 UNION ALL 
SELECT 175, 158, 5 UNION ALL 
SELECT 176, 159, 5 UNION ALL 
SELECT 177, 160, 5 UNION ALL 
SELECT 178, 161, 5 UNION ALL 
SELECT 179, 162, 5 UNION ALL 
SELECT 180, 162, 42 UNION ALL 
SELECT 181, 163, 5 UNION ALL 
SELECT 182, 164, 5 UNION ALL 
SELECT 183, 165, 5 UNION ALL 
SELECT 184, 166, 5 UNION ALL 
SELECT 185, 167, 5 UNION ALL 
SELECT 186, 167, 42 UNION ALL 
SELECT 187, 168, 41 UNION ALL 
SELECT 188, 169, 41 UNION ALL 
SELECT 189, 170, 41 UNION ALL 
SELECT 190, 171, 41 UNION ALL 
SELECT 191, 172, 41 UNION ALL 
SELECT 192, 173, 41 UNION ALL 
SELECT 193, 174, 44 UNION ALL 
SELECT 194, 175, 46 UNION ALL 
SELECT 195, 176, 45 UNION ALL 
SELECT 196, 177, 18 UNION ALL 
SELECT 197, 178, 18 UNION ALL 
SELECT 198, 179, 19 UNION ALL 
SELECT 199, 180, 19 UNION ALL 
SELECT 200, 181, 21 UNION ALL 
SELECT 201, 182, 21 UNION ALL 
SELECT 202, 183, 21 UNION ALL 
SELECT 203, 184, 21 UNION ALL 
SELECT 204, 185, 22 UNION ALL 
SELECT 205, 186, 17 UNION ALL 
SELECT 206, 187, 20 UNION ALL 
SELECT 207, 188, 17 UNION ALL 
SELECT 208, 189, 17 UNION ALL 
SELECT 209, 190, 21 UNION ALL 
SELECT 210, 191, 23 UNION ALL 
SELECT 211, 192, 23 UNION ALL 
SELECT 212, 193, 23 UNION ALL 
SELECT 213, 194, 23 UNION ALL 
SELECT 214, 195, 23 UNION ALL 
SELECT 215, 196, 23 UNION ALL 
SELECT 216, 197, 22 UNION ALL 
SELECT 217, 198, 20 UNION ALL 
SELECT 218, 199, 20 UNION ALL 
SELECT 219, 200, 19 UNION ALL 
SELECT 220, 201, 19 UNION ALL 
SELECT 221, 202, 17 UNION ALL 
SELECT 222, 203, 17 UNION ALL 
SELECT 223, 204, 17 UNION ALL 
SELECT 224, 205, 17 UNION ALL 
SELECT 225, 206, 12 UNION ALL 
SELECT 226, 207, 12 UNION ALL 
SELECT 227, 208, 12 UNION ALL 
SELECT 228, 209, 13 UNION ALL 
SELECT 229, 210, 13 UNION ALL 
SELECT 230, 211, 13 UNION ALL 
SELECT 231, 212, 13 UNION ALL 
SELECT 232, 213, 13 UNION ALL 
SELECT 233, 214, 13 UNION ALL 
SELECT 234, 215, 42 UNION ALL 
SELECT 235, 216, 42 UNION ALL 
SELECT 236, 217, 48 UNION ALL 
SELECT 237, 218, 48 UNION ALL 
SELECT 238, 219, 48 UNION ALL 
SELECT 239, 220, 48 UNION ALL 
SELECT 240, 221, 48 UNION ALL 
SELECT 241, 222, 48 UNION ALL 
SELECT 242, 223, 48 UNION ALL 
SELECT 243, 224, 48 UNION ALL 
SELECT 244, 225, 48 UNION ALL 
SELECT 245, 226, 48 UNION ALL 
SELECT 246, 227, 50 UNION ALL 
SELECT 247, 228, 50 UNION ALL 
SELECT 248, 229, 50 UNION ALL 
SELECT 249, 230, 50 UNION ALL 
SELECT 250, 231, 50 UNION ALL 
SELECT 251, 232, 50 UNION ALL 
SELECT 252, 233, 50 UNION ALL 
SELECT 253, 234, 50 UNION ALL 
SELECT 254, 235, 50 UNION ALL 
SELECT 255, 236, 50 UNION ALL 
SELECT 256, 237, 50 UNION ALL 
SELECT 257, 238, 50 UNION ALL 
SELECT 258, 239, 50 UNION ALL 
SELECT 259, 240, 50 UNION ALL 
SELECT 260, 241, 50 UNION ALL 
SELECT 261, 242, 50 UNION ALL 
SELECT 262, 243, 50 UNION ALL 
SELECT 263, 244, 50 UNION ALL 
SELECT 264, 245, 50 UNION ALL 
SELECT 265, 246, 51 UNION ALL 
SELECT 266, 247, 51 UNION ALL 
SELECT 267, 248, 51 UNION ALL 
SELECT 268, 249, 51 UNION ALL 
SELECT 269, 250, 51 UNION ALL 
SELECT 270, 251, 51 UNION ALL 
SELECT 271, 252, 51 UNION ALL 
SELECT 272, 253, 51 UNION ALL 
SELECT 273, 254, 51 UNION ALL 
SELECT 274, 255, 51 UNION ALL 
SELECT 275, 256, 51 UNION ALL 
SELECT 276, 257, 22 UNION ALL 
SELECT 277, 257, 23 UNION ALL 
SELECT 278, 258, 23 UNION ALL 
SELECT 279, 259, 23 UNION ALL 
SELECT 280, 260, 22 UNION ALL 
SELECT 281, 261, 22 UNION ALL 
SELECT 282, 262, 16 UNION ALL 
SELECT 283, 263, 21 UNION ALL 
SELECT 284, 264, 21 UNION ALL 
SELECT 285, 265, 24 UNION ALL 
SELECT 286, 266, 24 UNION ALL 
SELECT 287, 267, 24 UNION ALL 
SELECT 288, 268, 24 UNION ALL 
SELECT 289, 269, 24 UNION ALL 
SELECT 290, 270, 24 UNION ALL 
SELECT 291, 271, 24 UNION ALL 
SELECT 292, 272, 24 UNION ALL 
SELECT 293, 273, 24 UNION ALL 
SELECT 294, 274, 24 UNION ALL 
SELECT 295, 276, 4 UNION ALL 
SELECT 296, 277, 75 UNION ALL 
SELECT 297, 284, 59 UNION ALL 
SELECT 298, 287, 60 UNION ALL 
SELECT 299, 287, 72 UNION ALL 
SELECT 300, 304, 59 UNION ALL 
SELECT 301, 305, 59 UNION ALL 
SELECT 302, 306, 59 UNION ALL 
SELECT 303, 310, 62 UNION ALL 
SELECT 304, 310, 64 UNION ALL 
SELECT 305, 312, 54 UNION ALL 
SELECT 306, 316, 60 UNION ALL 
SELECT 307, 317, 60 UNION ALL 
SELECT 308, 318, 60 UNION ALL 
SELECT 309, 332, 11 UNION ALL 
SELECT 310, 333, 11 UNION ALL 
SELECT 311, 334, 63 UNION ALL 
SELECT 312, 341, 4 UNION ALL 
SELECT 313, 342, 4 UNION ALL 
SELECT 314, 343, 4 UNION ALL 
SELECT 315, 344, 4 UNION ALL 
SELECT 316, 345, 4 UNION ALL 
SELECT 317, 346, 4 UNION ALL 
SELECT 318, 347, 4 UNION ALL 
SELECT 319, 348, 4 UNION ALL 
SELECT 320, 349, 4 UNION ALL 
SELECT 321, 350, 4 UNION ALL 
SELECT 322, 356, 8 UNION ALL 
SELECT 323, 357, 8 UNION ALL 
SELECT 324, 358, 8 UNION ALL 
SELECT 325, 359, 4 UNION ALL 
SELECT 326, 360, 4 UNION ALL 
SELECT 327, 361, 4 UNION ALL 
SELECT 328, 362, 4 UNION ALL 
SELECT 329, 363, 4 UNION ALL 
SELECT 330, 364, 4 UNION ALL 
SELECT 331, 365, 9 UNION ALL 
SELECT 332, 366, 5 UNION ALL 
SELECT 333, 367, 6 UNION ALL 
SELECT 334, 368, 6 UNION ALL 
SELECT 335, 369, 6 UNION ALL 
SELECT 336, 370, 5 UNION ALL 
SELECT 337, 371, 5 UNION ALL 
SELECT 338, 372, 4 UNION ALL 
SELECT 339, 373, 4 UNION ALL 
SELECT 340, 374, 4 UNION ALL 
SELECT 341, 375, 4 UNION ALL 
SELECT 342, 376, 4 UNION ALL 
SELECT 343, 377, 4 UNION ALL 
SELECT 344, 378, 4 UNION ALL 
SELECT 345, 379, 4 UNION ALL 
SELECT 346, 380, 4 UNION ALL 
SELECT 347, 381, 4 UNION ALL 
SELECT 348, 382, 4 UNION ALL 
SELECT 349, 383, 4 UNION ALL 
SELECT 350, 384, 4 UNION ALL 
SELECT 351, 385, 4 UNION ALL 
SELECT 352, 386, 4 UNION ALL 
SELECT 353, 387, 4 UNION ALL 
SELECT 354, 388, 4 UNION ALL 
SELECT 355, 389, 4 UNION ALL 
SELECT 356, 390, 4 UNION ALL 
SELECT 357, 391, 4 UNION ALL 
SELECT 358, 392, 4 UNION ALL 
SELECT 359, 393, 4 UNION ALL 
SELECT 360, 394, 4 UNION ALL 
SELECT 361, 395, 4 UNION ALL 
SELECT 362, 396, 6 UNION ALL 
SELECT 363, 397, 6 UNION ALL 
SELECT 364, 398, 6 UNION ALL 
SELECT 365, 399, 6 UNION ALL 
SELECT 366, 400, 6 UNION ALL 
SELECT 367, 401, 6 UNION ALL 
SELECT 368, 402, 6 UNION ALL 
SELECT 369, 403, 6 UNION ALL 
SELECT 370, 404, 6 UNION ALL 
SELECT 371, 405, 8 UNION ALL 
SELECT 372, 406, 8 UNION ALL 
SELECT 373, 407, 4 UNION ALL 
SELECT 374, 408, 5 UNION ALL 
SELECT 375, 409, 5 UNION ALL 
SELECT 376, 410, 7 UNION ALL 
SELECT 377, 411, 7 UNION ALL 
SELECT 378, 412, 7 UNION ALL 
SELECT 379, 413, 7 UNION ALL 
SELECT 380, 414, 7 UNION ALL 
SELECT 381, 415, 7 UNION ALL 
SELECT 382, 416, 7 UNION ALL 
SELECT 383, 417, 7 UNION ALL 
SELECT 384, 418, 7 UNION ALL 
SELECT 385, 419, 7 UNION ALL 
SELECT 386, 420, 7 UNION ALL 
SELECT 387, 421, 7 UNION ALL 
SELECT 388, 422, 7 UNION ALL 
SELECT 389, 423, 7 UNION ALL 
SELECT 390, 424, 7 UNION ALL 
SELECT 391, 425, 7 UNION ALL 
SELECT 392, 426, 9 UNION ALL 
SELECT 393, 428, 8 UNION ALL 
SELECT 394, 429, 8 UNION ALL 
SELECT 395, 430, 8 UNION ALL 
SELECT 396, 431, 8 UNION ALL 
SELECT 397, 432, 8 UNION ALL 
SELECT 398, 433, 8 UNION ALL 
SELECT 399, 434, 8 UNION ALL 
SELECT 400, 435, 8 UNION ALL 
SELECT 401, 436, 8 UNION ALL 
SELECT 402, 447, 62 UNION ALL 
SELECT 403, 447, 64 UNION ALL 
SELECT 404, 448, 62 UNION ALL 
SELECT 405, 448, 64 UNION ALL 
SELECT 406, 449, 62 UNION ALL 
SELECT 407, 449, 64 UNION ALL 
SELECT 408, 450, 62 UNION ALL 
SELECT 409, 452, 78 UNION ALL 
SELECT 410, 453, 78 UNION ALL 
SELECT 411, 454, 28 UNION ALL 
SELECT 412, 455, 28 UNION ALL 
SELECT 413, 456, 28 UNION ALL 
SELECT 414, 457, 28 UNION ALL 
SELECT 415, 458, 28 UNION ALL 
SELECT 416, 459, 28 UNION ALL 
SELECT 417, 462, 72 UNION ALL 
SELECT 418, 463, 72 UNION ALL 
SELECT 419, 465, 71 UNION ALL 
SELECT 420, 466, 71 UNION ALL 
SELECT 421, 475, 63 UNION ALL 
SELECT 422, 475, 63 UNION ALL 
SELECT 423, 481, 63 UNION ALL 
SELECT 424, 482, 62 UNION ALL 
SELECT 425, 482, 64 UNION ALL 
SELECT 426, 483, 63 UNION ALL 
SELECT 427, 484, 60 UNION ALL 
SELECT 428, 490, 77 UNION ALL 
SELECT 429, 491, 77 UNION ALL 
SELECT 430, 492, 77 UNION ALL 
SELECT 431, 495, 72 UNION ALL 
SELECT 432, 496, 72 UNION ALL 
SELECT 433, 497, 72 UNION ALL 
SELECT 434, 499, 72 UNION ALL 
SELECT 435, 502, 72 UNION ALL 
SELECT 436, 504, 72 UNION ALL 
SELECT 437, 505, 77 UNION ALL 
SELECT 438, 506, 67 UNION ALL 
SELECT 439, 508, 72 UNION ALL 
SELECT 440, 508, 56 UNION ALL 
SELECT 441, 509, 72 UNION ALL 
SELECT 442, 509, 58 UNION ALL 
SELECT 443, 510, 72 UNION ALL 
SELECT 444, 510, 58 UNION ALL 
SELECT 445, 511, 72 UNION ALL 
SELECT 446, 511, 58 UNION ALL 
SELECT 447, 522, 80 UNION ALL 
SELECT 448, 523, 80 UNION ALL 
SELECT 449, 524, 80 UNION ALL 
SELECT 450, 525, 65 UNION ALL 
SELECT 451, 526, 67 UNION ALL 
SELECT 452, 533, 21 UNION ALL 
SELECT 453, 534, 20 UNION ALL 
SELECT 454, 535, 21 UNION ALL 
SELECT 455, 536, 21 UNION ALL 
SELECT 456, 537, 21 UNION ALL 
SELECT 457, 538, 22 UNION ALL 
SELECT 458, 539, 22 UNION ALL 
SELECT 459, 540, 77 UNION ALL 
SELECT 460, 541, 77 UNION ALL 
SELECT 461, 542, 77 UNION ALL 
SELECT 462, 545, 75 UNION ALL 
SELECT 463, 561, 74 UNION ALL 
SELECT 464, 562, 77 UNION ALL 
SELECT 465, 564, 77 UNION ALL 
SELECT 466, 565, 77 UNION ALL 
SELECT 467, 566, 72 UNION ALL 
SELECT 468, 567, 73 UNION ALL 
SELECT 469, 568, 73 UNION ALL 
SELECT 470, 572, 63 UNION ALL 
SELECT 471, 573, 63 UNION ALL 
SELECT 472, 574, 75 UNION ALL 
SELECT 473, 575, 75 UNION ALL 
SELECT 474, 576, 75 UNION ALL 
SELECT 475, 577, 75 UNION ALL 
SELECT 476, 578, 75 UNION ALL 
SELECT 477, 579, 75 UNION ALL 
SELECT 478, 580, 75 UNION ALL 
SELECT 479, 581, 75 UNION ALL 
SELECT 480, 582, 75 UNION ALL 
SELECT 481, 583, 75 UNION ALL 
SELECT 482, 584, 75 UNION ALL 
SELECT 483, 585, 75 UNION ALL 
SELECT 484, 586, 75 UNION ALL 
SELECT 485, 587, 75 UNION ALL 
SELECT 486, 588, 75 UNION ALL 
SELECT 487, 589, 75 UNION ALL 
SELECT 488, 590, 75 UNION ALL 
SELECT 489, 591, 75 UNION ALL 
SELECT 490, 592, 75 UNION ALL 
SELECT 491, 593, 75 UNION ALL 
SELECT 492, 594, 75 UNION ALL 
SELECT 493, 595, 75 UNION ALL 
SELECT 494, 596, 75 UNION ALL 
SELECT 495, 597, 75 UNION ALL 
SELECT 496, 598, 75 UNION ALL 
SELECT 497, 599, 75 UNION ALL 
SELECT 498, 600, 75 UNION ALL 
SELECT 499, 601, 75 UNION ALL 
SELECT 500, 602, 75 UNION ALL 
SELECT 501, 603, 75 UNION ALL 
SELECT 502, 604, 75 UNION ALL 
SELECT 503, 605, 75 UNION ALL 
SELECT 504, 606, 81 UNION ALL 
SELECT 505, 607, 81 UNION ALL 
SELECT 506, 608, 44 UNION ALL 
SELECT 507, 609, 75 
COMMIT;
SET IDENTITY_INSERT [dbo].[MatchQuestionCategory] OFF

GO


-- Opcje zapytań
CREATE TABLE [dbo].[QuestionsOptions] (
      [Id]				INT            IDENTITY (1, 1) NOT NULL
    , [QuestionId]		INT            NOT NULL
    , [LanguageId]		INT            NOT NULL
    , [Content]			NVARCHAR (255) NOT NULL
    , [Weight]			INT            DEFAULT ((1)) NOT NULL
    , [IsMain]			BIT            DEFAULT ((1)) NOT NULL	
    , [IsActive]		BIT            DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT            DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME       DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT            DEFAULT ((0)) NOT NULL
    , [Positive]		INT            DEFAULT ((0)) NOT NULL
    , [Negative]		INT            DEFAULT ((0)) NOT NULL
    , [IsComplex]		BIT            DEFAULT ((0)) NOT NULL
    , [IsCompleted]		BIT			   DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_QuestionsOptions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_QuestionsOptions_QuestionLanguageContent] UNIQUE NONCLUSTERED ([QuestionId] ASC, [LanguageId] ASC, [Content] ASC)
    , CONSTRAINT [FK_QuestionsOptions_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id])
    , CONSTRAINT [FK_QuestionsOptions_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [FK_QuestionsOptions_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [CH_QuestionsOptionsWeight] CHECK ([Weight] > (0) AND [Weight] <= (10))
);

GO
SET IDENTITY_INSERT [dbo].[QuestionsOptions] ON
BEGIN TRANSACTION;
INSERT INTO [dbo].[QuestionsOptions]([Id], [QuestionId], [LanguageId], [Content], [Weight], [IsMain])
SELECT 1, 2, 1, N'Polska', 10, 1 UNION ALL 
SELECT 2, 3, 1, N'pies', 10, 1 UNION ALL 
SELECT 3, 4, 1, N'Włochy', 10, 1 UNION ALL 
SELECT 4, 5, 1, N'Hiszpania', 10, 1 UNION ALL 
SELECT 5, 6, 1, N'Francja', 10, 1 UNION ALL 
SELECT 6, 7, 1, N'Niemcy', 10, 1 UNION ALL 
SELECT 7, 8, 1, N'Anglia', 10, 1 UNION ALL 
SELECT 8, 9, 1, N'Rosja', 10, 1 UNION ALL 
SELECT 9, 10, 1, N'Albania', 10, 1 UNION ALL 
SELECT 10, 11, 1, N'Andora', 10, 1 UNION ALL 
SELECT 11, 12, 1, N'Armenia', 10, 1 UNION ALL 
SELECT 12, 13, 1, N'Austria', 10, 1 UNION ALL 
SELECT 13, 14, 1, N'Azerbejdżan', 10, 1 UNION ALL 
SELECT 14, 15, 1, N'Białoruś', 10, 1 UNION ALL 
SELECT 15, 16, 1, N'Belgia', 10, 1 UNION ALL 
SELECT 16, 17, 1, N'Bośnia i Hercegowina', 10, 1 UNION ALL 
SELECT 17, 18, 1, N'Bułgaria', 10, 1 UNION ALL 
SELECT 18, 19, 1, N'Chorwacja', 10, 1 UNION ALL 
SELECT 19, 20, 1, N'Cypr', 10, 1 UNION ALL 
SELECT 20, 21, 1, N'Czechy', 10, 1 UNION ALL 
SELECT 21, 22, 1, N'Dania', 10, 1 UNION ALL 
SELECT 22, 23, 1, N'Estonia', 10, 1 UNION ALL 
SELECT 23, 24, 1, N'Finlandia', 10, 1 UNION ALL 
SELECT 24, 25, 1, N'Gruzja', 10, 1 UNION ALL 
SELECT 25, 26, 1, N'Grecja', 10, 1 UNION ALL 
SELECT 26, 27, 1, N'Węgry', 10, 1 UNION ALL 
SELECT 27, 28, 1, N'Islandia', 10, 1 UNION ALL 
SELECT 28, 29, 1, N'Irlandia', 10, 1 UNION ALL 
SELECT 29, 30, 1, N'Kazachstan', 10, 1 UNION ALL 
SELECT 30, 31, 1, N'Łotwa', 10, 1 UNION ALL 
SELECT 31, 32, 1, N'Liechtenstein', 10, 1 UNION ALL 
SELECT 32, 33, 1, N'Litwa', 10, 1 UNION ALL 
SELECT 33, 34, 1, N'Luksemburg', 10, 1 UNION ALL 
SELECT 34, 35, 1, N'Macedonia', 10, 1 UNION ALL 
SELECT 35, 36, 1, N'Malta', 10, 1 UNION ALL 
SELECT 36, 37, 1, N'Mołdawia', 10, 1 UNION ALL 
SELECT 37, 38, 1, N'Monako', 10, 1 UNION ALL 
SELECT 38, 39, 1, N'Czarnogóra', 10, 1 UNION ALL 
SELECT 39, 40, 1, N'Holandia', 10, 1 UNION ALL 
SELECT 40, 41, 1, N'Norwegia', 10, 1 UNION ALL 
SELECT 41, 42, 1, N'Portugalia', 10, 1 UNION ALL 
SELECT 42, 43, 1, N'Rumunia', 10, 1 UNION ALL 
SELECT 43, 44, 1, N'San Marino', 10, 1 UNION ALL 
SELECT 44, 45, 1, N'Serbia', 10, 1 UNION ALL 
SELECT 45, 46, 1, N'Słowacja', 10, 1 UNION ALL 
SELECT 46, 47, 1, N'Słowenia', 10, 1 UNION ALL 
SELECT 47, 48, 1, N'Szwecja', 10, 1 UNION ALL 
SELECT 48, 49, 1, N'Szwajcaria', 10, 1 UNION ALL 
SELECT 49, 50, 1, N'Turcja', 10, 1 UNION ALL 
SELECT 50, 51, 1, N'Ukraina', 10, 1 UNION ALL 
SELECT 51, 52, 1, N'Wielka Brytania', 10, 1 UNION ALL 
SELECT 52, 53, 1, N'Watykan', 10, 1 UNION ALL 
SELECT 53, 54, 1, N'Szkocja', 10, 1 UNION ALL 
SELECT 54, 55, 1, N'Brazylia', 10, 1 UNION ALL 
SELECT 55, 56, 1, N'Argentyna', 10, 1 UNION ALL 
SELECT 56, 57, 1, N'Peru', 10, 1 UNION ALL 
SELECT 57, 58, 1, N'Boliwia', 10, 1 UNION ALL 
SELECT 58, 59, 1, N'Chile', 10, 1 UNION ALL 
SELECT 59, 60, 1, N'Kolumbia', 10, 1 UNION ALL 
SELECT 60, 61, 1, N'Wenezuela', 10, 1 UNION ALL 
SELECT 61, 62, 1, N'Urugwaj', 10, 1 UNION ALL 
SELECT 62, 63, 1, N'Paragwaj', 10, 1 UNION ALL 
SELECT 63, 64, 1, N'Ekwador', 10, 1 UNION ALL 
SELECT 64, 65, 1, N'Chiny', 10, 1 UNION ALL 
SELECT 65, 66, 1, N'Japonia', 10, 1 UNION ALL 
SELECT 66, 67, 1, N'Indie', 10, 1 UNION ALL 
SELECT 67, 68, 1, N'Tajlandia', 10, 1 UNION ALL 
SELECT 68, 69, 1, N'Izrael', 10, 1 UNION ALL 
SELECT 69, 70, 1, N'Liban', 10, 1 UNION ALL 
SELECT 70, 71, 1, N'Jordania', 10, 1 UNION ALL 
SELECT 71, 72, 1, N'Syria', 10, 1 UNION ALL 
SELECT 72, 73, 1, N'Arabia Saudyjska', 10, 1 UNION ALL 
SELECT 73, 74, 1, N'Jemen', 10, 1 UNION ALL 
SELECT 74, 75, 1, N'Oman', 10, 1 UNION ALL 
SELECT 75, 76, 1, N'Zjednoczone Emiraty Arabskie', 10, 1 UNION ALL 
SELECT 76, 76, 1, N'Emiraty Arabskie', 10, 0 UNION ALL 
SELECT 77, 77, 1, N'Kuwejt', 10, 1 UNION ALL 
SELECT 78, 78, 1, N'Bahrajn', 10, 1 UNION ALL 
SELECT 79, 79, 1, N'Katar', 10, 1 UNION ALL 
SELECT 80, 80, 1, N'Irak', 10, 1 UNION ALL 
SELECT 81, 81, 1, N'Iran', 10, 1 UNION ALL 
SELECT 82, 82, 1, N'Afganistan', 10, 1 UNION ALL 
SELECT 83, 83, 1, N'Pakistan', 10, 1 UNION ALL 
SELECT 84, 84, 1, N'Uzbekistan', 10, 1 UNION ALL 
SELECT 85, 85, 1, N'Turkmenistan', 10, 1 UNION ALL 
SELECT 86, 86, 1, N'Tadżykistan', 10, 1 UNION ALL 
SELECT 87, 87, 1, N'Kirgistan', 10, 1 UNION ALL 
SELECT 88, 88, 1, N'Nepal', 10, 1 UNION ALL 
SELECT 89, 89, 1, N'Bhutan', 10, 1 UNION ALL 
SELECT 90, 90, 1, N'Bangladesz', 10, 1 UNION ALL 
SELECT 91, 91, 1, N'Sri Lanka', 10, 1 UNION ALL 
SELECT 92, 92, 1, N'Mongolia', 10, 1 UNION ALL 
SELECT 93, 93, 1, N'Laos', 10, 1 UNION ALL 
SELECT 94, 94, 1, N'Kambodża', 10, 1 UNION ALL 
SELECT 95, 95, 1, N'Wietnam', 10, 1 UNION ALL 
SELECT 96, 96, 1, N'Myanmar', 10, 1 UNION ALL 
SELECT 97, 97, 1, N'Korea Południowa', 10, 1 UNION ALL 
SELECT 98, 98, 1, N'Korea Północna', 10, 1 UNION ALL 
SELECT 99, 99, 1, N'Malezja', 10, 1 UNION ALL 
SELECT 100, 100, 1, N'Indonezja', 10, 1 UNION ALL 
SELECT 101, 101, 1, N'Filipiny', 10, 1 UNION ALL 
SELECT 102, 102, 1, N'Tajwan', 10, 1 UNION ALL 
SELECT 103, 103, 1, N'Hongkong', 10, 1 UNION ALL 
SELECT 104, 104, 1, N'Singapur', 10, 1 UNION ALL 
SELECT 105, 105, 1, N'Australia', 10, 1 UNION ALL 
SELECT 106, 106, 1, N'Nowa Zelandia', 10, 1 UNION ALL 
SELECT 107, 107, 1, N'Fidżi', 10, 1 UNION ALL 
SELECT 108, 108, 1, N'Egipt', 10, 1 UNION ALL 
SELECT 109, 109, 1, N'Libia', 10, 1 UNION ALL 
SELECT 110, 110, 1, N'Tunezja', 10, 1 UNION ALL 
SELECT 111, 111, 1, N'Maroko', 10, 1 UNION ALL 
SELECT 112, 112, 1, N'Algieria', 10, 1 UNION ALL 
SELECT 113, 113, 1, N'Sudan', 10, 1 UNION ALL 
SELECT 114, 114, 1, N'Etiopia', 10, 1 UNION ALL 
SELECT 115, 115, 1, N'Erytrea', 10, 1 UNION ALL 
SELECT 116, 116, 1, N'Dżibuti', 10, 1 UNION ALL 
SELECT 117, 117, 1, N'Czad', 10, 1 UNION ALL 
SELECT 118, 118, 1, N'Mauretania', 10, 1 UNION ALL 
SELECT 119, 119, 1, N'Burkina Faso', 10, 1 UNION ALL 
SELECT 120, 120, 1, N'Mali', 10, 1 UNION ALL 
SELECT 121, 121, 1, N'Senegal', 10, 1 UNION ALL 
SELECT 122, 122, 1, N'Gambia', 10, 1 UNION ALL 
SELECT 123, 123, 1, N'Gwinea', 10, 1 UNION ALL 
SELECT 124, 124, 1, N'Ghana', 10, 1 UNION ALL 
SELECT 125, 125, 1, N'Somalia', 10, 1 UNION ALL 
SELECT 126, 126, 1, N'Wybrzeże Kości Słoniowej', 10, 1 UNION ALL 
SELECT 127, 127, 1, N'Togo', 10, 1 UNION ALL 
SELECT 128, 128, 1, N'Liberia', 10, 1 UNION ALL 
SELECT 129, 129, 1, N'Sierra Leone', 10, 1 UNION ALL 
SELECT 130, 130, 1, N'Niger', 10, 1 UNION ALL 
SELECT 131, 131, 1, N'Nigeria', 10, 1 UNION ALL 
SELECT 132, 132, 1, N'Kamerun', 10, 1 UNION ALL 
SELECT 133, 133, 1, N'Gabon', 10, 1 UNION ALL 
SELECT 134, 134, 1, N'Kongo', 10, 1 UNION ALL 
SELECT 135, 135, 1, N'Demokratyczna Republika Konga', 10, 1 UNION ALL 
SELECT 136, 136, 1, N'Uganda', 10, 1 UNION ALL 
SELECT 137, 137, 1, N'Burundi', 10, 1 UNION ALL 
SELECT 138, 138, 1, N'Kenia', 10, 1 UNION ALL 
SELECT 139, 139, 1, N'Tanzania', 10, 1 UNION ALL 
SELECT 140, 140, 1, N'Mozambik', 10, 1 UNION ALL 
SELECT 141, 141, 1, N'Ruanda', 10, 1 UNION ALL 
SELECT 142, 142, 1, N'Madagaskar', 10, 1 UNION ALL 
SELECT 143, 143, 1, N'Angola', 10, 1 UNION ALL 
SELECT 144, 144, 1, N'Namibia', 10, 1 UNION ALL 
SELECT 145, 145, 1, N'RPA', 10, 0 UNION ALL 
SELECT 146, 145, 1, N'Południowa Afryka', 10, 0 UNION ALL 
SELECT 147, 145, 1, N'Republika Południowej Afryki', 10, 1 UNION ALL 
SELECT 148, 146, 1, N'Zambia', 10, 1 UNION ALL 
SELECT 149, 147, 1, N'Zimbabwe', 10, 1 UNION ALL 
SELECT 150, 148, 1, N'Botswana', 10, 1 UNION ALL 
SELECT 151, 149, 1, N'Seszele', 10, 1 UNION ALL 
SELECT 152, 150, 1, N'Mauritius', 10, 1 UNION ALL 
SELECT 153, 151, 1, N'USA', 10, 1 UNION ALL 
SELECT 154, 151, 1, N'Stany Zjednoczone', 10, 1 UNION ALL 
SELECT 155, 152, 1, N'Kanada', 10, 1 UNION ALL 
SELECT 156, 153, 1, N'Meksyk', 10, 1 UNION ALL 
SELECT 157, 154, 1, N'Grenlandia', 10, 1 UNION ALL 
SELECT 158, 155, 1, N'Jamajka', 10, 1 UNION ALL 
SELECT 159, 156, 1, N'Kuba', 10, 1 UNION ALL 
SELECT 160, 157, 1, N'Honduras', 10, 1 UNION ALL 
SELECT 161, 158, 1, N'Salwador', 10, 1 UNION ALL 
SELECT 162, 159, 1, N'Gwatemala', 10, 1 UNION ALL 
SELECT 163, 160, 1, N'Nikaragua', 10, 1 UNION ALL 
SELECT 164, 161, 1, N'Panama', 10, 1 UNION ALL 
SELECT 165, 162, 1, N'Dominikana', 10, 1 UNION ALL 
SELECT 166, 163, 1, N'Haiti', 10, 1 UNION ALL 
SELECT 167, 164, 1, N'Portoryko', 10, 1 UNION ALL 
SELECT 168, 165, 1, N'Kostaryka', 10, 1 UNION ALL 
SELECT 169, 166, 1, N'Belize', 10, 1 UNION ALL 
SELECT 170, 167, 1, N'Bahamy', 10, 1 UNION ALL 
SELECT 171, 168, 1, N'Europa', 10, 1 UNION ALL 
SELECT 172, 169, 1, N'Ameryka Południowa', 10, 1 UNION ALL 
SELECT 173, 170, 1, N'Ameryka Północna', 10, 1 UNION ALL 
SELECT 174, 171, 1, N'Afryka', 10, 1 UNION ALL 
SELECT 175, 172, 1, N'Azja', 10, 1 UNION ALL 
SELECT 176, 173, 1, N'Oceania', 10, 1 UNION ALL 
SELECT 177, 174, 1, N'Skandynawia', 10, 1 UNION ALL 
SELECT 178, 175, 1, N'Kaukaz', 10, 1 UNION ALL 
SELECT 179, 176, 1, N'Karaiby', 10, 1 UNION ALL 
SELECT 180, 177, 1, N'kot', 10, 1 UNION ALL 
SELECT 181, 178, 1, N'chomik', 10, 1 UNION ALL 
SELECT 182, 179, 1, N'krowa', 10, 1 UNION ALL 
SELECT 183, 180, 1, N'koń', 10, 1 UNION ALL 
SELECT 184, 181, 1, N'mucha', 10, 1 UNION ALL 
SELECT 185, 182, 1, N'pszczoła', 10, 1 UNION ALL 
SELECT 186, 183, 1, N'osa', 10, 1 UNION ALL 
SELECT 187, 184, 1, N'komar', 10, 1 UNION ALL 
SELECT 188, 185, 1, N'żaba', 10, 1 UNION ALL 
SELECT 189, 186, 1, N'ptak', 10, 1 UNION ALL 
SELECT 190, 187, 1, N'ryba', 10, 1 UNION ALL 
SELECT 191, 188, 1, N'bocian', 10, 1 UNION ALL 
SELECT 192, 189, 1, N'wróbel', 10, 1 UNION ALL 
SELECT 193, 190, 1, N'motyl', 10, 1 UNION ALL 
SELECT 194, 191, 1, N'małpa', 10, 1 UNION ALL 
SELECT 195, 192, 1, N'słoń', 10, 1 UNION ALL 
SELECT 196, 193, 1, N'lew', 10, 1 UNION ALL 
SELECT 197, 194, 1, N'żyrafa', 10, 1 UNION ALL 
SELECT 198, 195, 1, N'wielbłąd', 10, 1 UNION ALL 
SELECT 199, 196, 1, N'tygrys', 10, 1 UNION ALL 
SELECT 200, 197, 1, N'wąż', 10, 1 UNION ALL 
SELECT 201, 198, 1, N'rekin', 10, 1 UNION ALL 
SELECT 202, 199, 1, N'wieloryb', 10, 1 UNION ALL 
SELECT 203, 200, 1, N'osioł', 10, 1 UNION ALL 
SELECT 204, 201, 1, N'owca', 10, 1 UNION ALL 
SELECT 205, 202, 1, N'gołąb', 10, 1 UNION ALL 
SELECT 206, 203, 1, N'sokół', 10, 1 UNION ALL 
SELECT 207, 204, 1, N'orzeł', 10, 1 UNION ALL 
SELECT 208, 205, 1, N'jastrząb', 10, 1 UNION ALL 
SELECT 209, 206, 1, N'Andy', 10, 1 UNION ALL 
SELECT 210, 207, 1, N'Himalaje', 10, 1 UNION ALL 
SELECT 211, 208, 1, N'Alpy', 10, 1 UNION ALL 
SELECT 212, 209, 1, N'Morze Śródziemne', 10, 1 UNION ALL 
SELECT 213, 210, 1, N'Ocean Atlantycki', 10, 1 UNION ALL 
SELECT 214, 210, 1, N'Atlantyk', 10, 1 UNION ALL 
SELECT 215, 211, 1, N'Ocean Spokojny', 10, 1 UNION ALL 
SELECT 216, 211, 1, N'Pacyfik', 10, 1 UNION ALL 
SELECT 217, 212, 1, N'Ocean Indyjski', 10, 1 UNION ALL 
SELECT 218, 213, 1, N'Zatoka Perska', 10, 1 UNION ALL 
SELECT 219, 214, 1, N'Morze Bałtyckie', 10, 1 UNION ALL 
SELECT 220, 214, 1, N'Bałtyk', 10, 1 UNION ALL 
SELECT 221, 215, 1, N'Sardynia', 10, 1 UNION ALL 
SELECT 222, 216, 1, N'Sycylia', 10, 1 UNION ALL 
SELECT 223, 217, 1, N'czarny', 10, 1 UNION ALL 
SELECT 224, 218, 1, N'biały', 10, 1 UNION ALL 
SELECT 225, 219, 1, N'zielony', 10, 1 UNION ALL 
SELECT 226, 220, 1, N'czerwony', 10, 1 UNION ALL 
SELECT 227, 221, 1, N'żółty', 10, 1 UNION ALL 
SELECT 228, 222, 1, N'brązowy', 10, 1 UNION ALL 
SELECT 229, 223, 1, N'niebieski', 10, 1 UNION ALL 
SELECT 230, 224, 1, N'różowy', 10, 1 UNION ALL 
SELECT 231, 225, 1, N'pomarańczowy', 10, 1 UNION ALL 
SELECT 232, 226, 1, N'szary', 10, 1 UNION ALL 
SELECT 233, 227, 1, N'poniedziałek', 10, 1 UNION ALL 
SELECT 234, 228, 1, N'wtorek', 10, 1 UNION ALL 
SELECT 235, 229, 1, N'środa', 10, 1 UNION ALL 
SELECT 236, 230, 1, N'czwartek', 10, 1 UNION ALL 
SELECT 237, 231, 1, N'piątek', 10, 1 UNION ALL 
SELECT 238, 232, 1, N'sobota', 10, 1 UNION ALL 
SELECT 239, 233, 1, N'niedziela', 10, 1 UNION ALL 
SELECT 240, 234, 1, N'styczeń', 10, 1 UNION ALL 
SELECT 241, 235, 1, N'luty', 10, 1 UNION ALL 
SELECT 242, 236, 1, N'marzec', 10, 1 UNION ALL 
SELECT 243, 237, 1, N'kwiecień', 10, 1 UNION ALL 
SELECT 244, 238, 1, N'maj', 10, 1 UNION ALL 
SELECT 245, 239, 1, N'czerwiec', 10, 1 UNION ALL 
SELECT 246, 240, 1, N'lipiec', 10, 1 UNION ALL 
SELECT 247, 241, 1, N'sierpień', 10, 1 UNION ALL 
SELECT 248, 242, 1, N'wrzesień', 10, 1 UNION ALL 
SELECT 249, 243, 1, N'październik', 10, 1 UNION ALL 
SELECT 250, 244, 1, N'listopad', 10, 1 UNION ALL 
SELECT 251, 245, 1, N'grudzień', 10, 1 UNION ALL 
SELECT 252, 246, 1, N'rok', 10, 1 UNION ALL 
SELECT 253, 247, 1, N'miesiąc', 10, 1 UNION ALL 
SELECT 254, 248, 1, N'dzień', 10, 1 UNION ALL 
SELECT 255, 249, 1, N'tydzień', 10, 1 UNION ALL 
SELECT 256, 250, 1, N'godzina', 10, 1 UNION ALL 
SELECT 257, 251, 1, N'minuta', 10, 1 UNION ALL 
SELECT 258, 252, 1, N'sekunda', 10, 1 UNION ALL 
SELECT 259, 253, 1, N'weekend', 10, 1 UNION ALL 
SELECT 260, 254, 1, N'jutro', 10, 1 UNION ALL 
SELECT 261, 255, 1, N'dzisiaj', 10, 1 UNION ALL 
SELECT 262, 256, 1, N'wczoraj', 10, 1 UNION ALL 
SELECT 263, 257, 1, N'żółw', 10, 1 UNION ALL 
SELECT 264, 258, 1, N'krokodyl', 10, 1 UNION ALL 
SELECT 265, 259, 1, N'kangur', 10, 1 UNION ALL 
SELECT 266, 260, 1, N'gad', 10, 1 UNION ALL 
SELECT 267, 261, 1, N'płaz', 10, 1 UNION ALL 
SELECT 268, 262, 1, N'ssak', 10, 1 UNION ALL 
SELECT 269, 263, 1, N'robak', 10, 1 UNION ALL 
SELECT 270, 264, 1, N'owad', 10, 1 UNION ALL 
SELECT 271, 265, 1, N'jabłko', 10, 1 UNION ALL 
SELECT 272, 266, 1, N'gruszka', 10, 1 UNION ALL 
SELECT 273, 267, 1, N'wiśnia', 10, 1 UNION ALL 
SELECT 274, 268, 1, N'truskawka', 10, 1 UNION ALL 
SELECT 275, 269, 1, N'ananas', 10, 1 UNION ALL 
SELECT 276, 270, 1, N'pomarańcza', 10, 1 UNION ALL 
SELECT 277, 271, 1, N'czereśnia', 10, 1 UNION ALL 
SELECT 278, 272, 1, N'porzeczka', 10, 1 UNION ALL 
SELECT 279, 273, 1, N'malina', 10, 1 UNION ALL 
SELECT 280, 274, 1, N'banan', 10, 1 UNION ALL 
SELECT 281, 275, 1, N'robić', 10, 1 UNION ALL 
SELECT 282, 276, 1, N'polski', 10, 1 UNION ALL 
SELECT 283, 277, 1, N'ręka', 10, 1 UNION ALL 
SELECT 284, 278, 1, N'płacić', 10, 1 UNION ALL 
SELECT 285, 279, 1, N'szybki', 10, 1 UNION ALL 
SELECT 286, 280, 1, N'mówić', 10, 1 UNION ALL 
SELECT 287, 281, 1, N'czytać', 10, 1 UNION ALL 
SELECT 288, 282, 1, N'zdobywać', 10, 1 UNION ALL 
SELECT 289, 283, 1, N'próbować', 10, 1 UNION ALL 
SELECT 290, 284, 1, N'książka', 10, 1 UNION ALL 
SELECT 291, 285, 1, N'gra', 10, 1 UNION ALL 
SELECT 292, 286, 1, N'produkt', 10, 1 UNION ALL 
SELECT 293, 287, 1, N'samochód', 10, 1 UNION ALL 
SELECT 294, 287, 1, N'auto', 5, 1 UNION ALL 
SELECT 295, 288, 1, N'oprogramowanie', 10, 1 UNION ALL 
SELECT 296, 289, 1, N'gubić', 10, 1 UNION ALL 
SELECT 297, 290, 1, N'golić się', 10, 1 UNION ALL 
SELECT 298, 291, 1, N'spóźnić się', 10, 1 UNION ALL 
SELECT 299, 292, 1, N'dowiadywać się', 10, 1 UNION ALL 
SELECT 300, 293, 1, N'przeziębić się', 10, 1 UNION ALL 
SELECT 301, 294, 1, N'odkręcać', 10, 1 UNION ALL 
SELECT 302, 295, 1, N'zawiązywać', 10, 1 UNION ALL 
SELECT 303, 296, 1, N'nazywać się', 10, 1 UNION ALL 
SELECT 304, 297, 1, N'mieć', 10, 1 UNION ALL 
SELECT 305, 298, 1, N'musieć', 10, 1 UNION ALL 
SELECT 306, 299, 1, N'zauważyć', 10, 1 UNION ALL 
SELECT 307, 300, 1, N'gadać', 10, 1 UNION ALL 
SELECT 308, 301, 1, N'odzyskiwać', 10, 1 UNION ALL 
SELECT 309, 302, 1, N'chcieć', 10, 1 UNION ALL 
SELECT 310, 303, 1, N'dotykać', 10, 1 UNION ALL 
SELECT 311, 304, 1, N'telewizja', 10, 1 UNION ALL 
SELECT 312, 305, 1, N'internet', 10, 1 UNION ALL 
SELECT 313, 306, 1, N'prasa', 10, 1 UNION ALL 
SELECT 314, 307, 1, N'szukać', 10, 1 UNION ALL 
SELECT 315, 308, 1, N'spać', 10, 1 UNION ALL 
SELECT 316, 309, 1, N'rozpoznawać', 10, 1 UNION ALL 
SELECT 317, 310, 1, N'hotel', 10, 1 UNION ALL 
SELECT 318, 311, 1, N'prąd', 10, 1 UNION ALL 
SELECT 319, 312, 1, N'telefon', 10, 1 UNION ALL 
SELECT 320, 313, 1, N'ogrzewanie', 10, 1 UNION ALL 
SELECT 321, 314, 1, N'woda', 10, 1 UNION ALL 
SELECT 322, 315, 1, N'gaz', 10, 1 UNION ALL 
SELECT 323, 316, 1, N'samolot', 10, 1 UNION ALL 
SELECT 324, 317, 1, N'pociąg', 10, 1 UNION ALL 
SELECT 325, 318, 1, N'autobus', 10, 1 UNION ALL 
SELECT 326, 319, 1, N'lekcja', 10, 1 UNION ALL 
SELECT 327, 320, 1, N'dostawać', 10, 1 UNION ALL 
SELECT 328, 321, 1, N'pracować', 10, 1 UNION ALL 
SELECT 329, 322, 1, N'słuchać', 10, 1 UNION ALL 
SELECT 330, 323, 1, N'jeździć', 10, 1 UNION ALL 
SELECT 331, 324, 1, N'mieszkać', 10, 1 UNION ALL 
SELECT 332, 325, 1, N'parkować', 10, 1 UNION ALL 
SELECT 333, 326, 1, N'zarabiać', 10, 1 UNION ALL 
SELECT 334, 327, 1, N'biegać', 10, 1 UNION ALL 
SELECT 335, 328, 1, N'dotrzeć', 10, 1 UNION ALL 
SELECT 336, 329, 1, N'wyławiać', 10, 0 UNION ALL 
SELECT 337, 329, 1, N'wyławiać (z wody)', 10, 1 UNION ALL 
SELECT 338, 330, 1, N'dawać', 10, 1 UNION ALL 
SELECT 339, 331, 1, N'wyglądać', 10, 1 UNION ALL 
SELECT 340, 332, 1, N'morze', 10, 1 UNION ALL 
SELECT 341, 333, 1, N'jezioro', 10, 1 UNION ALL 
SELECT 342, 334, 1, N'plaża', 10, 1 UNION ALL 
SELECT 343, 335, 1, N'sam', 10, 1 UNION ALL 
SELECT 344, 336, 1, N'słyszeć', 10, 1 UNION ALL 
SELECT 345, 337, 1, N'czuć', 10, 1 UNION ALL 
SELECT 346, 338, 1, N'oczekiwać', 10, 1 UNION ALL 
SELECT 347, 339, 1, N'informować', 10, 1 UNION ALL 
SELECT 348, 340, 1, N'uczyć się', 10, 1 UNION ALL 
SELECT 349, 341, 1, N'angielski', 10, 1 UNION ALL 
SELECT 350, 342, 1, N'hiszpański', 10, 1 UNION ALL 
SELECT 351, 343, 1, N'francuski', 10, 1 UNION ALL 
SELECT 352, 344, 1, N'rosyjski', 10, 1 UNION ALL 
SELECT 353, 345, 1, N'włoski', 10, 1 UNION ALL 
SELECT 354, 346, 1, N'portugalski', 10, 1 UNION ALL 
SELECT 355, 347, 1, N'arabski', 10, 1 UNION ALL 
SELECT 356, 348, 1, N'japoński', 10, 1 UNION ALL 
SELECT 357, 349, 1, N'chiński', 10, 1 UNION ALL 
SELECT 358, 350, 1, N'czeski', 10, 1 UNION ALL 
SELECT 359, 351, 1, N'reagować', 10, 1 UNION ALL 
SELECT 360, 352, 1, N'płakać', 10, 1 UNION ALL 
SELECT 361, 353, 1, N'myśleć', 10, 1 UNION ALL 
SELECT 362, 354, 1, N'zachowywać się', 10, 1 UNION ALL 
SELECT 363, 355, 1, N'ładny', 10, 1 UNION ALL 
SELECT 364, 356, 1, N'gruziński', 10, 1 UNION ALL 
SELECT 365, 357, 1, N'koreański', 10, 1 UNION ALL 
SELECT 366, 358, 1, N'wietnamski', 10, 1 UNION ALL 
SELECT 367, 359, 1, N'grecki', 10, 1 UNION ALL 
SELECT 368, 360, 1, N'bułgarski', 10, 1 UNION ALL 
SELECT 369, 361, 1, N'albański', 10, 1 UNION ALL 
SELECT 370, 362, 1, N'chorwacki', 10, 1 UNION ALL 
SELECT 371, 363, 1, N'szwajcarski', 10, 1 UNION ALL 
SELECT 372, 364, 1, N'austriacki', 10, 1 UNION ALL 
SELECT 373, 365, 1, N'australijski', 10, 1 UNION ALL 
SELECT 374, 366, 1, N'meksykański', 10, 1 UNION ALL 
SELECT 375, 367, 1, N'brazylijski', 10, 1 UNION ALL 
SELECT 376, 368, 1, N'argentyński', 10, 1 UNION ALL 
SELECT 377, 369, 1, N'kolumbijski', 10, 1 UNION ALL 
SELECT 378, 370, 1, N'kanadyjski', 10, 1 UNION ALL 
SELECT 379, 371, 1, N'amerykański', 10, 1 UNION ALL 
SELECT 380, 372, 1, N'irlandzki', 10, 1 UNION ALL 
SELECT 381, 373, 1, N'szkocki', 10, 1 UNION ALL 
SELECT 382, 374, 1, N'walijski', 10, 1 UNION ALL 
SELECT 383, 375, 1, N'islandzki', 10, 1 UNION ALL 
SELECT 384, 376, 1, N'duński', 10, 1 UNION ALL 
SELECT 385, 377, 1, N'norweski', 10, 1 UNION ALL 
SELECT 386, 378, 1, N'szwedzki', 10, 1 UNION ALL 
SELECT 387, 379, 1, N'fiński', 10, 1 UNION ALL 
SELECT 388, 380, 1, N'estoński', 10, 1 UNION ALL 
SELECT 389, 381, 1, N'łotewski', 10, 1 UNION ALL 
SELECT 390, 382, 1, N'litewski', 10, 1 UNION ALL 
SELECT 391, 383, 1, N'holenderski', 10, 1 UNION ALL 
SELECT 392, 383, 1, N'niderlandzki', 10, 1 UNION ALL 
SELECT 393, 384, 1, N'belgijski', 10, 1 UNION ALL 
SELECT 394, 385, 1, N'słowacki', 10, 1 UNION ALL 
SELECT 395, 386, 1, N'węgierski', 10, 1 UNION ALL 
SELECT 396, 387, 1, N'rumuński', 10, 1 UNION ALL 
SELECT 397, 388, 1, N'serbski', 10, 1 UNION ALL 
SELECT 398, 389, 1, N'macedoński', 10, 1 UNION ALL 
SELECT 399, 390, 1, N'bośniacki', 10, 1 UNION ALL 
SELECT 400, 391, 1, N'słoweński', 10, 1 UNION ALL 
SELECT 401, 392, 1, N'czarnogórski', 10, 1 UNION ALL 
SELECT 402, 393, 1, N'białoruski', 10, 1 UNION ALL 
SELECT 403, 394, 1, N'ukraiński', 10, 1 UNION ALL 
SELECT 404, 395, 1, N'mołdawski', 10, 1 UNION ALL 
SELECT 405, 396, 1, N'peruwiański', 10, 1 UNION ALL 
SELECT 406, 397, 1, N'chilijski', 10, 1 UNION ALL 
SELECT 407, 398, 1, N'wenezuelski', 10, 1 UNION ALL 
SELECT 408, 399, 1, N'urugwajski', 10, 1 UNION ALL 
SELECT 409, 400, 1, N'paragwajski', 10, 1 UNION ALL 
SELECT 410, 401, 1, N'ekwadorski', 10, 1 UNION ALL 
SELECT 411, 402, 1, N'boliwijski', 10, 1 UNION ALL 
SELECT 412, 403, 1, N'surinamski', 10, 1 UNION ALL 
SELECT 413, 404, 1, N'gujański', 10, 1 UNION ALL 
SELECT 414, 405, 1, N'ormiański', 10, 1 UNION ALL 
SELECT 415, 406, 1, N'azerbejdżański', 10, 1 UNION ALL 
SELECT 416, 407, 1, N'turecki', 10, 1 UNION ALL 
SELECT 417, 408, 1, N'jamajski', 10, 1 UNION ALL 
SELECT 418, 409, 1, N'grenlandzki', 10, 1 UNION ALL 
SELECT 419, 410, 1, N'algierski', 10, 1 UNION ALL 
SELECT 420, 411, 1, N'marokański', 10, 1 UNION ALL 
SELECT 421, 412, 1, N'etiopski', 10, 1 UNION ALL 
SELECT 422, 413, 1, N'kenijski', 10, 1 UNION ALL 
SELECT 423, 414, 1, N'malgaski', 10, 1 UNION ALL 
SELECT 424, 415, 1, N'somalijski', 10, 1 UNION ALL 
SELECT 425, 416, 1, N'angolski', 10, 1 UNION ALL 
SELECT 426, 417, 1, N'kameruński', 10, 1 UNION ALL 
SELECT 427, 418, 1, N'gaboński', 10, 1 UNION ALL 
SELECT 428, 419, 1, N'egipski', 10, 1 UNION ALL 
SELECT 429, 420, 1, N'libijski', 10, 1 UNION ALL 
SELECT 430, 421, 1, N'sudański', 10, 1 UNION ALL 
SELECT 431, 422, 1, N'tunezyjski', 10, 1 UNION ALL 
SELECT 432, 423, 1, N'południowoafrykański', 10, 1 UNION ALL 
SELECT 433, 424, 1, N'senegalski', 10, 1 UNION ALL 
SELECT 434, 425, 1, N'nigeryjski', 10, 1 UNION ALL 
SELECT 435, 426, 1, N'nowozelandzki', 10, 1 UNION ALL 
SELECT 436, 427, 1, N'wstawać', 10, 1 UNION ALL 
SELECT 437, 428, 1, N'irański', 10, 1 UNION ALL 
SELECT 438, 429, 1, N'perski', 10, 1 UNION ALL 
SELECT 439, 430, 1, N'iracki', 10, 1 UNION ALL 
SELECT 440, 431, 1, N'pakistański', 10, 1 UNION ALL 
SELECT 441, 432, 1, N'syryjski', 10, 1 UNION ALL 
SELECT 442, 433, 1, N'hinduski', 10, 1 UNION ALL 
SELECT 443, 434, 1, N'libański', 10, 1 UNION ALL 
SELECT 444, 435, 1, N'tajski', 10, 1 UNION ALL 
SELECT 445, 436, 1, N'mongolski', 10, 1 UNION ALL 
SELECT 446, 437, 1, N'twierdzić', 10, 1 UNION ALL 
SELECT 447, 438, 1, N'zamierzać', 10, 1 UNION ALL 
SELECT 448, 439, 1, N'przeżyć', 10, 0 UNION ALL 
SELECT 449, 439, 1, N'przetrwać', 10, 0 UNION ALL 
SELECT 450, 439, 1, N'przeżyć, przetrwać', 10, 1 UNION ALL 
SELECT 451, 440, 1, N'rodzić się', 10, 1 UNION ALL 
SELECT 452, 441, 1, N'jeden', 10, 1 UNION ALL 
SELECT 453, 442, 1, N'dwa', 10, 1 UNION ALL 
SELECT 454, 443, 1, N'trzy', 10, 1 UNION ALL 
SELECT 455, 444, 1, N'cztery', 10, 1 UNION ALL 
SELECT 456, 445, 1, N'pięć', 10, 1 UNION ALL 
SELECT 457, 446, 1, N'sześć', 10, 1 UNION ALL 
SELECT 458, 447, 1, N'szpital', 10, 1 UNION ALL 
SELECT 459, 448, 1, N'szkoła', 10, 1 UNION ALL 
SELECT 460, 449, 1, N'poczta', 10, 1 UNION ALL 
SELECT 461, 450, 1, N'policja', 10, 1 UNION ALL 
SELECT 462, 451, 1, N'wygrywać', 10, 1 UNION ALL 
SELECT 463, 452, 1, N'Oscar', 10, 1 UNION ALL 
SELECT 464, 453, 1, N'Nagroda Nobla', 10, 1 UNION ALL 
SELECT 465, 454, 1, N'strażak', 10, 1 UNION ALL 
SELECT 466, 455, 1, N'lekarz', 10, 1 UNION ALL 
SELECT 467, 456, 1, N'policjant', 10, 1 UNION ALL 
SELECT 468, 457, 1, N'nauczyciel', 10, 1 UNION ALL 
SELECT 469, 458, 1, N'taksówkarz', 10, 1 UNION ALL 
SELECT 470, 459, 1, N'kierowca', 10, 1 UNION ALL 
SELECT 471, 460, 1, N'mieszkanie', 10, 1 UNION ALL 
SELECT 472, 461, 1, N'pokój', 10, 1 UNION ALL 
SELECT 473, 462, 1, N'drzwi', 10, 1 UNION ALL 
SELECT 474, 463, 1, N'okno', 10, 1 UNION ALL 
SELECT 475, 464, 1, N'jeść', 10, 1 UNION ALL 
SELECT 476, 465, 1, N'śniadanie', 10, 1 UNION ALL 
SELECT 477, 466, 1, N'obiad', 10, 1 UNION ALL 
SELECT 478, 467, 1, N'żyć', 10, 1 UNION ALL 
SELECT 479, 468, 1, N'zaczynać się', 10, 1 UNION ALL 
SELECT 480, 469, 1, N'tracić', 10, 1 UNION ALL 
SELECT 481, 470, 1, N'wiedzieć', 10, 1 UNION ALL 
SELECT 482, 471, 1, N'stresować się', 10, 1 UNION ALL 
SELECT 483, 472, 1, N'głosować', 10, 1 UNION ALL 
SELECT 484, 473, 1, N'ten', 10, 1 UNION ALL 
SELECT 485, 474, 1, N'dom', 10, 1 UNION ALL 
SELECT 486, 475, 1, N'brzeg', 10, 0 UNION ALL 
SELECT 487, 475, 1, N'brzeg (jeziora, morza)', 10, 1 UNION ALL 
SELECT 488, 475, 1, N'wybrzeże', 10, 0 UNION ALL 
SELECT 489, 476, 1, N'ukrywać', 10, 1 UNION ALL 
SELECT 490, 477, 1, N'iść', 10, 1 UNION ALL 
SELECT 491, 478, 1, N'siedzieć', 10, 1 UNION ALL 
SELECT 492, 479, 1, N'brać', 10, 1 UNION ALL 
SELECT 493, 479, 1, N'wziąć', 10, 1 UNION ALL 
SELECT 494, 480, 1, N'śmiać się', 10, 1 UNION ALL 
SELECT 495, 481, 1, N'las', 10, 1 UNION ALL 
SELECT 496, 482, 1, N'lotnisko', 10, 1 UNION ALL 
SELECT 497, 483, 1, N'rzeka', 10, 1 UNION ALL 
SELECT 498, 484, 1, N'taksówka', 10, 1 UNION ALL 
SELECT 499, 485, 1, N'powstrzymywać', 10, 1 UNION ALL 
SELECT 500, 486, 1, N'prosić', 10, 1 UNION ALL 
SELECT 501, 487, 1, N'uznawać', 10, 1 UNION ALL 
SELECT 502, 488, 1, N'budzić się', 10, 1 UNION ALL 
SELECT 503, 489, 1, N'grozić', 10, 1 UNION ALL 
SELECT 504, 490, 1, N'wywiad', 10, 1 UNION ALL 
SELECT 505, 491, 1, N'spotkanie', 10, 1 UNION ALL 
SELECT 506, 492, 1, N'debata', 10, 1 UNION ALL 
SELECT 507, 493, 1, N'widzieć', 10, 1 UNION ALL 
SELECT 508, 494, 1, N'znajdować', 10, 1 UNION ALL 
SELECT 509, 495, 1, N'portfel', 10, 1 UNION ALL 
SELECT 510, 496, 1, N'klucz', 10, 1 UNION ALL 
SELECT 511, 497, 1, N'karta kredytowa', 10, 1 UNION ALL 
SELECT 512, 498, 1, N'lot', 10, 1 UNION ALL 
SELECT 513, 499, 1, N'prezent', 10, 1 UNION ALL 
SELECT 514, 500, 1, N'odpowiedź', 10, 1 UNION ALL 
SELECT 515, 501, 1, N'to', 10, 1 UNION ALL 
SELECT 516, 502, 1, N'komputer', 10, 1 UNION ALL 
SELECT 517, 503, 1, N'przypuszczać', 10, 1 UNION ALL 
SELECT 518, 504, 1, N'gazeta', 10, 1 UNION ALL 
SELECT 519, 505, 1, N'dokument', 10, 1 UNION ALL 
SELECT 520, 506, 1, N'wiersz', 10, 1 UNION ALL 
SELECT 521, 507, 1, N'pisać', 10, 1 UNION ALL 
SELECT 522, 508, 1, N'stół', 10, 1 UNION ALL 
SELECT 523, 509, 1, N'krzesło', 10, 1 UNION ALL 
SELECT 524, 510, 1, N'podłoga', 10, 1 UNION ALL 
SELECT 525, 511, 1, N'łóżko', 10, 1 UNION ALL 
SELECT 526, 512, 1, N'kontaktować się', 10, 1 UNION ALL 
SELECT 527, 513, 1, N'spotykać', 10, 1 UNION ALL 
SELECT 528, 514, 1, N'uderzać', 10, 1 UNION ALL 
SELECT 529, 515, 1, N'czekać', 10, 1 UNION ALL 
SELECT 530, 516, 1, N'znać', 10, 1 UNION ALL 
SELECT 531, 517, 1, N'wyjeżdżać', 10, 1 UNION ALL 
SELECT 532, 518, 1, N'rozmawiać', 10, 1 UNION ALL 
SELECT 533, 519, 1, N'nosić', 10, 0 UNION ALL 
SELECT 534, 519, 1, N'nosić (ubrania)', 10, 1 UNION ALL 
SELECT 535, 520, 1, N'brakować', 10, 1 UNION ALL 
SELECT 536, 521, 1, N'jakiś', 10, 1 UNION ALL 
SELECT 537, 522, 1, N'zbrodnia', 10, 1 UNION ALL 
SELECT 538, 523, 1, N'przestępstwo', 10, 1 UNION ALL 
SELECT 539, 524, 1, N'groźba', 10, 1 UNION ALL 
SELECT 540, 525, 1, N'żart', 10, 1 UNION ALL 
SELECT 541, 526, 1, N'koncert', 10, 1 UNION ALL 
SELECT 542, 527, 1, N'Średniowiecze', 10, 1 UNION ALL 
SELECT 543, 528, 1, N'wojna domowa', 10, 1 UNION ALL 
SELECT 544, 529, 1, N'finał', 10, 1 UNION ALL 
SELECT 545, 530, 1, N'tamten', 10, 1 UNION ALL 
SELECT 546, 531, 1, N'życie', 10, 1 UNION ALL 
SELECT 547, 532, 1, N'przybywać', 10, 1 UNION ALL 
SELECT 548, 533, 1, N'skorpion', 10, 1 UNION ALL 
SELECT 549, 534, 1, N'płaszczka', 10, 1 UNION ALL 
SELECT 550, 535, 1, N'meduza', 10, 1 UNION ALL 
SELECT 551, 536, 1, N'szerszeń', 10, 1 UNION ALL 
SELECT 552, 537, 1, N'kleszcz', 10, 1 UNION ALL 
SELECT 553, 538, 1, N'grzechotnik', 10, 1 UNION ALL 
SELECT 554, 539, 1, N'żmija', 10, 1 UNION ALL 
SELECT 555, 540, 1, N'dowód', 10, 1 UNION ALL 
SELECT 556, 541, 1, N'dane', 10, 1 UNION ALL 
SELECT 557, 542, 1, N'statystyka', 10, 1 UNION ALL 
SELECT 558, 543, 1, N'siedem', 10, 1 UNION ALL 
SELECT 559, 544, 1, N'osiem', 10, 1 UNION ALL 
SELECT 560, 545, 1, N'skóra', 10, 1 UNION ALL 
SELECT 561, 546, 1, N'miejsce', 10, 1 UNION ALL 
SELECT 562, 547, 1, N'wierzyć', 10, 1 UNION ALL 
SELECT 563, 548, 1, N'potrzebować', 10, 1 UNION ALL 
SELECT 564, 549, 1, N'lubić', 10, 1 UNION ALL 
SELECT 565, 550, 1, N'jedyny', 10, 1 UNION ALL 
SELECT 566, 551, 1, N'ujęcie (zdjęcia)', 10, 1 UNION ALL 
SELECT 567, 551, 1, N'ujęcie', 10, 0 UNION ALL 
SELECT 568, 552, 1, N'wyjaśnienie', 10, 1 UNION ALL 
SELECT 569, 553, 1, N'powód', 10, 1 UNION ALL 
SELECT 570, 554, 1, N'szansa', 10, 1 UNION ALL 
SELECT 571, 554, 1, N'okazja', 10, 1 UNION ALL 
SELECT 572, 555, 1, N'osoba', 10, 1 UNION ALL 
SELECT 573, 556, 1, N'pytanie', 10, 1 UNION ALL 
SELECT 574, 557, 1, N'wymóg', 10, 1 UNION ALL 
SELECT 575, 558, 1, N'różnica', 10, 1 UNION ALL 
SELECT 576, 559, 1, N'problem', 10, 1 UNION ALL 
SELECT 577, 560, 1, N'wybór', 10, 1 UNION ALL 
SELECT 578, 561, 1, N'mapa', 10, 1 UNION ALL 
SELECT 579, 562, 1, N'wykres', 10, 1 UNION ALL 
SELECT 580, 563, 1, N'założenie', 10, 1 UNION ALL 
SELECT 581, 564, 1, N'wynik (gry, meczu)', 10, 1 UNION ALL 
SELECT 582, 564, 1, N'wynik', 10, 0 UNION ALL 
SELECT 583, 565, 1, N'wynik (badania, pomiaru)', 10, 1 UNION ALL 
SELECT 584, 565, 1, N'wynik', 10, 0 UNION ALL 
SELECT 585, 566, 1, N'zdjęcie', 10, 0 UNION ALL 
SELECT 586, 566, 1, N'fotografia', 10, 0 UNION ALL 
SELECT 587, 566, 1, N'zdjęcie, fotografia', 10, 1 UNION ALL 
SELECT 588, 567, 1, N'młotek', 10, 1 UNION ALL 
SELECT 589, 568, 1, N'lina', 10, 1 UNION ALL 
SELECT 590, 569, 1, N'odwaga', 10, 1 UNION ALL 
SELECT 591, 570, 1, N'przyjaciel', 10, 1 UNION ALL 
SELECT 592, 571, 1, N'zabierać', 10, 1 UNION ALL 
SELECT 593, 572, 1, N'region', 10, 1 UNION ALL 
SELECT 594, 573, 1, N'miasto', 10, 1 UNION ALL 
SELECT 595, 574, 1, N'głowa', 10, 1 UNION ALL 
SELECT 596, 575, 1, N'noga', 10, 1 UNION ALL 
SELECT 597, 576, 1, N'brzuch', 10, 1 UNION ALL 
SELECT 598, 577, 1, N'włos', 10, 1 UNION ALL 
SELECT 599, 578, 1, N'oko', 10, 1 UNION ALL 
SELECT 600, 579, 1, N'ucho', 10, 1 UNION ALL 
SELECT 601, 580, 1, N'nos', 10, 1 UNION ALL 
SELECT 602, 581, 1, N'paznokieć', 10, 1 UNION ALL 
SELECT 603, 582, 1, N'palec (od ręki)', 10, 1 UNION ALL 
SELECT 604, 582, 1, N'palec', 10, 0 UNION ALL 
SELECT 605, 583, 1, N'ramię', 10, 1 UNION ALL 
SELECT 606, 584, 1, N'szyja', 10, 1 UNION ALL 
SELECT 607, 585, 1, N'usta', 10, 1 UNION ALL 
SELECT 608, 586, 1, N'ząb', 10, 1 UNION ALL 
SELECT 609, 587, 1, N'język', 10, 1 UNION ALL 
SELECT 610, 588, 1, N'serce', 10, 1 UNION ALL 
SELECT 611, 589, 1, N'wątroba', 10, 1 UNION ALL 
SELECT 612, 590, 1, N'żołądek', 10, 1 UNION ALL 
SELECT 613, 591, 1, N'kolano', 10, 1 UNION ALL 
SELECT 614, 592, 1, N'łokieć', 10, 1 UNION ALL 
SELECT 615, 593, 1, N'stopa', 10, 1 UNION ALL 
SELECT 616, 594, 1, N'pięta', 10, 1 UNION ALL 
SELECT 617, 595, 1, N'policzek', 10, 1 UNION ALL 
SELECT 618, 596, 1, N'brew', 10, 1 UNION ALL 
SELECT 619, 597, 1, N'rzęsa', 10, 1 UNION ALL 
SELECT 620, 598, 1, N'powieka', 10, 1 UNION ALL 
SELECT 621, 599, 1, N'czoło', 10, 1 UNION ALL 
SELECT 622, 600, 1, N'kręgosłup', 10, 1 UNION ALL 
SELECT 623, 601, 1, N'płuco', 10, 1 UNION ALL 
SELECT 624, 602, 1, N'żyła', 10, 1 UNION ALL 
SELECT 625, 603, 1, N'krew', 10, 1 UNION ALL 
SELECT 626, 604, 1, N'gardło', 10, 1 UNION ALL 
SELECT 627, 605, 1, N'mózg', 10, 1 UNION ALL 
SELECT 628, 606, 1, N'mysz', 10, 1 UNION ALL 
SELECT 629, 607, 1, N'szczur', 10, 1 UNION ALL 
SELECT 630, 608, 1, N'Bałkany', 10, 1 UNION ALL 
SELECT 631, 609, 1, N'palec (od nogi)', 10, 1 UNION ALL 
SELECT 632, 609, 1, N'palec', 10, 0 UNION ALL 
SELECT 633, 610, 1, N'tamto', 10, 1 UNION ALL 
SELECT 634, 2, 2, N'Poland', 10, 1 UNION ALL 
SELECT 635, 3, 2, N'dog', 10, 1 UNION ALL 
SELECT 636, 4, 2, N'Italy', 10, 1 UNION ALL 
SELECT 637, 5, 2, N'Spain', 10, 1 UNION ALL 
SELECT 638, 6, 2, N'France', 10, 1 UNION ALL 
SELECT 639, 7, 2, N'Germany', 10, 1 UNION ALL 
SELECT 640, 8, 2, N'England', 10, 1 UNION ALL 
SELECT 641, 9, 2, N'Russia', 10, 1 UNION ALL 
SELECT 642, 10, 2, N'Albania', 10, 1 UNION ALL 
SELECT 643, 11, 2, N'Andorra', 10, 1 UNION ALL 
SELECT 644, 12, 2, N'Armenia', 10, 1 UNION ALL 
SELECT 645, 13, 2, N'Austria', 10, 1 UNION ALL 
SELECT 646, 14, 2, N'Azerbaijan', 10, 1 UNION ALL 
SELECT 647, 15, 2, N'Belarus', 10, 1 UNION ALL 
SELECT 648, 16, 2, N'Belgium', 10, 1 UNION ALL 
SELECT 649, 17, 2, N'Bosnia & Herzegovina', 10, 1 UNION ALL 
SELECT 650, 17, 2, N'Bosnia and Herzegovina', 10, 1 UNION ALL 
SELECT 651, 17, 2, N'Bosnia-Herzegovina', 10, 0 UNION ALL 
SELECT 652, 17, 2, N'Bosnia', 5, 0 UNION ALL 
SELECT 653, 18, 2, N'Bulgaria', 10, 1 UNION ALL 
SELECT 654, 19, 2, N'Croatia', 10, 1 UNION ALL 
SELECT 655, 20, 2, N'Cyprus', 10, 1 UNION ALL 
SELECT 656, 21, 2, N'the Czech Republic', 10, 1 UNION ALL 
SELECT 657, 22, 2, N'Denmark', 10, 1 UNION ALL 
SELECT 658, 23, 2, N'Estonia', 10, 1 UNION ALL 
SELECT 659, 24, 2, N'Finland', 10, 1 UNION ALL 
SELECT 660, 25, 2, N'Georgia', 10, 1 UNION ALL 
SELECT 661, 26, 2, N'Greece', 10, 1 UNION ALL 
SELECT 662, 27, 2, N'Hungary', 10, 1 UNION ALL 
SELECT 663, 28, 2, N'Iceland', 10, 1 UNION ALL 
SELECT 664, 29, 2, N'Ireland', 10, 1 UNION ALL 
SELECT 665, 30, 2, N'Kazakhstan', 10, 1 UNION ALL 
SELECT 666, 31, 2, N'Latvia', 10, 1 UNION ALL 
SELECT 667, 32, 2, N'Liechtenstein', 10, 1 UNION ALL 
SELECT 668, 33, 2, N'Lithuania', 10, 1 UNION ALL 
SELECT 669, 34, 2, N'Luxembourg', 10, 1 UNION ALL 
SELECT 670, 35, 2, N'Macedonia', 10, 1 UNION ALL 
SELECT 671, 36, 2, N'Malta', 10, 1 UNION ALL 
SELECT 672, 37, 2, N'Moldova', 10, 1 UNION ALL 
SELECT 673, 38, 2, N'Monaco', 10, 1 UNION ALL 
SELECT 674, 39, 2, N'Montenegro', 10, 1 UNION ALL 
SELECT 675, 40, 2, N'the Netherlands', 10, 1 UNION ALL 
SELECT 676, 41, 2, N'Norway', 10, 1 UNION ALL 
SELECT 677, 42, 2, N'Portugal', 10, 1 UNION ALL 
SELECT 678, 43, 2, N'Romania', 10, 1 UNION ALL 
SELECT 679, 44, 2, N'San Marino', 10, 1 UNION ALL 
SELECT 680, 45, 2, N'Serbia', 10, 1 UNION ALL 
SELECT 681, 46, 2, N'Slovakia', 10, 1 UNION ALL 
SELECT 682, 47, 2, N'Slovenia', 10, 1 UNION ALL 
SELECT 683, 48, 2, N'Sweden', 10, 1 UNION ALL 
SELECT 684, 49, 2, N'Switzerland', 10, 1 UNION ALL 
SELECT 685, 50, 2, N'Turkey', 10, 1 UNION ALL 
SELECT 686, 51, 2, N'Ukraine', 10, 1 UNION ALL 
SELECT 687, 52, 2, N'the United Kingdom', 10, 1 UNION ALL 
SELECT 688, 52, 2, N'the UK', 10, 1 UNION ALL 
SELECT 689, 53, 2, N'Vatican City', 10, 1 UNION ALL 
SELECT 690, 54, 2, N'Scotland', 10, 1 UNION ALL 
SELECT 691, 55, 2, N'Brazil', 10, 1 UNION ALL 
SELECT 692, 56, 2, N'Argentina', 10, 1 UNION ALL 
SELECT 693, 57, 2, N'Peru', 10, 1 UNION ALL 
SELECT 694, 58, 2, N'Bolivia', 10, 1 UNION ALL 
SELECT 695, 59, 2, N'Chile', 10, 1 UNION ALL 
SELECT 696, 60, 2, N'Colombia', 10, 1 UNION ALL 
SELECT 697, 61, 2, N'Venezuela', 10, 1 UNION ALL 
SELECT 698, 62, 2, N'Uruguay', 10, 1 UNION ALL 
SELECT 699, 63, 2, N'Paraguay', 10, 1 UNION ALL 
SELECT 700, 64, 2, N'Ecuador', 10, 1 UNION ALL 
SELECT 701, 65, 2, N'China', 10, 1 UNION ALL 
SELECT 702, 66, 2, N'Japan', 10, 1 UNION ALL 
SELECT 703, 67, 2, N'India', 10, 1 UNION ALL 
SELECT 704, 68, 2, N'Thailand', 10, 1 UNION ALL 
SELECT 705, 69, 2, N'Israel', 10, 1 UNION ALL 
SELECT 706, 70, 2, N'Lebanon', 10, 1 UNION ALL 
SELECT 707, 71, 2, N'Jordan', 10, 1 UNION ALL 
SELECT 708, 72, 2, N'Syria', 10, 1 UNION ALL 
SELECT 709, 73, 2, N'Saudi Arabia', 10, 1 UNION ALL 
SELECT 710, 74, 2, N'Yemen', 10, 1 UNION ALL 
SELECT 711, 75, 2, N'Oman', 10, 1 UNION ALL 
SELECT 712, 76, 2, N'the United Arab Emirates', 10, 1 UNION ALL 
SELECT 713, 76, 2, N'the UAE', 10, 0 UNION ALL 
SELECT 714, 76, 2, N'the Emirates', 10, 1 UNION ALL 
SELECT 715, 77, 2, N'Kuwait', 10, 1 UNION ALL 
SELECT 716, 78, 2, N'Bahrain', 10, 1 UNION ALL 
SELECT 717, 79, 2, N'Qatar', 10, 1 UNION ALL 
SELECT 718, 80, 2, N'Iraq', 10, 1 UNION ALL 
SELECT 719, 81, 2, N'Iran', 10, 1 UNION ALL 
SELECT 720, 82, 2, N'Afghanistan', 10, 1 UNION ALL 
SELECT 721, 83, 2, N'Pakistan', 10, 1 UNION ALL 
SELECT 722, 84, 2, N'Uzbekistan', 10, 1 UNION ALL 
SELECT 723, 85, 2, N'Turkmenistan', 10, 1 UNION ALL 
SELECT 724, 86, 2, N'Tajikistan', 10, 1 UNION ALL 
SELECT 725, 87, 2, N'Kyrgyzstan', 10, 1 UNION ALL 
SELECT 726, 88, 2, N'Nepal', 10, 1 UNION ALL 
SELECT 727, 89, 2, N'Bhutan', 10, 1 UNION ALL 
SELECT 728, 90, 2, N'Bangladesh', 10, 1 UNION ALL 
SELECT 729, 91, 2, N'Sri Lanka', 10, 1 UNION ALL 
SELECT 730, 92, 2, N'Mongolia', 10, 1 UNION ALL 
SELECT 731, 93, 2, N'Laos', 10, 1 UNION ALL 
SELECT 732, 94, 2, N'Cambodia', 10, 1 UNION ALL 
SELECT 733, 95, 2, N'Vietnam', 10, 1 UNION ALL 
SELECT 734, 96, 2, N'Myanmar', 10, 1 UNION ALL 
SELECT 735, 96, 2, N'Burma', 10, 0 UNION ALL 
SELECT 736, 97, 2, N'South Korea', 10, 1 UNION ALL 
SELECT 737, 98, 2, N'North Korea', 10, 1 UNION ALL 
SELECT 738, 99, 2, N'Malaysia', 10, 1 UNION ALL 
SELECT 739, 100, 2, N'Indonesia', 10, 1 UNION ALL 
SELECT 740, 101, 2, N'the Philippines', 10, 1 UNION ALL 
SELECT 741, 102, 2, N'Taiwan', 10, 1 UNION ALL 
SELECT 742, 103, 2, N'Hongkong', 10, 1 UNION ALL 
SELECT 743, 104, 2, N'Singapur', 10, 1 UNION ALL 
SELECT 744, 105, 2, N'Australia', 10, 1 UNION ALL 
SELECT 745, 106, 2, N'New Zealand', 10, 1 UNION ALL 
SELECT 746, 107, 2, N'Fiji', 10, 1 UNION ALL 
SELECT 747, 108, 2, N'Egypt', 10, 1 UNION ALL 
SELECT 748, 109, 2, N'Libya', 10, 1 UNION ALL 
SELECT 749, 110, 2, N'Tunisia', 10, 1 UNION ALL 
SELECT 750, 111, 2, N'Morocco', 10, 1 UNION ALL 
SELECT 751, 112, 2, N'Algeria', 10, 1 UNION ALL 
SELECT 752, 113, 2, N'Sudan', 10, 1 UNION ALL 
SELECT 753, 114, 2, N'Ethiopia', 10, 1 UNION ALL 
SELECT 754, 115, 2, N'Eritrea', 10, 1 UNION ALL 
SELECT 755, 116, 2, N'Djibuti', 10, 1 UNION ALL 
SELECT 756, 117, 2, N'Chad', 10, 1 UNION ALL 
SELECT 757, 118, 2, N'Mauretania', 10, 1 UNION ALL 
SELECT 758, 119, 2, N'Burkina Faso', 10, 1 UNION ALL 
SELECT 759, 120, 2, N'Mali', 10, 1 UNION ALL 
SELECT 760, 121, 2, N'Senegal', 10, 1 UNION ALL 
SELECT 761, 122, 2, N'Gambia', 10, 1 UNION ALL 
SELECT 762, 123, 2, N'Guinea', 10, 1 UNION ALL 
SELECT 763, 124, 2, N'Ghana', 10, 1 UNION ALL 
SELECT 764, 125, 2, N'Somalia', 10, 1 UNION ALL 
SELECT 765, 126, 2, N'Ivory Coast', 10, 1 UNION ALL 
SELECT 766, 127, 2, N'Togo', 10, 1 UNION ALL 
SELECT 767, 128, 2, N'Liberia', 10, 1 UNION ALL 
SELECT 768, 129, 2, N'Sierra Leone', 10, 1 UNION ALL 
SELECT 769, 130, 2, N'Niger', 10, 1 UNION ALL 
SELECT 770, 131, 2, N'Nigeria', 10, 1 UNION ALL 
SELECT 771, 132, 2, N'Cameroon', 10, 1 UNION ALL 
SELECT 772, 133, 2, N'Gabon', 10, 1 UNION ALL 
SELECT 773, 134, 2, N'Congo', 10, 1 UNION ALL 
SELECT 774, 135, 2, N'the Democratic Republic of Congo', 10, 1 UNION ALL 
SELECT 775, 135, 2, N'DR Congo', 9, 1 UNION ALL 
SELECT 776, 135, 2, N'DRC', 8, 0 UNION ALL 
SELECT 777, 135, 2, N'Congo-Kinshasa', 5, 0 UNION ALL 
SELECT 778, 135, 2, N'Congo-Zaire', 5, 0 UNION ALL 
SELECT 779, 135, 2, N'DROC', 2, 0 UNION ALL 
SELECT 780, 136, 2, N'Uganda', 10, 1 UNION ALL 
SELECT 781, 137, 2, N'Burundi', 10, 1 UNION ALL 
SELECT 782, 138, 2, N'Kenya', 10, 1 UNION ALL 
SELECT 783, 139, 2, N'Tanzania', 10, 1 UNION ALL 
SELECT 784, 140, 2, N'Mozambique', 10, 1 UNION ALL 
SELECT 785, 141, 2, N'Rwanda', 10, 1 UNION ALL 
SELECT 786, 142, 2, N'Madagascar', 10, 1 UNION ALL 
SELECT 787, 143, 2, N'Angola', 10, 1 UNION ALL 
SELECT 788, 144, 2, N'Namibia', 10, 1 UNION ALL 
SELECT 789, 145, 2, N'South Africa', 10, 1 UNION ALL 
SELECT 790, 146, 2, N'Zambia', 10, 1 UNION ALL 
SELECT 791, 147, 2, N'Zimbabwe', 10, 1 UNION ALL 
SELECT 792, 148, 2, N'Botswana', 10, 1 UNION ALL 
SELECT 793, 149, 2, N'the Seychelles', 10, 1 UNION ALL 
SELECT 794, 150, 2, N'Mauritius', 10, 1 UNION ALL 
SELECT 795, 151, 2, N'the USA', 10, 1 UNION ALL 
SELECT 796, 151, 2, N'the United States', 10, 1 UNION ALL 
SELECT 797, 152, 2, N'Canada', 10, 1 UNION ALL 
SELECT 798, 153, 2, N'Mexico', 10, 1 UNION ALL 
SELECT 799, 154, 2, N'Greenland', 10, 1 UNION ALL 
SELECT 800, 155, 2, N'Jamaica', 10, 1 UNION ALL 
SELECT 801, 156, 2, N'Cuba', 10, 1 UNION ALL 
SELECT 802, 157, 2, N'Honduras', 10, 1 UNION ALL 
SELECT 803, 158, 2, N'Salvador', 10, 1 UNION ALL 
SELECT 804, 159, 2, N'Guatemala', 10, 1 UNION ALL 
SELECT 805, 160, 2, N'Nicaragua', 10, 1 UNION ALL 
SELECT 806, 161, 2, N'Panama', 10, 1 UNION ALL 
SELECT 807, 162, 2, N'the Dominican Republic', 10, 1 UNION ALL 
SELECT 808, 163, 2, N'Haiti', 10, 1 UNION ALL 
SELECT 809, 164, 2, N'Puerto Rico', 10, 1 UNION ALL 
SELECT 810, 165, 2, N'Costa Rica', 10, 1 UNION ALL 
SELECT 811, 166, 2, N'Belize', 10, 1 UNION ALL 
SELECT 812, 167, 2, N'the Bahamas', 10, 1 UNION ALL 
SELECT 813, 168, 2, N'Europe', 10, 1 UNION ALL 
SELECT 814, 169, 2, N'South America', 10, 1 UNION ALL 
SELECT 815, 170, 2, N'North America', 10, 1 UNION ALL 
SELECT 816, 171, 2, N'Africa', 10, 1 UNION ALL 
SELECT 817, 172, 2, N'Asia', 10, 1 UNION ALL 
SELECT 818, 173, 2, N'Oceania', 10, 1 UNION ALL 
SELECT 819, 174, 2, N'Scandinavia', 10, 1 UNION ALL 
SELECT 820, 175, 2, N'the Caucasus', 10, 1 UNION ALL 
SELECT 821, 176, 2, N'the Caribbean', 10, 1 UNION ALL 
SELECT 822, 177, 2, N'cat', 10, 1 UNION ALL 
SELECT 823, 178, 2, N'hamster', 10, 1 UNION ALL 
SELECT 824, 179, 2, N'cow', 10, 1 UNION ALL 
SELECT 825, 180, 2, N'horse', 10, 1 UNION ALL 
SELECT 826, 181, 2, N'fly', 10, 1 UNION ALL 
SELECT 827, 182, 2, N'bee', 10, 1 UNION ALL 
SELECT 828, 183, 2, N'wasp', 10, 1 UNION ALL 
SELECT 829, 184, 2, N'mosquito', 10, 1 UNION ALL 
SELECT 830, 185, 2, N'frog', 10, 1 UNION ALL 
SELECT 831, 186, 2, N'bird', 10, 1 UNION ALL 
SELECT 832, 187, 2, N'fish', 10, 1 UNION ALL 
SELECT 833, 188, 2, N'stork', 10, 1 UNION ALL 
SELECT 834, 189, 2, N'sparrow', 10, 1 UNION ALL 
SELECT 835, 190, 2, N'butterfly', 10, 1 UNION ALL 
SELECT 836, 191, 2, N'monkey', 10, 1 UNION ALL 
SELECT 837, 192, 2, N'elephant', 10, 1 UNION ALL 
SELECT 838, 193, 2, N'lion', 10, 1 UNION ALL 
SELECT 839, 194, 2, N'giraffe', 10, 1 UNION ALL 
SELECT 840, 195, 2, N'camel', 10, 1 UNION ALL 
SELECT 841, 196, 2, N'tiger', 10, 1 UNION ALL 
SELECT 842, 197, 2, N'snake', 10, 1 UNION ALL 
SELECT 843, 198, 2, N'shark', 10, 1 UNION ALL 
SELECT 844, 199, 2, N'whale', 10, 1 UNION ALL 
SELECT 845, 200, 2, N'donkey', 10, 1 UNION ALL 
SELECT 846, 201, 2, N'sheep', 10, 1 UNION ALL 
SELECT 847, 202, 2, N'pigeon', 10, 1 UNION ALL 
SELECT 848, 202, 2, N'dove', 10, 1 UNION ALL 
SELECT 849, 203, 2, N'falcon', 10, 1 UNION ALL 
SELECT 850, 204, 2, N'eagle', 10, 1 UNION ALL 
SELECT 851, 205, 2, N'hawk', 10, 1 UNION ALL 
SELECT 852, 206, 2, N'the Andes', 10, 1 UNION ALL 
SELECT 853, 207, 2, N'the Himalayas', 10, 1 UNION ALL 
SELECT 854, 207, 2, N'Himalaya', 10, 1 UNION ALL 
SELECT 855, 208, 2, N'the Alps', 10, 1 UNION ALL 
SELECT 856, 209, 2, N'the Mediterranean Sea', 10, 1 UNION ALL 
SELECT 857, 210, 2, N'the Atlantic', 10, 1 UNION ALL 
SELECT 858, 211, 2, N'the Pacific', 10, 1 UNION ALL 
SELECT 859, 212, 2, N'the Indian Ocean', 10, 1 UNION ALL 
SELECT 860, 213, 2, N'the Persian Gulf', 10, 1 UNION ALL 
SELECT 861, 214, 2, N'the Baltic Sea', 10, 1 UNION ALL 
SELECT 862, 215, 2, N'Sardinia', 10, 1 UNION ALL 
SELECT 863, 216, 2, N'Sicily', 10, 1 UNION ALL 
SELECT 864, 217, 2, N'black', 10, 1 UNION ALL 
SELECT 865, 218, 2, N'white', 10, 1 UNION ALL 
SELECT 866, 219, 2, N'green', 10, 1 UNION ALL 
SELECT 867, 220, 2, N'red', 10, 1 UNION ALL 
SELECT 868, 221, 2, N'yellow', 10, 1 UNION ALL 
SELECT 869, 222, 2, N'brown', 10, 1 UNION ALL 
SELECT 870, 223, 2, N'blue', 10, 1 UNION ALL 
SELECT 871, 224, 2, N'rose', 10, 1 UNION ALL 
SELECT 872, 225, 2, N'orange', 10, 1 UNION ALL 
SELECT 873, 226, 2, N'gray', 10, 1 UNION ALL 
SELECT 874, 227, 2, N'Monday', 10, 1 UNION ALL 
SELECT 875, 228, 2, N'Tuesday', 10, 1 UNION ALL 
SELECT 876, 229, 2, N'Wednesday', 10, 1 UNION ALL 
SELECT 877, 230, 2, N'Thursday', 10, 1 UNION ALL 
SELECT 878, 231, 2, N'Friday', 10, 1 UNION ALL 
SELECT 879, 232, 2, N'Saturday', 10, 1 UNION ALL 
SELECT 880, 233, 2, N'Sunday', 10, 1 UNION ALL 
SELECT 881, 234, 2, N'January', 10, 1 UNION ALL 
SELECT 882, 235, 2, N'February', 10, 1 UNION ALL 
SELECT 883, 236, 2, N'March', 10, 1 UNION ALL 
SELECT 884, 237, 2, N'April', 10, 1 UNION ALL 
SELECT 885, 238, 2, N'May', 10, 1 UNION ALL 
SELECT 886, 239, 2, N'June', 10, 1 UNION ALL 
SELECT 887, 240, 2, N'July', 10, 1 UNION ALL 
SELECT 888, 241, 2, N'August', 10, 1 UNION ALL 
SELECT 889, 242, 2, N'September', 10, 1 UNION ALL 
SELECT 890, 243, 2, N'October', 10, 1 UNION ALL 
SELECT 891, 244, 2, N'November', 10, 1 UNION ALL 
SELECT 892, 245, 2, N'December', 10, 1 UNION ALL 
SELECT 893, 246, 2, N'year', 10, 1 UNION ALL 
SELECT 894, 247, 2, N'month', 10, 1 UNION ALL 
SELECT 895, 248, 2, N'day', 10, 1 UNION ALL 
SELECT 896, 249, 2, N'week', 10, 1 UNION ALL 
SELECT 897, 250, 2, N'hour', 10, 1 UNION ALL 
SELECT 898, 251, 2, N'minute', 10, 1 UNION ALL 
SELECT 899, 252, 2, N'second', 10, 1 UNION ALL 
SELECT 900, 253, 2, N'weekend', 10, 1 UNION ALL 
SELECT 901, 254, 2, N'tomorrow', 10, 1 UNION ALL 
SELECT 902, 255, 2, N'today', 10, 1 UNION ALL 
SELECT 903, 256, 2, N'yesterday', 10, 1 UNION ALL 
SELECT 904, 257, 2, N'turtle', 10, 1 UNION ALL 
SELECT 905, 258, 2, N'crocodile', 10, 1 UNION ALL 
SELECT 906, 259, 2, N'kangaroo', 10, 1 UNION ALL 
SELECT 907, 260, 2, N'reptile', 10, 1 UNION ALL 
SELECT 908, 261, 2, N'amphibian', 10, 1 UNION ALL 
SELECT 909, 262, 2, N'mammal', 10, 1 UNION ALL 
SELECT 910, 263, 2, N'worm', 10, 1 UNION ALL 
SELECT 911, 263, 2, N'bug', 10, 1 UNION ALL 
SELECT 912, 264, 2, N'insect', 10, 1 UNION ALL 
SELECT 913, 265, 2, N'apple', 10, 1 UNION ALL 
SELECT 914, 266, 2, N'pear', 10, 1 UNION ALL 
SELECT 915, 267, 2, N'cherry', 10, 1 UNION ALL 
SELECT 916, 268, 2, N'strawberry', 10, 1 UNION ALL 
SELECT 917, 269, 2, N'pineapple', 10, 1 UNION ALL 
SELECT 918, 270, 2, N'orange', 10, 1 UNION ALL 
SELECT 919, 271, 2, N'cherry', 10, 1 UNION ALL 
SELECT 920, 272, 2, N'currant', 10, 1 UNION ALL 
SELECT 921, 273, 2, N'raspberry', 10, 1 UNION ALL 
SELECT 922, 274, 2, N'banana', 10, 1 UNION ALL 
SELECT 923, 275, 2, N'(to )make', 10, 1 UNION ALL 
SELECT 924, 276, 2, N'Polish', 10, 1 UNION ALL 
SELECT 925, 277, 2, N'arm', 10, 1 UNION ALL 
SELECT 926, 277, 2, N'hand', 5, 0 UNION ALL 
SELECT 927, 278, 2, N'(to )pay', 10, 1 UNION ALL 
SELECT 928, 279, 2, N'fast', 10, 1 UNION ALL 
SELECT 929, 280, 2, N'(to )talk', 10, 1 UNION ALL 
SELECT 930, 281, 2, N'(to )read', 10, 1 UNION ALL 
SELECT 931, 282, 2, N'(to )gain', 10, 1 UNION ALL 
SELECT 932, 283, 2, N'(to )try', 10, 1 UNION ALL 
SELECT 933, 284, 2, N'book', 10, 1 UNION ALL 
SELECT 934, 285, 2, N'game', 10, 1 UNION ALL 
SELECT 935, 286, 2, N'product', 10, 1 UNION ALL 
SELECT 936, 287, 2, N'car', 10, 1 UNION ALL 
SELECT 937, 288, 2, N'software', 10, 1 UNION ALL 
SELECT 938, 289, 2, N'(to )lose', 10, 1 UNION ALL 
SELECT 939, 290, 2, N'(to )shave', 10, 1 UNION ALL 
SELECT 940, 291, 2, N'(to )miss', 10, 1 UNION ALL 
SELECT 941, 291, 2, N'(to )be late', 10, 1 UNION ALL 
SELECT 942, 291, 2, N'to miss / to be late', 10, 1 UNION ALL 
SELECT 943, 292, 2, N'(to )learn', 10, 0 UNION ALL 
SELECT 944, 292, 2, N'(to )find out', 10, 0 UNION ALL 
SELECT 945, 292, 2, N'to learn / to find out', 10, 0 UNION ALL 
SELECT 946, 293, 2, N'(to )catch cold', 10, 1 UNION ALL 
SELECT 947, 293, 2, N'(to )catch a chill', 10, 1 UNION ALL 
SELECT 948, 294, 2, N'(to )loosen', 10, 1 UNION ALL 
SELECT 949, 295, 2, N'(to )tie', 10, 1 UNION ALL 
SELECT 950, 296, 2, N'(to )be called', 10, 1 UNION ALL 
SELECT 951, 297, 2, N'(to )have', 10, 1 UNION ALL 
SELECT 952, 298, 2, N'(to )must', 10, 1 UNION ALL 
SELECT 953, 298, 2, N'(to )need to', 10, 1 UNION ALL 
SELECT 954, 298, 2, N'(to )have to', 10, 1 UNION ALL 
SELECT 955, 299, 2, N'(to )notice', 10, 1 UNION ALL 
SELECT 956, 299, 2, N'(to )note', 10, 1 UNION ALL 
SELECT 957, 299, 2, N'(to )observe', 10, 1 UNION ALL 
SELECT 958, 300, 2, N'(to )chatter', 10, 1 UNION ALL 
SELECT 959, 300, 2, N'(to )chat', 10, 1 UNION ALL 
SELECT 960, 300, 2, N'(to )talk', 5, 0 UNION ALL 
SELECT 961, 300, 2, N'(to )babble', 10, 1 UNION ALL 
SELECT 962, 301, 2, N'(to )recover', 10, 1 UNION ALL 
SELECT 963, 302, 2, N'(to )want', 10, 1 UNION ALL 
SELECT 964, 303, 2, N'(to )touch', 10, 1 UNION ALL 
SELECT 965, 304, 2, N'tv', 10, 1 UNION ALL 
SELECT 966, 304, 2, N'television', 10, 1 UNION ALL 
SELECT 967, 305, 2, N'internet', 10, 1 UNION ALL 
SELECT 968, 306, 2, N'press', 10, 1 UNION ALL 
SELECT 969, 307, 2, N'(to )look for', 10, 1 UNION ALL 
SELECT 970, 307, 2, N'(to )seek', 10, 1 UNION ALL 
SELECT 971, 308, 2, N'(to )sleep', 10, 1 UNION ALL 
SELECT 972, 309, 2, N'(to )recognize', 10, 1 UNION ALL 
SELECT 973, 310, 2, N'hotel', 10, 1 UNION ALL 
SELECT 974, 311, 2, N'electricity', 10, 1 UNION ALL 
SELECT 975, 312, 2, N'phone', 10, 1 UNION ALL 
SELECT 976, 313, 2, N'heating', 10, 1 UNION ALL 
SELECT 977, 314, 2, N'water', 10, 1 UNION ALL 
SELECT 978, 315, 2, N'gas', 10, 1 UNION ALL 
SELECT 979, 316, 2, N'plane', 10, 1 UNION ALL 
SELECT 980, 316, 2, N'airplane', 10, 1 UNION ALL 
SELECT 981, 317, 2, N'train', 10, 1 UNION ALL 
SELECT 982, 318, 2, N'bus', 10, 1 UNION ALL 
SELECT 983, 319, 2, N'lesson', 10, 1 UNION ALL 
SELECT 984, 320, 2, N'(to )get', 10, 1 UNION ALL 
SELECT 985, 320, 2, N'(to )receive', 10, 1 UNION ALL 
SELECT 986, 320, 2, N'(to )obtain', 10, 1 UNION ALL 
SELECT 987, 321, 2, N'(to )work', 10, 1 UNION ALL 
SELECT 988, 322, 2, N'(to )listen', 10, 1 UNION ALL 
SELECT 989, 323, 2, N'(to )drive', 10, 1 UNION ALL 
SELECT 990, 323, 2, N'(to )go', 10, 0 UNION ALL 
SELECT 991, 324, 2, N'(to )live', 10, 1 UNION ALL 
SELECT 992, 324, 2, N'(to )dwell', 10, 1 UNION ALL 
SELECT 993, 324, 2, N'(to )reside', 10, 1 UNION ALL 
SELECT 994, 325, 2, N'(to )park', 10, 1 UNION ALL 
SELECT 995, 326, 2, N'(to )earn', 10, 1 UNION ALL 
SELECT 996, 327, 2, N'(to )run', 10, 1 UNION ALL 
SELECT 997, 328, 2, N'(to )reach', 10, 1 UNION ALL 
SELECT 998, 328, 2, N'(to )get', 10, 0 UNION ALL 
SELECT 999, 329, 2, N'(to )fish out', 10, 1 UNION ALL 
SELECT 1000, 329, 2, N'(to )pull out', 10, 1 UNION ALL 
SELECT 1001, 330, 2, N'(to )give', 10, 1 UNION ALL 
SELECT 1002, 331, 2, N'(to )look', 10, 1 UNION ALL 
SELECT 1003, 332, 2, N'sea', 10, 1 UNION ALL 
SELECT 1004, 333, 2, N'lake', 10, 1 UNION ALL 
SELECT 1005, 334, 2, N'beach', 10, 1 UNION ALL 
SELECT 1006, 335, 2, N'alone', 10, 1 UNION ALL 
SELECT 1007, 336, 2, N'(to )hear', 10, 1 UNION ALL 
SELECT 1008, 337, 2, N'(to )feel', 10, 1 UNION ALL 
SELECT 1009, 338, 2, N'(to )expect', 10, 1 UNION ALL 
SELECT 1010, 339, 2, N'(to )inform', 10, 1 UNION ALL 
SELECT 1011, 340, 2, N'(to )learn', 10, 1 UNION ALL 
SELECT 1012, 341, 2, N'English', 10, 1 UNION ALL 
SELECT 1013, 342, 2, N'Spanish', 10, 1 UNION ALL 
SELECT 1014, 343, 2, N'French', 10, 1 UNION ALL 
SELECT 1015, 344, 2, N'Russian', 10, 1 UNION ALL 
SELECT 1016, 345, 2, N'Italian', 10, 1 UNION ALL 
SELECT 1017, 346, 2, N'Portuguese', 10, 1 UNION ALL 
SELECT 1018, 347, 2, N'Arabic', 10, 1 UNION ALL 
SELECT 1019, 347, 2, N'Arabian', 10, 1 UNION ALL 
SELECT 1020, 348, 2, N'Japanese', 10, 1 UNION ALL 
SELECT 1021, 349, 2, N'Chinese', 10, 1 UNION ALL 
SELECT 1022, 350, 2, N'Czech', 10, 1 UNION ALL 
SELECT 1023, 351, 2, N'(to )react', 10, 1 UNION ALL 
SELECT 1024, 352, 2, N'(to )cry', 10, 1 UNION ALL 
SELECT 1025, 353, 2, N'(to )think', 10, 1 UNION ALL 
SELECT 1026, 354, 2, N'(to )behave', 10, 1 UNION ALL 
SELECT 1027, 355, 2, N'nice', 10, 1 UNION ALL 
SELECT 1028, 355, 2, N'pretty', 10, 1 UNION ALL 
SELECT 1029, 355, 2, N'cute', 10, 1 UNION ALL 
SELECT 1030, 356, 2, N'Georgian', 10, 1 UNION ALL 
SELECT 1031, 357, 2, N'Korean', 10, 1 UNION ALL 
SELECT 1032, 358, 2, N'Vietnamese', 10, 1 UNION ALL 
SELECT 1033, 359, 2, N'Greek', 10, 1 UNION ALL 
SELECT 1034, 360, 2, N'Bulgarian', 10, 1 UNION ALL 
SELECT 1035, 361, 2, N'Albanian', 10, 1 UNION ALL 
SELECT 1036, 362, 2, N'Croatian', 10, 1 UNION ALL 
SELECT 1037, 363, 2, N'Swiss', 10, 1 UNION ALL 
SELECT 1038, 363, 2, N'Helvetian', 3, 0 UNION ALL 
SELECT 1039, 364, 2, N'Austriian', 10, 1 UNION ALL 
SELECT 1040, 365, 2, N'Australian', 10, 1 UNION ALL 
SELECT 1041, 366, 2, N'Mexican', 10, 1 UNION ALL 
SELECT 1042, 367, 2, N'Brazilian', 10, 1 UNION ALL 
SELECT 1043, 368, 2, N'Argentinean', 10, 1 UNION ALL 
SELECT 1044, 369, 2, N'Colombian', 10, 1 UNION ALL 
SELECT 1045, 370, 2, N'Canadian', 10, 1 UNION ALL 
SELECT 1046, 371, 2, N'American', 10, 1 UNION ALL 
SELECT 1047, 372, 2, N'Irish', 10, 1 UNION ALL 
SELECT 1048, 373, 2, N'Scottish', 10, 1 UNION ALL 
SELECT 1049, 374, 2, N'Welsh', 10, 1 UNION ALL 
SELECT 1050, 375, 2, N'Icelandic', 10, 1 UNION ALL 
SELECT 1051, 376, 2, N'Danish', 10, 1 UNION ALL 
SELECT 1052, 377, 2, N'Norwegian', 10, 1 UNION ALL 
SELECT 1053, 378, 2, N'Swedish', 10, 1 UNION ALL 
SELECT 1054, 379, 2, N'Finnish', 10, 1 UNION ALL 
SELECT 1055, 380, 2, N'Estonian', 10, 1 UNION ALL 
SELECT 1056, 381, 2, N'Latvian', 10, 1 UNION ALL 
SELECT 1057, 382, 2, N'Lithuanian', 10, 1 UNION ALL 
SELECT 1058, 383, 2, N'Dutch', 10, 1 UNION ALL 
SELECT 1059, 384, 2, N'Belgian', 10, 1 UNION ALL 
SELECT 1060, 385, 2, N'Slovak', 10, 1 UNION ALL 
SELECT 1061, 386, 2, N'Hungarian', 10, 1 UNION ALL 
SELECT 1062, 387, 2, N'Romanian', 10, 1 UNION ALL 
SELECT 1063, 388, 2, N'Serbian', 10, 1 UNION ALL 
SELECT 1064, 389, 2, N'Macedonian', 10, 1 UNION ALL 
SELECT 1065, 390, 2, N'Bosnian/Herzegovinian', 10, 1 UNION ALL 
SELECT 1066, 390, 2, N'Bosnian', 10, 1 UNION ALL 
SELECT 1067, 391, 2, N'Slovenian', 10, 1 UNION ALL 
SELECT 1068, 392, 2, N'Montenegrin', 10, 1 UNION ALL 
SELECT 1069, 393, 2, N'Belarusian', 10, 1 UNION ALL 
SELECT 1070, 394, 2, N'Ukrainian', 10, 1 UNION ALL 
SELECT 1071, 395, 2, N'Moldavian', 10, 1 UNION ALL 
SELECT 1072, 396, 2, N'Peruvian', 10, 1 UNION ALL 
SELECT 1073, 397, 2, N'Chilean', 10, 1 UNION ALL 
SELECT 1074, 398, 2, N'Venezuelan', 10, 1 UNION ALL 
SELECT 1075, 399, 2, N'Uruguayan', 10, 1 UNION ALL 
SELECT 1076, 400, 2, N'Paraguayan', 10, 1 UNION ALL 
SELECT 1077, 401, 2, N'Ecuadorian', 10, 1 UNION ALL 
SELECT 1078, 401, 2, N'Ecuadorean', 5, 1 UNION ALL 
SELECT 1079, 402, 2, N'Bolivian', 10, 1 UNION ALL 
SELECT 1080, 403, 2, N'Surinamese', 10, 1 UNION ALL 
SELECT 1081, 404, 2, N'Guyanese', 10, 1 UNION ALL 
SELECT 1082, 405, 2, N'Armenian', 10, 1 UNION ALL 
SELECT 1083, 406, 2, N'Azerbaijani', 10, 1 UNION ALL 
SELECT 1084, 406, 2, N'Azerbaijanian', 10, 1 UNION ALL 
SELECT 1085, 407, 2, N'Turkish', 10, 1 UNION ALL 
SELECT 1086, 408, 2, N'Jamaican', 10, 1 UNION ALL 
SELECT 1087, 409, 2, N'Greenland', 10, 1 UNION ALL 
SELECT 1088, 410, 2, N'Algerian', 10, 1 UNION ALL 
SELECT 1089, 411, 2, N'Moroccan', 10, 1 UNION ALL 
SELECT 1090, 412, 2, N'Ethiopian', 10, 1 UNION ALL 
SELECT 1091, 413, 2, N'Kenyan', 10, 1 UNION ALL 
SELECT 1092, 414, 2, N'Malagasy', 10, 1 UNION ALL 
SELECT 1093, 415, 2, N'Somali', 10, 1 UNION ALL 
SELECT 1094, 416, 2, N'Angolan', 10, 1 UNION ALL 
SELECT 1095, 417, 2, N'Cameroonian', 10, 1 UNION ALL 
SELECT 1096, 418, 2, N'Gabonese', 10, 1 UNION ALL 
SELECT 1097, 419, 2, N'Egyptian', 10, 1 UNION ALL 
SELECT 1098, 420, 2, N'Libyan', 10, 1 UNION ALL 
SELECT 1099, 421, 2, N'Soudanese', 10, 1 UNION ALL 
SELECT 1100, 422, 2, N'Tunisian', 10, 1 UNION ALL 
SELECT 1101, 423, 2, N'South African', 10, 1 UNION ALL 
SELECT 1102, 424, 2, N'Senegalese', 10, 1 UNION ALL 
SELECT 1103, 425, 2, N'Nigerian', 10, 1 UNION ALL 
SELECT 1104, 426, 2, N'New Zealand', 10, 1 UNION ALL 
SELECT 1105, 427, 2, N'(to )get up', 10, 1 UNION ALL 
SELECT 1106, 428, 2, N'Iranian', 10, 1 UNION ALL 
SELECT 1107, 429, 2, N'Persian', 10, 1 UNION ALL 
SELECT 1108, 430, 2, N'Iraqi', 10, 1 UNION ALL 
SELECT 1109, 431, 2, N'Pakistani', 10, 1 UNION ALL 
SELECT 1110, 432, 2, N'Syrian', 10, 1 UNION ALL 
SELECT 1111, 433, 2, N'Indian', 10, 1 UNION ALL 
SELECT 1112, 434, 2, N'Lebanese', 10, 1 UNION ALL 
SELECT 1113, 435, 2, N'Thai', 10, 1 UNION ALL 
SELECT 1114, 436, 2, N'Mongolian', 10, 1 UNION ALL 
SELECT 1115, 437, 2, N'(to )claim', 10, 1 UNION ALL 
SELECT 1116, 438, 2, N'(to )intend', 10, 1 UNION ALL 
SELECT 1117, 439, 2, N'(to )survive', 10, 1 UNION ALL 
SELECT 1118, 440, 2, N'(to )born', 10, 1 UNION ALL 
SELECT 1119, 441, 2, N'one', 10, 1 UNION ALL 
SELECT 1120, 442, 2, N'two', 10, 1 UNION ALL 
SELECT 1121, 443, 2, N'three', 10, 1 UNION ALL 
SELECT 1122, 444, 2, N'four', 10, 1 UNION ALL 
SELECT 1123, 445, 2, N'five', 10, 1 UNION ALL 
SELECT 1124, 446, 2, N'six', 10, 1 UNION ALL 
SELECT 1125, 447, 2, N'hospital', 10, 1 UNION ALL 
SELECT 1126, 448, 2, N'school', 10, 1 UNION ALL 
SELECT 1127, 449, 2, N'post office', 10, 1 UNION ALL 
SELECT 1128, 450, 2, N'police', 10, 1 UNION ALL 
SELECT 1129, 451, 2, N'(to )win', 10, 1 UNION ALL 
SELECT 1130, 452, 2, N'Oscar', 10, 1 UNION ALL 
SELECT 1131, 453, 2, N'Nobel Prize', 10, 1 UNION ALL 
SELECT 1132, 454, 2, N'fireman', 10, 1 UNION ALL 
SELECT 1133, 455, 2, N'doctor', 10, 1 UNION ALL 
SELECT 1134, 456, 2, N'police officer', 10, 1 UNION ALL 
SELECT 1135, 457, 2, N'teacher', 10, 1 UNION ALL 
SELECT 1136, 458, 2, N'taxi driver', 10, 1 UNION ALL 
SELECT 1137, 459, 2, N'driver', 10, 1 UNION ALL 
SELECT 1138, 460, 2, N'apartment', 10, 1 UNION ALL 
SELECT 1139, 461, 2, N'room', 10, 1 UNION ALL 
SELECT 1140, 462, 2, N'door', 10, 1 UNION ALL 
SELECT 1141, 463, 2, N'window', 10, 1 UNION ALL 
SELECT 1142, 464, 2, N'(to )eat', 10, 1 UNION ALL 
SELECT 1143, 465, 2, N'breakfast', 10, 1 UNION ALL 
SELECT 1144, 466, 2, N'dinner', 10, 1 UNION ALL 
SELECT 1145, 467, 2, N'(to )live', 10, 1 UNION ALL 
SELECT 1146, 468, 2, N'(to )begin', 10, 1 UNION ALL 
SELECT 1147, 468, 2, N'(to )start', 10, 1 UNION ALL 
SELECT 1148, 469, 2, N'(to )lose', 10, 1 UNION ALL 
SELECT 1149, 470, 2, N'(to )know', 10, 1 UNION ALL 
SELECT 1150, 471, 2, N'(to )stress', 10, 1 UNION ALL 
SELECT 1151, 472, 2, N'(to )vote', 10, 1 UNION ALL 
SELECT 1152, 473, 2, N'this', 10, 1 UNION ALL 
SELECT 1153, 474, 2, N'house', 10, 1 UNION ALL 
SELECT 1154, 475, 2, N'coast', 10, 1 UNION ALL 
SELECT 1155, 475, 2, N'bank', 10, 0 UNION ALL 
SELECT 1156, 475, 2, N'riverside', 10, 0 UNION ALL 
SELECT 1157, 476, 2, N'(to )hide', 10, 1 UNION ALL 
SELECT 1158, 477, 2, N'(to )go', 10, 1 UNION ALL 
SELECT 1159, 477, 2, N'(to )walk', 10, 0 UNION ALL 
SELECT 1160, 478, 2, N'(to )sit', 10, 1 UNION ALL 
SELECT 1161, 479, 2, N'(to )take', 10, 1 UNION ALL 
SELECT 1162, 480, 2, N'(to )laugh', 10, 1 UNION ALL 
SELECT 1163, 481, 2, N'forest', 10, 1 UNION ALL 
SELECT 1164, 481, 2, N'wood', 5, 0 UNION ALL 
SELECT 1165, 482, 2, N'airport', 10, 1 UNION ALL 
SELECT 1166, 483, 2, N'river', 10, 1 UNION ALL 
SELECT 1167, 484, 2, N'taxi', 10, 1 UNION ALL 
SELECT 1168, 484, 2, N'cab', 10, 1 UNION ALL 
SELECT 1169, 484, 2, N'taxicab', 10, 1 UNION ALL 
SELECT 1170, 485, 2, N'(to )stop', 10, 1 UNION ALL 
SELECT 1171, 486, 2, N'(to )ask', 10, 1 UNION ALL 
SELECT 1172, 487, 2, N'(to )recognize', 10, 1 UNION ALL 
SELECT 1173, 488, 2, N'(to )wake', 10, 1 UNION ALL 
SELECT 1174, 489, 2, N'(to )threaten', 10, 1 UNION ALL 
SELECT 1175, 490, 2, N'interview', 10, 1 UNION ALL 
SELECT 1176, 491, 2, N'meeting', 10, 1 UNION ALL 
SELECT 1177, 491, 2, N'appointment', 10, 1 UNION ALL 
SELECT 1178, 492, 2, N'debate', 10, 1 UNION ALL 
SELECT 1179, 493, 2, N'(to )see', 10, 1 UNION ALL 
SELECT 1180, 494, 2, N'(to )find', 10, 1 UNION ALL 
SELECT 1181, 495, 2, N'wallet', 10, 1 UNION ALL 
SELECT 1182, 496, 2, N'key', 10, 1 UNION ALL 
SELECT 1183, 497, 2, N'credit card', 10, 1 UNION ALL 
SELECT 1184, 498, 2, N'flight', 10, 1 UNION ALL 
SELECT 1185, 499, 2, N'gift', 10, 1 UNION ALL 
SELECT 1186, 499, 2, N'present', 10, 0 UNION ALL 
SELECT 1187, 500, 2, N'answer', 10, 1 UNION ALL 
SELECT 1188, 501, 2, N'this', 10, 1 UNION ALL 
SELECT 1189, 502, 2, N'computer', 10, 1 UNION ALL 
SELECT 1190, 503, 2, N'(to )suppose', 10, 1 UNION ALL 
SELECT 1191, 503, 2, N'(to )guess', 5, 0 UNION ALL 
SELECT 1192, 503, 2, N'(to )believe', 5, 0 UNION ALL 
SELECT 1193, 503, 2, N'(to )presume', 5, 0 UNION ALL 
SELECT 1194, 504, 2, N'newspaper', 10, 1 UNION ALL 
SELECT 1195, 505, 2, N'document', 10, 1 UNION ALL 
SELECT 1196, 506, 2, N'poem', 10, 1 UNION ALL 
SELECT 1197, 507, 2, N'(to )write', 10, 1 UNION ALL 
SELECT 1198, 508, 2, N'table', 10, 1 UNION ALL 
SELECT 1199, 509, 2, N'chair', 10, 1 UNION ALL 
SELECT 1200, 510, 2, N'floor', 10, 1 UNION ALL 
SELECT 1201, 511, 2, N'bed', 10, 1 UNION ALL 
SELECT 1202, 512, 2, N'(to )contact', 10, 1 UNION ALL 
SELECT 1203, 513, 2, N'(to )meet', 10, 1 UNION ALL 
SELECT 1204, 514, 2, N'(to )hit', 10, 1 UNION ALL 
SELECT 1205, 514, 2, N'(to )strike', 10, 1 UNION ALL 
SELECT 1206, 515, 2, N'(to )wait', 10, 1 UNION ALL 
SELECT 1207, 516, 2, N'(to )know', 10, 1 UNION ALL 
SELECT 1208, 517, 2, N'(to )leave', 10, 1 UNION ALL 
SELECT 1209, 518, 2, N'(to )talk', 10, 1 UNION ALL 
SELECT 1210, 519, 2, N'(to )wear', 10, 1 UNION ALL 
SELECT 1211, 520, 2, N'(to )miss', 10, 1 UNION ALL 
SELECT 1212, 520, 2, N'(to )be lacking', 10, 1 UNION ALL 
SELECT 1213, 521, 2, N'some', 10, 1 UNION ALL 
SELECT 1214, 522, 2, N'crime', 10, 1 UNION ALL 
SELECT 1215, 522, 2, N'felony', 5, 1 UNION ALL 
SELECT 1216, 523, 2, N'crime', 10, 1 UNION ALL 
SELECT 1217, 523, 2, N'offense', 10, 1 UNION ALL 
SELECT 1218, 523, 2, N'crime, offense', 10, 1 UNION ALL 
SELECT 1219, 524, 2, N'threat', 10, 1 UNION ALL 
SELECT 1220, 525, 2, N'joke', 10, 1 UNION ALL 
SELECT 1221, 526, 2, N'concert', 10, 1 UNION ALL 
SELECT 1222, 527, 2, N'Middle Ages', 10, 1 UNION ALL 
SELECT 1223, 527, 2, N'Dark Ages', 5, 1 UNION ALL 
SELECT 1224, 528, 2, N'civil war', 10, 1 UNION ALL 
SELECT 1225, 529, 2, N'final', 10, 1 UNION ALL 
SELECT 1226, 530, 2, N'that', 10, 1 UNION ALL 
SELECT 1227, 531, 2, N'life', 10, 1 UNION ALL 
SELECT 1228, 532, 2, N'(to )arrive', 10, 1 UNION ALL 
SELECT 1229, 533, 2, N'scorpion', 10, 1 UNION ALL 
SELECT 1230, 534, 2, N'ray', 10, 1 UNION ALL 
SELECT 1231, 534, 2, N'sea devil', 10, 1 UNION ALL 
SELECT 1232, 535, 2, N'jellyfish', 10, 1 UNION ALL 
SELECT 1233, 536, 2, N'hornet', 10, 1 UNION ALL 
SELECT 1234, 537, 2, N'tick', 10, 1 UNION ALL 
SELECT 1235, 538, 2, N'rattlesnake', 10, 1 UNION ALL 
SELECT 1236, 539, 2, N'viper', 10, 1 UNION ALL 
SELECT 1237, 540, 2, N'proof', 10, 1 UNION ALL 
SELECT 1238, 540, 2, N'evidence', 10, 0 UNION ALL 
SELECT 1239, 541, 2, N'data', 10, 1 UNION ALL 
SELECT 1240, 542, 2, N'statistics', 10, 1 UNION ALL 
SELECT 1241, 543, 2, N'seven', 10, 1 UNION ALL 
SELECT 1242, 544, 2, N'eight', 10, 1 UNION ALL 
SELECT 1243, 545, 2, N'skin', 10, 1 UNION ALL 
SELECT 1244, 546, 2, N'place', 10, 0 UNION ALL 
SELECT 1245, 546, 2, N'spot', 10, 0 UNION ALL 
SELECT 1246, 546, 2, N'position', 10, 0 UNION ALL 
SELECT 1247, 546, 2, N'place, spot, position', 10, 1 UNION ALL 
SELECT 1248, 547, 2, N'(to )believe', 10, 1 UNION ALL 
SELECT 1249, 548, 2, N'(to )need', 10, 1 UNION ALL 
SELECT 1250, 549, 2, N'(to )like', 10, 1 UNION ALL 
SELECT 1251, 550, 2, N'only', 10, 1 UNION ALL 
SELECT 1252, 550, 2, N'sole', 6, 1 UNION ALL 
SELECT 1253, 551, 2, N'photo shot', 10, 1 UNION ALL 
SELECT 1254, 551, 2, N'shot', 10, 0 UNION ALL 
SELECT 1255, 552, 2, N'explanation', 10, 1 UNION ALL 
SELECT 1256, 552, 2, N'clarification', 10, 1 UNION ALL 
SELECT 1257, 553, 2, N'reason', 10, 1 UNION ALL 
SELECT 1258, 554, 2, N'opportunity', 10, 1 UNION ALL 
SELECT 1259, 554, 2, N'chance', 10, 1 UNION ALL 
SELECT 1260, 554, 2, N'occassion', 10, 1 UNION ALL 
SELECT 1261, 555, 2, N'person', 10, 1 UNION ALL 
SELECT 1262, 556, 2, N'question', 10, 1 UNION ALL 
SELECT 1263, 557, 2, N'requirement', 10, 1 UNION ALL 
SELECT 1264, 558, 2, N'difference', 10, 1 UNION ALL 
SELECT 1265, 559, 2, N'problem', 10, 1 UNION ALL 
SELECT 1266, 559, 2, N'issue', 10, 1 UNION ALL 
SELECT 1267, 559, 2, N'problem, issue', 10, 1 UNION ALL 
SELECT 1268, 559, 2, N'trouble', 5, 0 UNION ALL 
SELECT 1269, 560, 2, N'choice', 10, 1 UNION ALL 
SELECT 1270, 561, 2, N'map', 10, 1 UNION ALL 
SELECT 1271, 562, 2, N'chart', 10, 1 UNION ALL 
SELECT 1272, 563, 2, N'assumption', 10, 1 UNION ALL 
SELECT 1273, 563, 2, N'presumption', 10, 1 UNION ALL 
SELECT 1274, 564, 2, N'results', 10, 1 UNION ALL 
SELECT 1275, 564, 2, N'score', 10, 1 UNION ALL 
SELECT 1276, 565, 2, N'result', 10, 1 UNION ALL 
SELECT 1277, 566, 2, N'photo', 10, 1 UNION ALL 
SELECT 1278, 566, 2, N'photograph', 10, 1 UNION ALL 
SELECT 1279, 566, 2, N'picture', 10, 1 UNION ALL 
SELECT 1280, 567, 2, N'hammer', 10, 1 UNION ALL 
SELECT 1281, 568, 2, N'rope', 10, 1 UNION ALL 
SELECT 1282, 568, 2, N'line', 10, 0 UNION ALL 
SELECT 1283, 568, 2, N'cable', 10, 0 UNION ALL 
SELECT 1284, 569, 2, N'courage', 10, 1 UNION ALL 
SELECT 1285, 570, 2, N'friend', 10, 1 UNION ALL 
SELECT 1286, 571, 2, N'(to )take', 10, 1 UNION ALL 
SELECT 1287, 572, 2, N'region', 10, 1 UNION ALL 
SELECT 1288, 573, 2, N'town', 10, 1 UNION ALL 
SELECT 1289, 573, 2, N'city', 10, 1 UNION ALL 
SELECT 1290, 574, 2, N'head', 10, 1 UNION ALL 
SELECT 1291, 575, 2, N'leg', 10, 1 UNION ALL 
SELECT 1292, 576, 2, N'stomach', 10, 1 UNION ALL 
SELECT 1293, 577, 2, N'hair', 10, 1 UNION ALL 
SELECT 1294, 578, 2, N'eye', 10, 1 UNION ALL 
SELECT 1295, 579, 2, N'ear', 10, 1 UNION ALL 
SELECT 1296, 580, 2, N'nose', 10, 1 UNION ALL 
SELECT 1297, 581, 2, N'nail', 10, 0 UNION ALL 
SELECT 1298, 581, 2, N'fingernail', 10, 1 UNION ALL 
SELECT 1299, 582, 2, N'finger', 10, 1 UNION ALL 
SELECT 1300, 583, 2, N'shoulder', 10, 1 UNION ALL 
SELECT 1301, 584, 2, N'neck', 10, 1 UNION ALL 
SELECT 1302, 585, 2, N'mouth', 10, 1 UNION ALL 
SELECT 1303, 586, 2, N'tooth', 10, 1 UNION ALL 
SELECT 1304, 587, 2, N'tongue', 10, 1 UNION ALL 
SELECT 1305, 588, 2, N'heart', 10, 1 UNION ALL 
SELECT 1306, 589, 2, N'liver', 10, 1 UNION ALL 
SELECT 1307, 590, 2, N'stomach', 10, 1 UNION ALL 
SELECT 1308, 591, 2, N'knee', 10, 1 UNION ALL 
SELECT 1309, 592, 2, N'elbow', 10, 1 UNION ALL 
SELECT 1310, 593, 2, N'foot', 10, 1 UNION ALL 
SELECT 1311, 594, 2, N'heel', 10, 1 UNION ALL 
SELECT 1312, 595, 2, N'cheek', 10, 1 UNION ALL 
SELECT 1313, 596, 2, N'eyebrow', 10, 1 UNION ALL 
SELECT 1314, 597, 2, N'eyelash', 10, 1 UNION ALL 
SELECT 1315, 598, 2, N'eyelid', 10, 1 UNION ALL 
SELECT 1316, 599, 2, N'forehead', 10, 1 UNION ALL 
SELECT 1317, 600, 2, N'spine', 10, 1 UNION ALL 
SELECT 1318, 601, 2, N'lung', 10, 1 UNION ALL 
SELECT 1319, 602, 2, N'vein', 10, 1 UNION ALL 
SELECT 1320, 603, 2, N'blood', 10, 1 UNION ALL 
SELECT 1321, 604, 2, N'throat', 10, 1 UNION ALL 
SELECT 1322, 605, 2, N'brain', 10, 1 UNION ALL 
SELECT 1323, 606, 2, N'mouse', 10, 1 UNION ALL 
SELECT 1324, 607, 2, N'rat', 10, 1 UNION ALL 
SELECT 1325, 608, 2, N'the Balkans', 10, 1 UNION ALL 
SELECT 1326, 609, 2, N'toe', 10, 1 UNION ALL 
SELECT 1327, 610, 2, N'that', 10, 1 
--INSERT INTO [dbo].[QuestionsOptions] ([Id], [QuestionId], [LanguageId], [Content], [Weight])
--SELECT 1, 1, 1, N'Idę do #1', 10 UNION ALL
--SELECT 2, 1, 2, N'I am going #2', 10
COMMIT;
SET IDENTITY_INSERT [dbo].[QuestionsOptions] OFF

GO



-- Warianty dla zapytań.
CREATE TABLE [dbo].[VariantSets] (
      [Id]				INT            IDENTITY (1, 1) NOT NULL
    , [QuestionId]			INT            NOT NULL
    , [LanguageId]		INT            NOT NULL
    , [VariantTag]		NVARCHAR (255) NOT NULL
    , [WordType]		INT            NOT NULL
    , [GrammarFormId]   INT			   NULL
    , [IsActive]		BIT            DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT            DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME       DEFAULT (GETDATE()) NOT NULL
    , CONSTRAINT [PK_VariantSets] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_VariantSets_QuestionLanguageTag] UNIQUE NONCLUSTERED ([QuestionId] ASC, [LanguageId] ASC, [VariantTag] ASC)
    , CONSTRAINT [FK_VariantSets_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id])
    , CONSTRAINT [FK_VariantSets_Language] FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages] ([Id])
    , CONSTRAINT [FK_VariantSets_Wordtype] FOREIGN KEY ([WordType]) REFERENCES [dbo].[WordTypes] ([Id])
    , CONSTRAINT [FK_VariantSets_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
	, CONSTRAINT [CH_VariantSets_GrammarFormDefinition] CHECK ([dbo].[checkGrammarDefinitionWordtype]([GrammarFormId]) = [WordType])	
);

GO
SET IDENTITY_INSERT [dbo].[VariantSets] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[VariantSets] ([Id], [QuestionId], [LanguageId], [VariantTag], [WordType], [GrammarFormId])
	SELECT 1, 1, 1, N'miejsce', 1, 11 UNION ALL 
	SELECT 2, 1, 2, N'place', 1, 12
COMMIT;
SET IDENTITY_INSERT [dbo].[VariantSets] OFF

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



-- Tabela przechowująca Varianty znajdujące się w VariantSetach
CREATE TABLE [dbo].[Variants] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [VariantSetId]	INT				NOT NULL
    , [Key]				NVARCHAR (255)	NOT NULL
    , [Content]			NVARCHAR (255)	NULL
    , [IsAnchored]		BIT				DEFAULT ((0)) NOT NULL
    , [IsActive]		BIT				DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT				DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME		DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT				DEFAULT ((0)) NOT NULL
    , [Positive]		INT				DEFAULT ((0)) NOT NULL
    , [Negative]		INT				DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_Variants] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_Variants_SetKey] UNIQUE NONCLUSTERED ([VariantSetId] ASC, [Key] ASC)
    , CONSTRAINT [FK_Variants_Set] FOREIGN KEY ([VariantSetId]) REFERENCES [dbo].[VariantSets] ([Id])
    , CONSTRAINT [FK_Variants_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
);


GO
SET IDENTITY_INSERT [dbo].[Variants] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[Variants] ([Id], [VariantSetId], [Key], [Content])
	SELECT 1, 1, 'dom', 'do domu' UNION ALL 
	SELECT 2, 1, 'szkoła', NULL UNION ALL 
	SELECT 3, 2, 'dom', 'home' UNION ALL
	SELECT 4, 2, 'szkoła', NULL
COMMIT;
SET IDENTITY_INSERT [dbo].[Variants] OFF

GO


CREATE FUNCTION [dbo].[checkWordtypeForVariant] (@Variant INT) 
RETURNS INT 
AS BEGIN

	DECLARE @VariantSet INT
	DECLARE @WordtypeId INT

	SET @VariantSet = (SELECT [v].[VariantSetId] FROM [dbo].[Variants] AS [v] WHERE [v].[Id] = @Variant)
	SET @WordtypeId = (SELECT [vs].[WordType] FROM [dbo].[VariantSets] AS [vs] WHERE [vs].[Id] = @VariantSet)

	RETURN @WordtypeId

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


-- Tabela maczująca warianty z przypisanymi do nich wyrazami.
CREATE TABLE [dbo].[MatchVariantWord] (
      [Id]				INT				IDENTITY (1, 1) NOT NULL
    , [VariantId]		INT				NOT NULL
    , [WordId]			INT				NOT NULL
    , [IsActive]		BIT				DEFAULT ((1)) NOT NULL
    , [CreatorId]		INT				DEFAULT ((1)) NOT NULL
    , [CreateDate]		DATETIME		DEFAULT (GETDATE()) NOT NULL
    , [IsApproved]		BIT				DEFAULT ((0)) NOT NULL
    , [Positive]		INT				DEFAULT ((0)) NOT NULL
    , [Negative]		INT				DEFAULT ((0)) NOT NULL
    , CONSTRAINT [PK_MatchVariantWord] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_MatchVariantWord_VariantWord] UNIQUE NONCLUSTERED ([VariantId] ASC, [WordId] ASC)
    , CONSTRAINT [FK_MatchVariantWord_Word] FOREIGN KEY ([WordId]) REFERENCES [dbo].[Words] ([Id])
    , CONSTRAINT [FK_MatchVariantWord_Variant] FOREIGN KEY ([VariantId]) REFERENCES [dbo].[Variants] ([Id])
    , CONSTRAINT [FK_MatchVariantWord_Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Users] ([Id])
	, CONSTRAINT [CH_MatchVariantWord_EqualWordtype] CHECK ([dbo].[checkWordtypeForVariant]([VariantId]) = [dbo].[checkWordtypeForWord]([WordId]))

);
GO
SET IDENTITY_INSERT [dbo].[MatchVariantWord] ON
BEGIN TRANSACTION;
	INSERT INTO [dbo].[MatchVariantWord] ([Id], [VariantId], [WordId])
	SELECT 1, 2, 297 UNION ALL 
	SELECT 2, 4, 708
COMMIT;
SET IDENTITY_INSERT [dbo].[MatchVariantWord] OFF

GO


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


--GO
--SET IDENTITY_INSERT [dbo].[VariantConnections] ON
--BEGIN TRANSACTION;
--#VariantConnections#
--COMMIT;
--SET IDENTITY_INSERT [dbo].[VariantConnections] OFF

GO


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


--GO
--SET IDENTITY_INSERT [dbo].[VariantDependencies] ON
--BEGIN TRANSACTION;
--#VariantDependencies#
--COMMIT;
--SET IDENTITY_INSERT [dbo].[VariantDependencies] OFF

GO


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


--GO
--SET IDENTITY_INSERT [dbo].[VariantLimits] ON
--BEGIN TRANSACTION;
--#VariantLimits#
--COMMIT;
--SET IDENTITY_INSERT [dbo].[VariantLimits] OFF










-- Tabela przechowująca listę zapytań wyłączonych dla poszczególnych userów.
CREATE TABLE [dbo].[LearningExcludedQuestions] (
      [Id]					INT     IDENTITY (1, 1) NOT NULL
    , [UserId]				INT     NOT NULL
    , [QuestionId]				INT		NOT NULL
    , CONSTRAINT [PK_LearningExcludedQuestions] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_LearningExcludedQuestions] UNIQUE NONCLUSTERED ([UserId] ASC, [QuestionId] ASC)
    , CONSTRAINT [FK_LearningExcludedQuestions_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [FK_LearningExcludedQuestions_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id])
);


GO
--SET IDENTITY_INSERT [dbo].[LearningExcludedQuestions] ON
--BEGIN TRANSACTION;
--#LearningExcludedQuestions#
--COMMIT;
--SET IDENTITY_INSERT [dbo].[LearningExcludedQuestions] OFF





-- Tabela przechowująca listę słów wyłączonych z nauki dla poszczególnych userów.
CREATE TABLE [dbo].[LearningExcludedWords] (
      [Id]					INT     IDENTITY (1, 1) NOT NULL
    , [UserId]				INT     NOT NULL
    , [WordId]				INT		NOT NULL
    , CONSTRAINT [PK_LearningExcludedWords] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_LearningExcludedWords] UNIQUE NONCLUSTERED ([UserId] ASC, [WordId] ASC)
    , CONSTRAINT [FK_LearningExcludedWords_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id])
    , CONSTRAINT [FK_LearningExcludedWords_Word] FOREIGN KEY ([WordId]) REFERENCES [dbo].[Words] ([Id])
);


--GO
--SET IDENTITY_INSERT [dbo].[LearningExcludedWords] ON
--BEGIN TRANSACTION;
--#LearningExcludedWords#
--COMMIT;
--SET IDENTITY_INSERT [dbo].[LearningExcludedWords] OFF


-- Tabela przechowująca listę słów wyłączonych z nauki dla poszczególnych userów.
CREATE TABLE [dbo].[TestResults] (
      [Id]					INT     IDENTITY (1, 1) NOT NULL
    , [UserId]				INT	NOT NULL			
    , [QuestionId]			INT	NOT NULL		
	, [BaseLanguage]		INT	NOT NULL	
	, [LearnedLanguage]		INT	NOT NULL	
	, [Last50]				VARCHAR(50)	DEFAULT ('') 
	, [Counter]				INT			DEFAULT((0)) 
	, [CorrectAnswers]		INT			DEFAULT((0)) 
	, [LastQuery]			DATETIME	DEFAULT((0)) 
	, [ToDo]			INT	DEFAULT((0)) 
    , CONSTRAINT [PK_TestResult] PRIMARY KEY CLUSTERED ([Id] ASC)
    , CONSTRAINT [U_UserQuestionLanguages] UNIQUE NONCLUSTERED ([UserId] ASC, [QuestionId] ASC, [BaseLanguage] ASC, [LearnedLanguage] ASC)
    , CONSTRAINT [FK_TestResult_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id])
	, CONSTRAINT [FK_TestResult_Question] FOREIGN KEY ([QuestionId]) REFERENCES [dbo].[Questions] ([Id])
    , CONSTRAINT [FK_TestResult_BaseLanguage] FOREIGN KEY ([BaseLanguage]) REFERENCES [dbo].[Languages] ([Id])
	, CONSTRAINT [FK_TestResult_LearnedLanguage] FOREIGN KEY ([LearnedLanguage]) REFERENCES [dbo].[Languages] ([Id])
);


rollback transaction;