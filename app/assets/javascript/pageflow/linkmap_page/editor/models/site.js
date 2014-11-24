pageflow.linkmapPage.Site = Backbone.Model.extend({
  modelName: 'site',
  paramRoot: 'site',
  i18nKey: 'site',

  mixins: [pageflow.failureTracking, pageflow.transientReferences],

  defaults: {
    'open_in_new_tab': true
  },

  initialize: function(attributes, options) {
    this.listenTo(this, 'change', function() {
      this.save();
    });
  },

  urlRoot: function() {
    return this.isNew() ? this.collection.url() : '/linkmap_page/sites';
  },

  getThumbnail: function() {
    return this.getReference('thumbnail', pageflow.imageFiles);
  }
});
