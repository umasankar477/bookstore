using {AdminService} from '../../srv/admin-service.cds';

////////////////////////////////////////////////////////////////////////////
//
//	Books Object Page
//
annotate AdminService.Books with @(UI: {
  Facets             : [
    {
      $Type : 'UI.ReferenceFacet',
      Label : '{i18n>General}',
      Target: '@UI.FieldGroup#General'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : '{i18n>Translations}',
      Target: 'texts/@UI.LineItem'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : '{i18n>Details}',
      Target: '@UI.FieldGroup#Details'
    },
    {
      $Type : 'UI.ReferenceFacet',
      Label : '{i18n>Admin}',
      Target: '@UI.FieldGroup#Admin'
    },
  ],
  FieldGroup #General: {Data: [
    {Value: title},
    {Value: author_ID},
    {Value: genre_ID},
    {Value: descr},
  ]},
  FieldGroup #Details: {Data: [
    {Value: stock},
    {Value: price},
    {
      Value: currency_code,
      Label: '{i18n>Currency}'
    },
  ]},
  FieldGroup #Admin  : {Data: [
    {Value: createdBy},
    {Value: createdAt},
    {Value: modifiedBy},
    {Value: modifiedAt}
  ]}
},
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : '{i18n>Title}',
        },
        {
            $Type : 'UI.DataField',
            Value : author.ID,
            Label : '{i18n>Author}',
            ![@UI.Importance] : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : genre.name,
        },
        {
            $Type : 'UI.DataField',
            Value : stock,
        },
        {
            $Type : 'UI.DataField',
            Value : price,
        },
        {
            $Type : 'UI.DataField',
            Value : currency.symbol,
        },
    ],);


////////////////////////////////////////////////////////////
//
//  Draft for Localized Data
//
annotate sap.capire.bookshop.Books with @fiori.draft.enabled;
annotate AdminService.Books with @odata.draft.enabled;

annotate AdminService.Books.texts with @(UI: {
  Identification : [{Value: title}],
  SelectionFields: [
    locale,
    title
  ],
  LineItem       : [
    {
      Value: locale,
      Label: 'Locale'
    },
    {
      Value: title,
      Label: 'Title'
    },
    {
      Value: descr,
      Label: 'Description'
    },
  ]
});

annotate AdminService.Books.texts with {
  ID       @UI.Hidden;
  ID_texts @UI.Hidden;
};

// Add Value Help for Locales
annotate AdminService.Books.texts {
  locale @(
    ValueList.entity: 'Languages',
    Common.ValueListWithFixedValues, //show as drop down, not a dialog
  )
};

// In addition we need to expose Languages through AdminService as a target for ValueList
using {sap} from '@sap/cds/common';
using from '../common';


extend service AdminService {
  @readonly
  entity Languages as projection on sap.common.Languages;
}

// Workaround for Fiori popup for asking user to enter a new UUID on Create
annotate AdminService.Books with {
  ID @Core.Computed;
}

// Show Genre as drop down, not a dialog
annotate AdminService.Books with {
  genre @Common.ValueListWithFixedValues;
}
