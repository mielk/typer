USE [ling];

SELECT 
  calculated.[Id]
, calculated.[Weight]
, calculated.[Last50]
, CASE 
		WHEN 
			calculated.[ToDo] > 0 

		THEN 
			calculated.[ToDo] 
			
		ELSE
			CASE 
				WHEN 
					(calculated.[Last] + calculated.[Average] + calculated.[Correct]) / 200 > 5
				THEN
					5
				ELSE
					(calculated.[Last] + calculated.[Average] + calculated.[Correct]) / 200
				END

		 END

	AS [queries]


FROM
(SELECT
  uq.*
, CASE WHEN uq.[LastQuery] IS NULL THEN 100 ELSE 
	POWER(
			  (CONVERT( DECIMAL(10,2), DATEDIFF ( 
										ss, 
										uq.[LastQuery], 
										GETDATE() 
									) 
					)
			  ) / 86400
			, (uq.[Weight] * 0.6)
		) END AS [Last]
, (1 - CASE WHEN uq.[Counter] > 0 THEN uq.[CorrectAnswers] / uq.[Counter] ELSE 0 END) * 900 AS [Average]
, (50 - ( 2 * 
			(LEN(uq.[Last50]) - LEN(REPLACE(uq.[Last50], '1', '')))  *
			 LEN(uq.[Last50]) - LEN(REPLACE(uq.[Last50], '0', ''))))
	*
	uq.[Weight] * 2.5 AS [Correct]

FROM
(SELECT
  q.[Id]
, q.[Weight]
, COALESCE(tr.[Last50], '') AS [Last50]
, tr.[LastQuery] AS [LastQuery]
, COALESCE(tr.[Counter], 0) AS [Counter]
, COALESCE(tr.[CorrectAnswers], 0) AS [CorrectAnswers]
, COALESCE(tr.[ToDo], 0) AS [ToDo]

FROM
[dbo].[Questions] q
LEFT JOIN

(
	SELECT 
		  a.*
	FROM 
		[dbo].[TestResults] a
	WHERE 
		a.[UserId] = 1 AND
		a.[BaseLanguage] = 1 AND
		a.[LearnedLanguage] = 2
) tr
	
ON q.Id = tr.[QuestionId]

WHERE
q.[IsActive] = 1) 
	
	AS uq)

		AS calculated;