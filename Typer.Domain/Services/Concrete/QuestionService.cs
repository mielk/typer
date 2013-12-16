﻿using System.Collections.Generic;
using System.Linq;
using Typer.DAL.Infrastructure;
using Typer.DAL.Repositories;
using Typer.Domain.Entities;
using Typer.Common.Helpers;
using Typer.DAL.TransferObjects;

// ReSharper disable once CheckNamespace
namespace Typer.Domain.Services
{
    public class QuestionService : IQuestionService
    {


        private readonly IQuestionsRepository _repository;
        private readonly ICategoryService _categoryService = CategoryServicesFactory.Instance().getService();

        public QuestionService(IQuestionsRepository repository)
        {
            _repository = repository ?? RepositoryFactory.GetQuestionsRepository();
        }


        public IEnumerable<Question> GetQuestions()
        {
            var dataObjects = _repository.GetQuestions();
            return dataObjects.Select(QuestionFromDto).ToList();
        }

        public Question GetQuestion(int id)
        {
            var dto = _repository.GetQuestion(id);
            return QuestionFromDto(dto);
        }



        public bool ChangeWeight(int id, int weight)
        {
            return _repository.UpdateWeight(id, weight.ToRange(Question.MinWeight, Question.MaxWeight));
        }


        public bool Activate(int id)
        {
            return _repository.Activate(id);
        }


        public bool Deactivate(int id)
        {
            return _repository.Deactivate(id);
        }

        public bool NameExists(string name)
        {
            return _repository.NameExists(name);
        }

        public bool NameExists(int id, string name)
        {
            var question = _repository.GetQuestion(name);

            if (question != null)
            {
                return (question.Id != id);
            }
            return false;
        }


        public bool UpdateQuestion(Question question)
        {
            return _repository.UpdateProperties(question.Id, question.Name, question.Weight);
        }

        public bool AddQuestion(Question question)
        {
            var dto = QuestionToDto(question);
            return _repository.AddQuestion(dto);
        }

        public IEnumerable<QuestionOption> GetOptions(int questionId)
        {
            var dataObjects = _repository.GetOptions(questionId);
            return dataObjects.Select(OptionFromDto).ToList();
        }


        public IEnumerable<Category> GetCategories(int questionId)
        {
            var dtos = _repository.GetCategories(questionId);
            return dtos.Select(dto => _categoryService.GetCategory(dto.CategoryId)).ToList();
        }



        private static Question QuestionFromDto(QuestionDto dto)
        {
            return new Question
            {
                CreateDate = dto.CreateDate,
                CreatorId = dto.CreatorId,
                Id = dto.Id,
                IsActive = dto.IsActive,
                IsApproved = dto.IsApproved,
                IsComplex = dto.IsComplex,
                Name = dto.Name,
                Negative = dto.Negative,
                Positive = dto.Positive,
                Weight = dto.Weight
            };
        }

        private static QuestionDto QuestionToDto(Question question)
        {
            return new QuestionDto
            {
                CreateDate = question.CreateDate,
                CreatorId = question.CreatorId,
                Id = question.Id,
                IsActive = question.IsActive,
                IsApproved = question.IsApproved,
                IsComplex = question.IsComplex,
                Name = question.Name,
                Negative = question.Negative,
                Positive = question.Positive,
                Weight = question.Weight
            };
        }


        private static QuestionOption OptionFromDto(QuestionOptionDto dto)
        {
            return new QuestionOption
            {
                Content = dto.Content,
                CreateDate = dto.CreateDate,
                CreatorId = dto.CreatorId,
                Id = dto.Id,
                IsActive = dto.IsActive,
                IsApproved = dto.IsApproved,
                IsComplex = dto.IsComplex,
                LanguageId = dto.LanguageId,
                Negative = dto.Negative,
                Positive = dto.Positive,
                QuestionId = dto.QuestionId,
                Weight = dto.Weight
            };
        }

/*
        private static QuestionOptionDto OptionToDto(QuestionOption option)
        {
            return new QuestionOptionDto
            {
                Content = option.Content,
                CreateDate = option.CreateDate,
                CreatorId = option.CreatorId,
                Id = option.Id,
                IsActive = option.IsActive,
                IsApproved = option.IsApproved,
                IsComplex = option.IsComplex,
                LanguageId = option.LanguageId,
                Negative = option.Negative,
                Positive = option.Positive,
                QuestionId = option.QuestionId,
                Weight = option.Weight
            };
        }
*/


    }
}