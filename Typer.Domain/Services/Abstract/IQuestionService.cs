﻿using System.Collections.Generic;
using Typer.Domain.Entities;

// ReSharper disable once CheckNamespace
namespace Typer.Domain.Services
{
    public interface IQuestionService
    {
        IEnumerable<Question> GetQuestions();
        Question GetQuestion(int id);
        bool ChangeWeight(int id, int weight);
        bool Activate(int id);
        bool Deactivate(int id);
        bool NameExists(string name);
        bool NameExists(int id, string name);
        bool UpdateQuestion(Question question);
        bool AddQuestion(Question question);
        IEnumerable<QuestionOption> GetOptions(int questionId);
        IEnumerable<Category> GetCategories(int questionId);
    }
}
