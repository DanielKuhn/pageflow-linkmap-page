pageflow.linkmapPage.FileAreaItemView = Backbone.Marionette.ItemView.extend({
  template: 'pageflow/linkmap_page/editor/templates/file_area_item',

  tagName: 'li',
  className: 'linkmap_page_file_area',

  ui: {
    thumbnail: '.file_thumbnail',
    title: '.title',
    editButton: '.edit'
  },

  events: {
    'click .remove': function() {
      this.model.destroy();
      return false;
    },

    'click .edit': function() {
      pageflow.editor.navigate(this.model.editPath(), {trigger: true});
      return false;
    },

    'mouseenter': function() {
      this.model.highlight(true);
    },

    'mouseleave': function() {
      this.model.resetHighlight(false);
    }
  },

  onRender: function() {
    var file = this.model.targetFile();

    if (file) {
      this.subview(new pageflow.FileThumbnailView({
        el: this.ui.thumbnail,
        model: file
      }));

      this.ui.title.text(file.get('file_name'));
    }
    else {
      this.ui.title.text(I18n.t('pageflow.linkmap_page.editor.views.file_area_item_view.no_file'));
    }

    this.ui.editButton.toggle(!!this.model.editPath());
    this.$el.toggleClass('dangling', !file);
  },
});