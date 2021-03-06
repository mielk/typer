﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web.Mvc;
using Newtonsoft.Json.Linq;
using Typer.Domain.Services;

namespace Typer.Domain.Entities
{
    public class Metaword
    {

        public const int MinWeight = 1;
        public const int MaxWeight = 10;

        [HiddenInput(DisplayValue = false)]
        public int Id { get; set; }

        [Display(Name = "Name")]
        public string Name { get; set; }

        [Display(Name = "Weight")]
        public int Weight { get; set; }

        [Display(Name = "Type")]
        //public int Type { get; set; }
        public WordType Type { get; set; }

        [Display(Name = "Is active")]
        public bool IsActive { get; set; }

        [Display(Name = "Creator")]
        public int CreatorId { get; set; }

        [Display(Name = "Creating date")]
        public DateTime CreateDate { get; set; }

        [Display(Name = "Is approved")]
        public bool IsApproved { get; set; }

        [Display(Name = "Positive votes")]
        public int Positive { get; set; }

        [Display(Name = "Negative votes")]
        public int Negative { get; set; }

        private IEnumerable<Category> categories;

        private void LoadCategories()
        {
            categories = WordServicesFactory.Instance().GetService().GetCategories(Id);
        }

        private IEnumerable<Word> words;




        public Metaword()
        {
            Weight = 1;
        }

        public Metaword(string json)
        {
            JToken token = JObject.Parse(json);

            Id = (int)token.SelectToken("Id");
            Name = (string)token.SelectToken("Name");
            Weight = (int)token.SelectToken("Weight");
            Type = (WordType)(int)token.SelectToken("Type");
            IsActive = (bool)token.SelectToken("IsActive");
            CreatorId = (int)token.SelectToken("CreatorId");
            CreateDate = (DateTime)token.SelectToken("CreateDate");
            Categories = Category.GetCollection(token.SelectToken("Categories"));
            Words = Word.GetCollection(token.SelectToken("Words"));
        }



        public IEnumerable<Category> Categories
        {
            get
            {
                if (categories == null) LoadCategories();
                return categories;
            }

            set
            {
                categories = value;
            }

        }

        public IEnumerable<Word> Words
        {
            get
            {
                return words ?? (words = WordServicesFactory.Instance().GetService().GetWords(Id));
            }

            set
            {
                words = value;
            }

        }
        public IEnumerable<Word> GetWords(int languageId)
        {
            return words.Where(o => o.LanguageId == languageId);
        }


    }
}