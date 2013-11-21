﻿var data = [
                    {
                        key: 1,
                        caption: 'a',
                        expanded: true,
                        items: [
                            { key: 11, caption: 'aa', expanded: true, selected: true, items: [] },
                            { key: 12, caption: 'ab', expanded: true, selected: false, items: [] }
                        ]
                    },
                    {
                        key: 2,
                        caption: 'b',
                        expanded: false,
                        items: [
                            {
                                key: 21, caption: 'ba', expanded: true, items: [
                                    { key: 211, caption: 'bjtaa', expanded: true, items: [] },
                                    {
                                        key: 212, caption: 'bab', expanded: false, items: [
                                                                            { key: 2221, caption: 'baaa', expanded: true, items: [] },
                                                                            {
                                                                                key: 2222, caption: 'baab', expanded: true, items: [
                                                                                    {
                                                                                        key: 22221, caption: 'baaba', expanded: true, items: [

                                                                                        ]
                                                                                    }
                                                                                ]
                                                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                key: 22, caption: 'bb', expanded: true, items: [
                                    { key: 221, caption: 'bba', expanded: true, items: [] },
                                    {
                                        key: 222, caption: 'bbb', expanded: false, items: [
                                                                            { key: 2221, caption: 'baba', expanded: true, items: [] },
                                                                            {
                                                                                key: 2222, caption: 'babb', expanded: true, items: [
                                                                                    {
                                                                                        key: 22221, caption: 'babba', expanded: true, items: [

                                                                                        ]
                                                                                    }
                                                                                ]
                                                                            }
                                        ]
                                    },
                                    { key: 223, caption: 'bbc', expanded: true, items: [] }
                                ]
                            },
                            { key: 23, caption: 'bc', expanded: true, items: [] },
                        ]
                    },
                    {
                        key: 3,
                        caption: 'c',
                        expanded: true,
                        items: [
                                    { key: 311, caption: 'caa', expanded: true, items: [] },
                                    {
                                        key: 312, caption: 'cab', expanded: false, items: [
                                                                            { key: 3121, caption: 'cabd', expanded: true, items: [] }
                                        ]
                                    },
                        ]
                    },
                    {
                        key: 4,
                        caption: 'd',
                        expanded: true,
                        items: [
                            {
                                key: 41, caption: 'da', expanded: true, items: [
                                    {
                                        key: 411, caption: 'daa', expanded: true, items: [
                                            { key: 4121, caption: 'dabd', expanded: true, items: [] }
                                        ]
                                    },
                                    {
                                        key: 412, caption: 'dab', expanded: false, items: [
                                                                            { key: 4121, caption: 'dabd', expanded: true, items: [] }
                                        ]
                                    },
                                ]
                            }
                        ]
                    }
];


var MODE = {
    NONE: 0,
    SINGLE: 1,
    MULTI: 2
};


$(function () {
    var container = $('#tree_container')[0];
    var tree = new TreeView(container, MODE.MULTI, data);


    //Switching off selecting text.
    $(document).
        bind({
            'mousedown': function (e) {
                var $this = $(this);
                e.preventDefault();

                // Make every element on page unselectable
                //$('*').addClass('unselectable');
                $(document.body).addClass('unselectable');

                // Some setup here, like remembering the original location, etc
                $(window).on('mousemove', function (e) {
                    // Do the thing!
                    $this.on('mouseup', function (e) {
                        $(document.body).removeClass('unselectable');
                        //$('*').removeClass('unselectable');
                        // Other clean-up tasks here
                    });
                });
            }
        });

});




function TreeView(container, mode, data) {
    var me = this;
    this.container = container;
    this.mode = mode;
    this.events = jQuery('<div/>', {
        'class': 'events-container'
    }).appendTo(this.container);

    this.getContainer = function () {
        return this.container;
    }

    this.root = new TreeNode(me, 'root', 'root', me, true);
    this.root.loadData(data);


    this.dragDropManager = (function () {
        var drag = null;
        var drop = null;

        $(document).bind({
            'mousemove': function (e) {
                e.preventDefault();
                if (e && drag) {

                    var x = e.pageX;
                    var y = e.pageY;

                    if (drop) {
                        var previousArea = drop.dropArea;
                        if (previousArea.isHovered(x, y)) {
                            return;
                        } else {
                            previousArea.unselect();
                        }
                    } else {
                        me.root.dropArea.check(x, y);
                    }
                }
            }
        });

        $(me.events).bind({
            dropin: function (e) {
                if (e.node !== drag) {
                    drop = e.node;
                    $('#drop').html('Drop: ' + drop.getName());
                }
            },
            dropout: function (e) {
                if (drop === e.node) {
                    drop = null;
                    $('#drop').html('Drop: ' + 'null');
                }
            },
            dragin: function (e) {
                drag = e.node;
                $('#drag').html('Drag: ' + drag.getName());
            },
            dragout: function (e) {
                $('#drag').html('Drag: ' + 'null');
                if (drag && drop) {
                    me.trigger({
                        type: 'transfer',
                        node: drag,
                        to: drop
                    });
                    drag = null;
                }
            },
            transfer: function (e) {
                if (e.node && e.to) {
                    e.node.transfer(e.to);
                }
            }
        });


        return {
            hasDropArea: function () {
                return (drop ? true : false);
            },
            getDrag: function () {
                return drag;
            }
        }

    })();

    this.activeNode = null;

    this.events.bind({
        expand: function (e) {
            me.root.dropArea.recalculate();
        },
        collapse: function (e) {
            me.root.dropArea.recalculate();
        },
        activate: function (e) {
            if (me.activeNode) {
                me.activeNode.inactivate();
            }
            me.activeNode = e.node;
        },
        inactivate: function (e) {
            if (me.activeNode === e.node) {
                me.activeNode = null;
            }
        },
        'delete': function (e) {
            alert('Node ' + e.node.name + ' deleted');
        },
        newNode: function (e) {
            e.node.activate();
        },
        confirm: function (e) {
            alert('Selected: ' + e.item.name);
            me.close();
        }
    });


    this.navigator = (function () {

        $(document).bind({
            'keydown': function (e) {

                if (me.activeNode != null && me.activeNode.renamer.isActive()) {
                    return;
                }

                //Escape applies even for the case if none node is selected.
                if (e.which === 27) {
                    alert('Escape');
                }

                if (me.activeNode) {
                    switch (e.which) {
                        case 37: //Arrow left
                            _collapse();
                            e.stopPropagation();
                            break;
                        case 38: //Arrow up
                            e.stopPropagation();
                            e.preventDefault();
                            _moveUp();
                            break;
                        case 39: //Arrow right
                            _expand();
                            e.stopPropagation();
                            break;
                        case 40: //Arrow down
                            e.stopPropagation();
                            e.preventDefault();
                            _moveDown();
                            break;
                        case 36: //Home
                            e.stopPropagation();
                            e.preventDefault();
                            _moveToParent();
                            break;
                        case 35: //End
                            e.stopPropagation();
                            e.preventDefault();
                            break;
                        case 33: //PageUp
                            e.stopPropagation();
                            e.preventDefault();
                            _moveToRoot();
                            break;
                        case 34: //PageDown
                            e.stopPropagation();
                            e.preventDefault();
                            _moveToLastItem();
                            break;
                        case 113: //F2
                            e.stopPropagation();
                            e.preventDefault();
                            me.activeNode.renamer.activate();
                            break;
                        case 46: //Delete
                            e.stopPropagation();
                            e.preventDefault();
                            me.activeNode.delete();
                            _moveToParent();
                            break;
                        case 45: //Insert
                            e.stopPropagation();
                            e.preventDefault();
                            _addNewNode();
                            break;
                        case 13: //Enter
                            e.stopPropagation();
                            e.preventDefault();
                            switch (me.mode) {
                                case MODE.SINGLE: _selectActive(); break;
                                case MODE.MULTI: _confirm(); break;
                            }
                            break;
                            //Confirmation.
                        case 32: //Space
                            e.stopPropagation();
                            e.preventDefault();
                            switch (me.mode) {
                                case MODE.SINGLE: _selectActive(); break;
                                case MODE.MULTI: me.activeNode.select(); break;
                            }
                            break;
                    }
                }

            }

        });

        function _confirm() {
            me.trigger({
                'type': 'confirm',
                'items': _getSelectedArray()
            });
        }

        
        function _getSelectedArray() {

        }


        function _selectActive() {
            me.trigger({
                'type': 'confirm',
                'item' : me.activeNode
            });
        }

        function _addNewNode() {
            var expander = me.activeNode.expander;
            if (!expander.isExpanded()) {
                expander.expand();
            }
            me.activeNode.addNewNode();
        }

        function _expand() {
            if (me.activeNode.expander) {
                me.activeNode.expander.expand();
            }
        }

        function _collapse() {
            if (me.activeNode.expander) {
                me.activeNode.expander.collapse();
            }
        }

        function _moveToParent() {
            if (!me.activeNode.isRoot()) {
                changeSelection(me.activeNode.parent);
            }
        }

        function _moveToRoot() {
            changeSelection(me.root);
        }

        function _moveToLastItem() {
            var node = me.root;
            while (node.expander.isExpanded()) {
                node = node.getLastChild();
            }
            changeSelection(node);
        }

        function _moveUp() {
            var previousNode = me.activeNode.previousNode();
            if (previousNode) {

                var node = previousNode;
                while (node.expander.isExpanded()) {
                    node = node.getLastChild();
                }
                changeSelection(node);
            } else {
                if (!me.activeNode.isRoot()) {
                    changeSelection(me.activeNode.parent);
                }
            }
        }

        function _moveDown() {
            if (me.activeNode.expander && me.activeNode.expander.isExpanded()) {
                var childNode = me.activeNode.getChildNode(0);
                if (childNode) {
                    changeSelection(childNode);
                }
            } else {
                if (!me.activeNode.isRoot()) {
                    var nextNode = me.activeNode.nextNode();

                    var parent = me.activeNode.parent;
                    while (nextNode === null && parent.isNode) {
                        nextNode = parent.nextNode();
                        parent = parent.parent;
                    }

                    if (nextNode) {
                        changeSelection(nextNode);
                    }

                }
            }
        }

        function changeSelection(node) {
            me.activeNode.inactivate();
            node.activate();
        }

    })();

    this.root.activate();

}

TreeView.prototype.trigger = function (e) {
    this.events.trigger(e);
}
TreeView.prototype.close = function () {
    $(this.container).css({
        'display' : 'none'
    });
}


function TreeNode(tree, key, name, parent, expanded, selected) {
    var me = this;
    this.tree = tree;
    this.key = key;
    this.name = name;
    this.parent = parent;
    this.nodes = {};
    this.nodesArray = [];
    this.index = 0;
    this.mouseClicked = false;
    this.isActive = false;
    this.isNode = true;

    this.mainContainer = jQuery('<div/>', {
        id: key + '_container',
        'class': 'node-container'
    }).appendTo($(this.parent.getContainer()));


    this.line = jQuery('<div/>', {
        id: key,
        'class': 'line'
    }).appendTo(this.mainContainer);

    this.container = jQuery('<div/>', {
        id: key,
        'class': 'children-container'
    }).appendTo(this.mainContainer);



    this.expander = (function (value) {
        //var _ = this;
        var expandable = false;
        var expanded = value;
        var button = jQuery('<div/>', {
                id: me.key + '_expand-collapse-button',
                'class': 'icon '
            }).
            bind({
                'click': function (e) {
                    if (expandable) {
                        e.preventDefault();
                        _revertStatus();
                    }
                }
            }).
            appendTo(me.line);

        function _expand() {
            if (!expandable) {
                return;
            }

            expanded = true;
            $(button).html('-');
            display(me.container, true);
            me.tree.trigger({
                type: 'expand',
                node: me
            });
        }

        function _collapse() {
            if (!expandable) {
                return;
            }
            
            expanded = false;
            $(button).html('+');
            display(me.container, false);
            me.tree.trigger({
                type: 'collapse',
                node: me
            });
        }

        function _revertStatus() {
            if (expanded === true) {
                _collapse();
            } else if (expanded === false) {
                _expand();
            }
        }


        function _setStatus(value) {
            if (value === true) {
                _expand();
            } else if (value === false) {
                _collapse();
            }

        }

        function _setExpandableStatus(value) {
            show(this.expandButton);
            expandable = value;
            if (!expandable) {
                $(button).html('.');
            } else {
                _setStatus(expanded);
            }
        }


        //Sets initial status.
        (function () {
            _setExpandableStatus(expandable);
        })();


        return {
            setExpandableStatus: function (value) {
                _setExpandableStatus(value);
            },
            revertStatus : function () {
                _revertStatus();
            },
            setStatus: function (value) {
                _setStatus(value);
            },
            expand: function(){
                _expand();
            },
            collapse: function(){
                _collapse();
            },
            isExpanded: function () {
                return (expandable === false || expanded === false ? false : true);
            }
        }

    })(expanded);

    this.selector = (function () {
        var selected = false;
        var hasSelectedChildren = false;

        var box = jQuery('<input/>', {
            type: 'checkbox',
            id: me.key + '_select-checkbox',
            'class': 'select-checkbox'
        }).css({
            'display': (me.tree.mode === MODE.MULTI ? true : false)
        }).bind({
            'click': function () {
                me.select();
            }
        }).appendTo(me.line);


        function _applyForChildren() {
            for (var key in me.nodes) {
                var index = 0;
                if (me.nodes.hasOwnProperty(key)) {
                    var node = me.nodes[key];
                    node.selector.setValue(selected, false);
                }
            }
        }

        function _refresh() {

            if (Object.keys(me.nodes).length > 0) {
                selected = true;
                hasSelectedChildren = false;

                for (var key in me.nodes) {
                    var index = 0;
                    if (me.nodes.hasOwnProperty(key)) {
                        var node = me.nodes[key];
                        if (!node.selector.isSelected()){
                            selected = false;
                            if (node.selector.hasSelectedChildren()) {
                                hasSelectedChildren = true;
                            }
                        } else {
                            hasSelectedChildren = true;
                        }
                    }
                }
            }
            _render();

            if (!me.isRoot()) {
                me.parent.selector.refresh();
            }

        }

        function _render() {

            var name = me.name;
            var checked = (selected ? true : false);
            var bold = (selected || hasSelectedChildren ? 'bold' : 'normal');

            $(box).prop({
                //'checked': (selected ? true : false)
                'checked': checked
            });

            $(me.caption).css({
                'font-weight': bold
                //'font-weight': (selected || hasSelectedChildren ? 'bold' : 'normal')
            });
        }

        return {
            click: function () {
                selected = !selected;
                _applyForChildren();
                _refresh();
            },
            setValue: function (value, refresh) {
                var name = me.name;
                selected = value;
                _applyForChildren();
                if (refresh === false) {
                    _render();
                } else {
                    _refresh();
                }
            },
            refresh: function () {
                _refresh();
            },
            isSelected: function(){
                return selected;
            },
            hasSelectedChildren: function () {
                return hasSelectedChildren;
            }
        }
    })();


    this.caption = jQuery('<div/>', {
        id: key + '_caption',
        'class': 'caption',
        html: name
    }).
    bind({
        'mousedown': function (e) {
            e.preventDefault();
            me.mouseClicked = true;
            if (me.isActive) {

                if (me.tree.mode === MODE.SINGLE) {
                    me.select();
                } else {
                    e.preventDefault;
                    me.renamer.activate();
                    me.inactivate();
                    e.stopPropagation();
                }
            }
        },
        'mouseup': function (e) {
            if (!me.mover.isActive() && me.mouseClicked) {
                me.activate();
            }
            me.mouseClicked = false;
        }
    }).
    appendTo(this.line);




    $(document).bind({
        'mousedown' : function(e){
            if (me.renamer && me.renamer.isActive()) {
                if (e && me.renamer.isOutside(e.pageX, e.pageY)) {
                    me.renamer.escape();
                }
            }
        },
        'mousemove': function (e) {
            e.preventDefault();
            if (me.mouseClicked) {
                me.mover.move(e);
            }
        },
        'mouseup': function (e) {
            e.preventDefault();
            me.mover.drop(e);
            me.mouseClicked = false;
        }
    });


    this.getContainer = function () {
        return this.container;
    };


    this.position = function (div) {
        return $(div).offset();
    }

    this.dropArea = (function () {
        var visible = false;
        var selected = false;
        var xa = 0;
        var xz = 0;
        var ya = 0;
        var yz = 0;

        function _calculatePosition() {
            var caption = me.caption;
            var position = $(caption).offset();
            var width = $(caption).width();
            var height = $(caption).height();

            if (width === 0 || height === 0) {
                visible = false;
            } else {
                visible = true;
                xa = position.left;
                ya = position.top;
                xz = xa + width;
                yz = ya + height;
            }
        };

        function _isHovered(x, y) {
            if (visible) {
                if (x >= xa && x <= xz && y >= ya && y <= yz) {
                    return true;
                }
            }
            return false;
        }

        function _check(x, y) {
            if (me.tree.dragDropManager.hasDropArea()) {
                return;
            } else if (_isHovered(x, y) && me.tree.dragDropManager.getDrag() !== me) {
                _select();
            } else {
                for (var key in me.nodes) {
                    if (me.nodes.hasOwnProperty(key)) {
                        var node = me.nodes[key];
                        if (node) {
                            node.dropArea.check(x, y);
                        }
                    }
                }
            }
        }

        function _unselect() {
            //Switch off as drop area.
            $(me.caption).removeClass('drop-area');
            me.tree.trigger({
                type: 'dropout',
                node: me
            });
        }

        function _select() {
            $(me.caption).addClass('drop-area');
            me.tree.trigger({
                type: 'dropin',
                node: me
            });
        }

        //Setting initial position.
        _calculatePosition();


        return {
            calculatePosition: function () {
                _calculatePosition();
            },
            unselect: function () {
                _unselect();
            },
            isHovered: function(x, y){
                return _isHovered(x, y);
            },
            check: function (x, y) {
                _check(x, y);
            },
            recalculate: function () {
                _calculatePosition();
                for (var key in me.nodes) {
                    if (me.nodes.hasOwnProperty(key)) {
                        var node = me.nodes[key];
                        if (node) {
                            node.dropArea.recalculate();
                        }
                    }
                }
            }
        }

    })();

    this.mover = (function () {
        var active = false;
        var x = 0;
        var y = 0;
        var left = 0;
        var top = 0;

        var div = null;

        function createDiv() {
            var control = jQuery('<div/>', {
                id: me.key,
                'class': 'move',
                html: me.name
            }).
            css({
                'visibility': 'hidden'
            }).
            appendTo(me.mainContainer);
            return control;
        }


        function activate(left, top) {
            if (div === null) {
                div = createDiv();
            }
            active = true;
            show(div);
            x = left;
            y = top;
            moveDiv($(me.caption).offset());
        }

        function deactivate() {
            active = false;
            hide(div);
        }

        function _move(e) {
            var _x = e.pageX;
            var _y = e.pageY;

            moveDiv({
                left: left + (_x - x),
                top: top + (_y - y)
            });

            x = _x;
            y = _y;

            $('#debug').html('X: ' + e.pageX + ' | Y: ' + e.pageY);

        }


        function moveDiv(position) {
            left = position.left;
            top = position.top;
            $(div).css(position);
        }

        return {
            move: function (e) {
                if (!active) {
                    activate(e.pageX, e.pageY);
                    me.tree.trigger({
                        type: 'dragin',
                        node: me
                    });
                }
                _move(e);
            },
            isActive: function () {
                return active;
            },
            drop: function (e) {
                if (active) {
                    deactivate();
                    me.tree.trigger({
                        type: 'dragout',
                        node: me
                    });
                }
            }
        }

    })();

    this.renamer = (function () {
        var active = false;
        var textbox = null;

        function createTextbox() {
            var control = jQuery('<input/>', {
                id: me.key + '_name_textbox',
                'class': 'edit-name'
            }).
            css({
                'visibility': 'hidden'
            }).
            bind({
                'keydown': function (e) {
                    switch (e.which) {
                        case 13:
                            var value = $(this).val();
                            var validation = validateName(value);
                            if (validation === true) {
                                applyNewName(value);
                            }
                            break;
                        case 27:
                            e.stopPropagation();
                            _escape();
                            break;
                    }
                }
            }).
            appendTo(me.mainContainer);
            return control;
        }

        function validateName(name) {
            return true;
        }

        function applyNewName(name) {

            if (name.length) {
                if (me.key.length === 0) {
                    me.key = name;
                    me.changeName(name);
                    me.parent.addNode(me);
                    me.parent.expander.expand();
                    _escape();
                    me.tree.trigger({
                        'type': 'newNode',
                        'node': me
                    });
                } else {
                    me.changeName(name);
                    _escape();
                    me.tree.trigger({
                        'type': 'rename',
                        'node': me,
                        'name': name
                    });
                }
            } else {
                if (me.key.length === 0) {
                    me.cancel();
                }
            }

        }

        function destroy() {
            $(textbox).remove();
            textbox = null;
        }

        function _activate() {
            if (textbox === null) {
                textbox = createTextbox();
            }
            active = true;
            show(textbox);
            $(textbox).css($(me.caption).offset()).val(me.name).focus().select();
        }

        function _escape() {
            active = false;
            destroy();
            if (me.key.length === 0) {
                me.cancel();
            }
        }

        return {
            activate: function (e) {
                if (!active) {
                    _activate();
                    me.tree.trigger({
                        type: 'edit_name'
                    });
                }
            },
            isActive: function () {
                return active;
            },
            escape: function () {
                _escape();
            },
            isOutside: function (x, y) {
                var position = $(textbox).offset();
                var xa = position.left;
                var ya = position.top;
                var xz = xa + $(textbox).width();
                var yz = ya + $(textbox).height();

                if (x >= xa && x <= xz && y >= ya && y <= yz) {
                    return false;
                }

                return true;

            }
        }

    })();

    this.sorter = (function () {
        me.nodesArray = []

        var createNodesTable = function () {
            for (var key in me.nodes) {
                var index = 0;
                if (me.nodes.hasOwnProperty(key)) {
                    var node = me.nodes[key];
                    me.nodesArray.push(node);
                }
            }
        }

        var sort = function () {
            me.nodesArray.sort(function (obj1, obj2) {
                return (obj1.name < obj2.name ? -1 : 1);
            });
        }

        var rearrange = function () {
            for (var i = me.nodesArray.length - 1; i > 0; i--) {
                $(me.nodesArray[i].mainContainer).before($(me.nodesArray[i - 1].mainContainer));
                me.nodesArray[i].index = i;
            }
        }

        return {
            sort: function () {
                me.nodesArray = [];
                createNodesTable();
                if (Object.keys(me.nodes).length > 1) {
                    sort();
                    rearrange();
                }
            }
        }

    })();

}

TreeNode.prototype.loadData = function (data) {

    if (data.length === 0) {
        this.expander.setExpandableStatus(false);
    } else {
        this.expander.setExpandableStatus(true);
        for (var key in data) {
            if (data.hasOwnProperty(key)) {
                var item = data[key];
                var node = new TreeNode(this.tree, item.key, item.caption, this, item.expanded);
                this.nodes[item.key] = node;
                node.selector.setValue(item.selected);
                node.loadData(item.items);
            }
        }

        this.sorter.sort();

    }
}
TreeNode.prototype.getName = function () {
    return this.name;
}
TreeNode.prototype.getKey = function () {
    return this.key;
}
TreeNode.prototype.transfer = function (destination) {
    if (this === destination) {
        this.isActive = false;
    } else {
        if (!this.isRoot()) {
            this.parent.removeNode(this);
            destination.addNode(this);
        }
    }
}
TreeNode.prototype.removeNode = function (node) {
    delete this.nodes[node.getKey()];
}
TreeNode.prototype.addNode = function (node) {
    //alert('moving node ' + node.name + ' to ' + this.name);
    node.moveTo(this);
    this.nodes[node.getKey()] = node;
    this.sorter.sort();
    this.resetStatus();
    this.dropArea.unselect();
    this.dropArea.recalculate();
}
TreeNode.prototype.moveTo = function (newParent) {
    if (this.parent) {
        this.parent.removeNode(this.key);
    }
    this.parent = newParent;
    this.mainContainer.appendTo($(newParent.getContainer()));
}
TreeNode.prototype.isRoot = function () {
    var value = (this.parent.isNode ? false : true);
    return value;
}
TreeNode.prototype.resetStatus = function () {
    if (Object.keys(this.nodes).length > 0) {
        this.expander.setExpandableStatus(true);
    } else {
        this.expander.setExpandableStatus(false);
    }
}
TreeNode.prototype.getChildNode = function (i) {
    if (i >= 0 && i < this.nodesArray.length) {
        return this.nodesArray[i];
    }
    return null;
}
TreeNode.prototype.getLastChild = function () {
    if (this.nodesArray.length < 1) {
        return null;
    } else {
        return this.nodesArray[this.nodesArray.length - 1];
    }
}
TreeNode.prototype.activate = function () {
    this.isActive = true;
    $(this.caption).addClass('selected');
    this.tree.trigger({
        'type': 'activate',
        'node': this
    });
}
TreeNode.prototype.inactivate = function () {
    this.isActive = false;
    $(this.caption).removeClass('selected');
    this.tree.trigger({
        'type': 'inactivate',
        'node': this
    });
}
TreeNode.prototype.nextNode = function () {
    if (this.isRoot() === true) {
        return null;
    } else {
        return this.parent.getChildNode(this.index + 1);
    }
}
TreeNode.prototype.previousNode = function () {
    if (this.isRoot() === true) {
        return null;
    } else {
        return this.parent.getChildNode(this.index - 1);
    }
}
TreeNode.prototype.delete = function () {
    if (!this.isRoot()) {
        this.parent.removeNode(this.key);
        this.parent.resetStatus();

        $(this.mainContainer).css({
            'display' : 'none'
        });

        this.tree.trigger({
            'type': 'delete',
            'node': this
        });

    }
}
TreeNode.prototype.removeNode = function (key) {
    delete this.nodes[key];
    this.sorter.sort();
}
TreeNode.prototype.addNewNode = function () {
    var node = new TreeNode(this.tree, '', '', this, false);
    node.renamer.activate();
}
TreeNode.prototype.cancel = function () {
    $(this.mainContainer).css({
        'display': 'none'
    });
}
TreeNode.prototype.changeName = function (name) {
    this.name = name;
    $(this.caption).html(name);
}
TreeNode.prototype.select = function () {
    if (this.tree.mode === MODE.SINGLE) {
        this.tree.trigger({
            'type': 'confirm',
            'item': this
        });
    } else if (this.tree.mode === MODE.MULTI) {
        this.selector.click();
    }
}

function hide(div) {
    $(div).css({
        'visibility': 'hidden'
    });
}
function show(div) {
    $(div).css({
        'visibility': 'visible'
    });
}
function display(div, value) {
    $(div).css({
        'display' : (value ? 'block' : 'none')
    });
}