/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

/**
 * This file was added automatically by CKEditor builder.
 * You may re-use it at any time at http://ckeditor.com/builder to build CKEditor again.
 *
 * NOTE:
 *    This file is not used by CKEditor, you may remove it.
 *    Changing this file will not change your CKEditor configuration.
 */

CKEDITOR.editorConfig = function(config) {
     config.removeDialogTabs = 'image:advanced;link:advanced;flash:advanced;table:advanced';
     config.toolbar = ['/', {
          name : 'basicstyles',
          groups : ['basicstyles', 'cleanup'],
          items : ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat']
     }, {
          name : 'colors',
          items : ['TextColor', 'BGColor']
     }, {
          name : 'paragraph',
          groups : ['list', 'indent', 'blocks', 'align', 'bidi'],
          items : ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl', 'Language']
     }, {
          name : 'links',
          items : ['Link', 'Unlink']
     }, {
          name : 'insert',
          items : ['Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar']
     }, '/', {
          name : 'styles',
          items : ['Styles', 'Format', 'Font', 'FontSize']
     }];
};
