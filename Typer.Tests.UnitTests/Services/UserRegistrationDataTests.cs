﻿using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Typer.Domain.Services;
using Typer.Domain.Entities;
using Typer.Common.Helpers;
using Moq;

// ReSharper disable once CheckNamespace
namespace Typer.Tests.UnitTests.Domain
{
    [TestClass]
    public class UserRegistrationDataTests
    {

        private readonly UserRegistrationData urd;
        private const string Username = "abcde";
        private const string Password = "haslo1";
        private const string ConfirmPassword = "haslo1";
        private const string Email = "mail@mail.com";
        private const string ExistingUsername = "existing_user";
        private const string ExistingMail = "existing@mail.com";


        public UserRegistrationDataTests()
        {
            var mockService = new Mock<IUserService>();
            mockService.Setup(m => m.UserExists(ExistingUsername)).Returns(true);
            mockService.Setup(m => m.UserExists(It.IsNotIn(ExistingUsername))).Returns(false);
            mockService.Setup(m => m.MailExists(ExistingMail)).Returns(true);
            mockService.Setup(m => m.MailExists(It.IsNotIn(ExistingMail))).Returns(false);

            urd = new UserRegistrationData(mockService.Object);
            AssignValidDataSet(urd);

        }




        [TestMethod]
        public void for_proper_data_set_object_is_valid()
        {
            AssignValidDataSet(urd);
            Assert.IsTrue(urd.IsValid());
        }


        [TestMethod]
        public void if_username_is_too_short_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Username = "a";
            Assert.IsFalse(urd.IsValid());

            urd.Username = new string('a', UserRegistrationData.UserNameMinimumLength - 1);
            Assert.IsFalse(urd.IsValid());

        }


        [TestMethod]
        public void if_username_is_too_long_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Username = new string('a', UserRegistrationData.UserNameMaximumLength + 1);
            Assert.IsFalse(urd.IsValid());
        }


        [TestMethod]
        public void if_username_is_empty_or_null_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Username = "";
            Assert.IsFalse(urd.IsValid());

            urd.Username = null;
            Assert.IsFalse(urd.IsValid());
        }


        [TestMethod]
        public void for_existing_username_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Username = ExistingUsername;
            Assert.IsFalse(urd.IsValid());
        }


        [TestMethod]
        public void if_password_is_empty_or_null_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Password = "";
            Assert.IsFalse(urd.IsValid());

            urd.Password = null;
            Assert.IsFalse(urd.IsValid());

        }


        [TestMethod]
        public void if_password_is_too_short_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Password = new string('a', UserRegistrationData.PasswordMinimumLength - 1);
            Assert.IsFalse(urd.IsValid());
        }


        [TestMethod]
        public void if_password_contains_no_letter_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Password = "12345678_0";
            Assert.IsFalse(urd.IsValid());
        }

        [TestMethod]
        public void if_password_contain_no_number_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Password = "abcdefghijkl_";
            Assert.IsFalse(urd.IsValid());
        }


        [TestMethod]
        public void if_confirm_password_is_empty_or_null_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.ConfirmPassword = "";
            Assert.IsFalse(urd.IsValid());

            urd.ConfirmPassword = null;
            Assert.IsFalse(urd.IsValid());

        }


        [TestMethod]
        public void if_passwords_doesnt_match_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Password = "H@sl01";
            urd.ConfirmPassword = "H@sl02";
            Assert.IsFalse(urd.IsValid());
        }


        [TestMethod]
        public void if_mail_is_illegal_data_are_invalid()
        {
            AssignValidDataSet(urd);
            string[] illegalMails = { "mail.o2.pl", "mail@o2", "@o2.pl", "mail mail@o2.pl", "mail@o2.pl.", "mail@o2..pl" };

            foreach (var mail in illegalMails)
            {
                urd.Email = mail;
                Assert.IsFalse(urd.IsValid());
            }

        }


        [TestMethod]
        public void if_mail_is_not_unique_data_are_invalid()
        {
            AssignValidDataSet(urd);
            urd.Email = ExistingMail;
            Assert.IsFalse(urd.IsValid());
        }


        [TestMethod]
        public void convertion_to_user_returns_proper_object()
        {
            AssignValidDataSet(urd);
            var user = urd.ToUser();

            Assert.AreEqual(Username, user.Username);
            Assert.AreEqual(Sha1.Encode(Password), user.Password);
            Assert.AreEqual(Email, user.Email);
            Assert.IsFalse(user.MailVerified);
            Assert.IsTrue(user.IsActive);
            Assert.IsNull(user.FirstName);
            Assert.IsNull(user.LastName);
            Assert.IsNull(user.DateOfBirth);
            Assert.IsNull(user.CountryId);

            var today = DateTime.Today;
            if (user.RegistrationDate != null) Assert.AreEqual((object) today.Date, user.RegistrationDate.Value.Date);
        }



        private static void AssignValidDataSet(UserRegistrationData urd)
        {
            urd.Username = Username;
            urd.Password = Password;
            urd.ConfirmPassword = ConfirmPassword;
            urd.Email = Email;
        }


    }
}
