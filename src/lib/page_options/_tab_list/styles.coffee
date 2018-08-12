# styles.coffee, pdso/src/lib/page_options/_tab_list/

styles = (theme) ->
  {
    paper_list: {  # no padding
      margin: theme.spacing.unit
      marginTop: theme.spacing.unit * 2
    }
    paper_note: {
      backgroundColor: theme.tb.color_note
    }
    paper_enable_all: {
      paddingRight: '4px'
    }
    paper_config: {
      paddingBottom: 0
    }
    enable_all_title: {
      display: 'flex'

      '& h3': {
        flex: 1
      }
    }
    chip: {
      marginLeft: theme.spacing.unit
      height: 'auto'
      cursor: 'auto'
      color: 'inherit'
    }
    chip_label: {
      display: 'initial'
      userSelect: 'auto'
      textAlign: 'center'
    }
    placeholder: {
      padding: theme.spacing.unit * 2
      display: 'flex'
      justifyContent: 'center'
    }
    item_text: {
      paddingRight: '72px'
    }
    badge: {
      width: 'auto'
      minWidth: '22px'
      borderRadius: '11px'
      paddingLeft: '6px'
      paddingRight: '6px'
    }
    note: {
      display: 'flex'
      alignItems: 'center'
    }
    note_left: {
      paddingRight: theme.spacing.unit * 2
      fontSize: '48px'
    }
    note_right: {
      flex: 1
    }
    p: {
      marginTop: theme.spacing.unit
      '& strong': {
        paddingRight: theme.spacing.unit
      }
      '& code': {
        backgroundColor: theme.palette.background.default
      }
    }
    incognito: {
      color: theme.palette.text.secondary
      paddingRight: theme.spacing.unit
    }
    enable_all_desc: {
      paddingRight: theme.spacing.unit
      '& p': {
        marginTop: theme.spacing.unit
        marginBottom: theme.spacing.unit * 1.5
        lineHeight: '1.7em'
        '& code': {
          backgroundColor: theme.palette.background.default
        }
        '&$last': {
          marginBottom: 0
        }
      }
    }
    last: {}
  }

module.exports = styles
