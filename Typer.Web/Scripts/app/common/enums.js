﻿function Enum(items) {

    'use strict';

    var self = this;

    //Class signature.
    self.Enum = true;

    self.items = items;

    //Dodaje wartości przypisane do tej enumeracji,
    //jako metody tego obiektu.
    mielk.objects.each(items, function (key, item) {
        self[key] = item;
    });

}

Enum.prototype = {
    //Funkcja zwraca Enum o podanym kluczu lub id obiektu.
    getItem: function(value) {
        for (var key in this.items) {
            if (this.items.hasOwnProperty(key)) {
                var object = this.items[key];
                if (key === value || object.id === value) {
                    return object;
                }
            }
        }

        return null;

    },

    //Funkcja zwraca wszystkie wartości tego Enuma w postaci tablicy.
    //Możliwe jest podanie funkcji ograniczającej zwracany zestaw.
    getValues: function(filter) {
        var array = [];
        mielk.objects.each(this.items, function(key, item) {
            if (item && (!filter || mielk.fn.run(filter))) {
                var object = {
                    id: item.id || key,
                    name: item.name || key,
                    object: item
                };
                array.push(object);
            }
        });

        return array;

    },
    
    //Funkcja zwracająca domyślną wartość dla tego Enumeration.
    getDefault: function() {
        for (var key in this.items) {
            var item = this.items[key];
            if (item.isDefault) {
                return item;
            }
        }
        return null;
    }
    
};



$(function () {

    'use strict';

    var enums = (function () {

        var wordtypes = new Enum({
              NOUN: { id: 1, name: 'noun', symbol: 'N', isDefault: true }
            , VERB: { id: 2, name: 'verb', symbol: 'V' }
            , ADJECTIVE: { id: 3, name: 'adjective', symbol: 'A' }
            , OTHER: { id: 4, name: 'other', symbol: 'O' }
        });

        var languages = new Enum({
              POL: { code: 'POL', name: 'polski', isDefault: true }
            , ENG: { code: 'ENG', name: 'English' }
            , ESP: { code: 'ESP', name: 'Espanol' }
        });

        return {
              Languages: languages
            , Wordtypes: wordtypes
        };

    })();


    //Add as an item of STOCK library.
    Ling.Enums = enums;

});