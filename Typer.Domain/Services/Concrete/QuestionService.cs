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
        private readonly ICategoryService _categoryService = CategoryServicesFactory.Instance().GetService();

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


        public bool UpdateCategories(int id, int[] categoriesId)
        {
            return _repository.UpdateCategories(id, categoriesId);
        }


        public bool Update(int id, string name, int weight, int[] categories, string[] dependencies, string[] connections, string[] editedSets, 
            string[] properties, string[] editedVariants, string[] addedVariants, string[] limits)
        {
            return false;
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

        public IEnumerable<QuestionOption> GetOptions(int questionId, int[] languages)
        {
            var dataObjects = _repository.GetOptions(questionId, languages);
            return dataObjects.Select(OptionFromDto).ToList();
        }


        public IEnumerable<Category> GetCategories(int questionId)
        {
            var dtos = _repository.GetCategories(questionId);
            return dtos.Select(dto => _categoryService.GetCategory(dto.CategoryId)).ToList();
        }

        public IEnumerable<Question> Filter(int lowWeight, int upWeight, int[] categories, string text)
        {
            var dtos = _repository.GetQuestions();

            if (lowWeight > 0) dtos = dtos.Where(q => q.Weight >= lowWeight);
            if (upWeight > 0) dtos = dtos.Where(q => q.Weight <= upWeight);
            if (text.Length > 0) dtos = dtos.Where(q => q.Name.ToLower().Contains(text.ToLower()));
            if (categories == null || categories.Length <= 0) return dtos.Select(QuestionFromDto).ToList();
            var byCategories = _repository.GetQuestionsIdsByCategories(categories);
            dtos = dtos.Where(q => byCategories.Contains(q.Id));

            return dtos.Select(QuestionFromDto).ToList();

        }

        public Question GetQuestionDetails(int id, int currentUserId)
        {

            //Get main Question object.
            var dto = _repository.GetQuestion(id);
            Question question = QuestionFromDto(dto);

            //Get sets and variants for the given question.
            var sets = GetQuestionVariantSets(id, currentUserId);
            var variants = GetVariants(sets.Keys);

            //Assign variants to the proper variant set.
            foreach (var variant in variants)
            {
                VariantSet set;
                sets.TryGetValue(variant.VariantSetId, out set);
                if (set != null)
                {
                    set.AddVariant(variant);
                }
            }

            question.VariantSets = sets.Values.ToList();

            return question;

        }

        private Dictionary<int, VariantSet> GetQuestionVariantSets(int questionId, int currentUserId)
        {
            var languageRepository = new EFLanguageRepository();
            var languages = languageRepository.GetUserLanguages(currentUserId);

            //Fetch variant sets.
            var sets = _repository.GetVariantSets(questionId, languages);

            //Create map of sets.
            var map = new Dictionary<int, VariantSet>();
            foreach (var set in sets)
            {
                map.Add(set.Id, VariantSetFromDto(set));
            }

            //Load connections between variant sets.
            var connections = _repository.GetVariantSetsConnections(sets.Select(s => s.Id));
            foreach (var connection in connections)
            {
                VariantSet baseSet;
                VariantSet connectedSet;
                map.TryGetValue(connection.VariantSetId, out baseSet);
                map.TryGetValue(connection.ConnectedSetId, out connectedSet);

                if (baseSet != null && connectedSet != null)
                {
                    baseSet.AddRelated(connectedSet.Id);
                    connectedSet.AddRelated(baseSet.Id);
                }
            }

            //Load limits between variant sets.
            var limits = _repository.GetVariantSetsLimits(sets.Select(s => s.Id));
            foreach (var limit in limits)
            {
                //TODO
            }

            //Load dependencies between variant sets.
            var dependencies = _repository.GetVariantSetsDependencies(sets.Select(s => s.Id));
            foreach (var dependency in dependencies)
            {
                //TODO
            }

            return map;

        }

        private IEnumerable<Variant> GetVariants(IEnumerable<int> sets)
        {

            //Load variants.
            var variants = _repository.GetVariants(sets);
            var map = new Dictionary<int, Variant>();
            foreach (var variant in variants)
            {
                map.Add(variant.Id, VariantFromDto(variant));
            }

            var variantWords = _repository.GetVariantWordMatching(variants.Select(v => v.Id));
            foreach (var word in variantWords)
            {
                Variant variant;
                map.TryGetValue(word.VariantId, out variant);
                if (variant != null)
                {
                    variant.AddWord(word.WordId);
                }
            }

            return map.Values;

        }



        //public IEnumerable<VariantSet> GetVariantSets(int questionId, int[] languages)
        //{
        //    var dtos = _repository.GetVariantSets(questionId, languages);
        //    var setMap = new Dictionary<int, VariantSet>();
        //    var sets = new List<VariantSet>();
        //    var variantMap = new Dictionary<int, Variant>();
            
        //    foreach (var set in dtos.Select(VariantSetFromDto))
        //    {
        //        var variants = GetVariants(set.Id);

        //        foreach (var variant in variants)
        //        {
        //            variantMap.Add(variant.Id, variant);
        //            set.AddVariant(variant);
        //        }

        //        sets.Add(set);
        //        setMap.Add(set.Id, set);
        //    }


        //    //Load limits
        //    var limits = _repository.GetVariantLimits(questionId);
        //    foreach (var limit in limits)
        //    {
        //        Variant limited;
        //        Variant limiting;

        //        if (!variantMap.TryGetValue(limit.VariantId, out limited)) continue;
        //        if (!variantMap.TryGetValue(limit.ConnectedVariantId, out limiting)) continue;

        //        limited.AddExcluded(limiting);
        //        limiting.AddExcluded(limited);

        //    }


        //    //Load dependencies
        //    var setsIds = sets.Select(s => s.Id).ToArray();
        //    var dependencies = _repository.GetVariantDependencies(setsIds);
        //    foreach (var dependency in dependencies)
        //    {
        //        VariantSet parent;
        //        VariantSet dependant;
        //        if (!setMap.TryGetValue(dependency.MainSetId, out parent)) continue;
        //        if (!setMap.TryGetValue(dependency.DependantSetId, out dependant)) continue;

        //        parent.AddDependant(dependant);
        //        dependant.ParentId = parent.Id;

        //    }

        //    //Load connections
        //    var connections = _repository.GetVariantConnections(setsIds);
        //    foreach (var connection in connections)
        //    {
        //        VariantSet connected;
        //        VariantSet connecting;
        //        if (!setMap.TryGetValue(connection.VariantSetId, out connected)) continue;
        //        if (!setMap.TryGetValue(connection.ConnectedSetId, out connecting)) continue;

        //        connected.AddRelated(connecting);
        //        connecting.AddRelated(connected);

        //    }

        //    return sets;

        //}



        //public IEnumerable<DependencyDefinition> GetDependenciesDefinitions(int[] languages)
        //{
        //    var dtos = _repository.GetDependenciesDefinitions(languages);
        //    return dtos.Select(DependencyDefinitionFromDto).ToList();
        //}

        //public IEnumerable<VariantSetPropertyDefinition> GetVariantSetPropertiesDefinitions(int wordtypeId, int languageId)
        //{
        //    var dtos = _repository.GetVariantSetPropertiesDefinitions(wordtypeId, languageId);
        //    return dtos.Select(VariantSetPropertyDefinitionFromDto).ToList();
        //}

        //public IEnumerable<VariantSetPropertyValue> GetVariantSetPropertiesValues(int id)
        //{
        //    var dtos = _repository.GetVariantSetPropertiesValues(id);
        //    return dtos.Select(VariantSetPropertyValueFromDto).ToList();
        //}

        //public IEnumerable<Variant> GetVariantsForQuestion(int questionId, int[] languages)
        //{
        //    var dtos = _repository.GetVariantsForQuestion(questionId, languages);
        //    return dtos.Select(VariantFromDto).ToList();
        //}

        //public IEnumerable<Variant> GetVariantsForVariantSet(int variantSetId)
        //{
        //    var dtos = _repository.GetVariantsForVariantSet(variantSetId);
        //    return dtos.Select(VariantFromDto).ToList();
        //}

        ////public IEnumerable<GrammarFormDefinitionProperty> 

        //public int GetGrammarDefinitionId(int variantSetId)
        //{
        //    return _repository.GetGrammarDefinitionId(variantSetId);
        //}


        private static DependencyDefinition DependencyDefinitionFromDto(DependencyDefinitionDto dto)
        {
            return new DependencyDefinition
            {
                Id = dto.Id,
                LanguageId = dto.LanguageId,
                MasterWordtypeId = dto.MasterWordtypeId,
                SlaveWordtypeId = dto.SlaveWordtypeId
            };
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
                QuestionId = dto.QueryId,
                Weight = dto.Weight
            };
        }

        private static Variant VariantFromDto(VariantDto dto)
        {
            return new Variant
            {
                Content = dto.Content,
                CreateDate = dto.CreateDate,
                CreatorId = dto.CreatorId,
                Id = dto.Id,
                IsAnchored = dto.IsAnchored,
                IsActive = dto.IsActive,
                IsApproved = dto.IsApproved,
                Key = dto.Key,
                Negative = dto.Negative,
                Positive = dto.Positive,
                VariantSetId = dto.VariantSetId
            };
        }

        private static VariantSet VariantSetFromDto(VariantSetDto dto)
        {
            return new VariantSet
            {
                CreateDate = dto.CreateDate,
                CreatorId = dto.CreatorId,
                Id = dto.Id,
                IsActive = dto.IsActive,
                LanguageId = dto.LanguageId,
                WordType = dto.WordType,
                GrammarFormId = dto.GrammarFormId,
                QuestionId = dto.QueryId,
                VariantTag = dto.VariantTag
            };
        }


        //private static GrammarFormDefinitionProperty grammarFormDefinitionPropertyFromDto(
        //    GrammarFormDefinitionPropertyDto dto)
        //{
        //    return new GrammarFormDefinitionProperty
        //    {
        //        Id = dto.Id,
        //        IdDefinition = dto.IdDefinition,
        //        IdProperty = dto.IdProperty,
        //        Value = dto.Value
        //    };
        //}

    }
}