﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Typer.Domain.Abstract;
using Typer.Domain.Entities;

namespace Typer.Domain.Concrete
{
    public class EFUsersRepository : IUsersRepository
    {

        private static IUsersRepository instance;
        private EFDbContext context = new EFDbContext();
        

        private EFUsersRepository()
        {
            
        }

        public static IUsersRepository getInstance()
        {
            if (instance == null)
            {
                instance = new EFUsersRepository();
            }
            return instance;
        }


        //------------

        public User getUser(int userID)
        {
            return context.Users.Single(u => u.UserID == userID);
        }

        public User getUser(string username, string password)
        {
            return context.Users.Single(u => u.UserName == username && u.Password == password);
        }

    }
}