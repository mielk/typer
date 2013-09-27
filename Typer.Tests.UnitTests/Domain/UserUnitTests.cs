﻿using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Typer.Domain.Entities;
using Typer.Domain.Helpers;
using Moq;

namespace Typer.Tests.UnitTests.Domain
{
    [TestClass]
    public class UserUnitTests
    {


        #region TestInitialization
        public UserUnitTests()
        {
        }

        //private Mock<IUsersRepository> createMockUsersRepository()
        //{
        //    Mock<IUsersRepository> mockedUsersRepository = new Mock<IUsersRepository>();
        //    addUserToMockRepository(mockedUsersRepository, new User { UserID = 1, UserName = "test", Password = "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"} );
        //    addUserToMockRepository(mockedUsersRepository, new User { UserID = 2, UserName = "test2", Password = "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"} );
        //    addUserToMockRepository(mockedUsersRepository, new User { UserID = 3, UserName = "test3", Password = "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"} );

        //    return mockedUsersRepository;

        //}

        //private void addUserToMockRepository(Mock<IUsersRepository> mockRepo, User user){
        //    mockRepo.Setup(m => m.getUser(user.UserID)).Returns(user);
        //    mockRepo.Setup(m => m.logUser(user.UserName, user.Password)).Returns(true);
        //}
        #endregion TestInitialization




        //[TestMethod]
        //public void User_IsAuthenticated_return_false_for_empty_username()
        //{
        //    User user = new User { UserName = "", Password = "test" };
        //    Assert.IsFalse(user.IsAuthenticated());
        //}

        //[TestMethod]
        //public void User_IsAuthenticated_return_false_for_empty_password()
        //{
        //    User user = new User { UserName = "test", Password = "" };
        //    Assert.IsFalse(user.IsAuthenticated());
        //}

        //[TestMethod]
        //public void User_IsAuthenticated_return_false_for_non_existing_user()
        //{
        //    User user = new User { UserName = "NonExistingUser", Password = "test" };
        //    Assert.IsFalse(user.IsAuthenticated());
        //}

        //[TestMethod]
        //public void User_IsAuthenticated_return_false_for_wrong_password()
        //{
        //    User user = new User { UserName = "test", Password = "Test" };
        //    Assert.IsFalse(user.IsAuthenticated());
        //}

        //[TestMethod]
        //public void User_IsAuthenticated_return_true_for_proper_password()
        //{
        //    User user = new User { UserName = "test", Password = "test" };
        //    Assert.IsTrue(user.IsAuthenticated());

        //    User user2 = new User { UserName = "test2", Password = "test" };
        //    Assert.IsTrue(user2.IsAuthenticated());

        //}


    }
}
