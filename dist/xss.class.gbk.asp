<script language="javascript" runat="server">
var FilterXSS = (function () {
/**
 * asp-xss-filter
 * @author zsx<zsx@zsxsoft.com>
 */
var XSS_CONFIG = {};
(function () {

  var exports = {};

/**
 * Ĭ������
 *
 * @author ����<leizongmin@gmail.com>
*/


// Ĭ�ϰ�����
var whiteList = {
  a:      ['target', 'href', 'title'],
  abbr:   ['title'],
  address: [],
  area:   ['shape', 'coords', 'href', 'alt'],
  article: [],
  aside:  [],
  audio:  ['autoplay', 'controls', 'loop', 'preload', 'src'],
  b:      [],
  bdi:    ['dir'],
  bdo:    ['dir'],
  big:    [],
  blockquote: ['cite'],
  br:     [],
  caption: [],
  center: [],
  cite:   [],
  code:   [],
  col:    ['align', 'valign', 'span', 'width'],
  colgroup: ['align', 'valign', 'span', 'width'],
  dd:     [],
  del:    ['datetime'],
  details: ['open'],
  div:    [],
  dl:     [],
  dt:     [],
  em:     [],
  font:   ['color', 'size', 'face'],
  footer: [],
  h1:     [],
  h2:     [],
  h3:     [],
  h4:     [],
  h5:     [],
  h6:     [],
  header: [],
  hr:     [],
  i:      [],
  img:    ['src', 'alt', 'title', 'width', 'height'],
  ins:    ['datetime'],
  li:     [],
  mark:   [],
  nav:    [],
  ol:     [],
  p:      [],
  pre:    [],
  s:      [],
  section:[],
  small:  [],
  span:   [],
  sub:    [],
  sup:    [],
  strong: [],
  table:  ['width', 'border', 'align', 'valign'],
  tbody:  ['align', 'valign'],
  td:     ['width', 'colspan', 'align', 'valign'],
  tfoot:  ['align', 'valign'],
  th:     ['width', 'colspan', 'align', 'valign'],
  thead:  ['align', 'valign'],
  tr:     ['rowspan', 'align', 'valign'],
  tt:     [],
  u:      [],
  ul:     [],
  video:  ['autoplay', 'controls', 'loop', 'preload', 'src', 'height', 'width']
};

/**
 * ƥ�䵽��ǩʱ�Ĵ�����
 *
 * @param {String} tag
 * @param {String} html
 * @param {Object} options
 * @return {String}
 */
function onTag (tag, html, options) {
  // do nothing
}

/**
 * ƥ�䵽���ڰ������ϵı�ǩʱ�Ĵ�����
 *
 * @param {String} tag
 * @param {String} html
 * @param {Object} options
 * @return {String}
 */
function onIgnoreTag (tag, html, options) {
  // do nothing
}

/**
 * ƥ�䵽��ǩ����ʱ�Ĵ�����
 *
 * @param {String} tag
 * @param {String} name
 * @param {String} value
 * @return {String}
 */
function onTagAttr (tag, name, value) {
  // do nothing
}

/**
 * ƥ�䵽���ڰ������ϵı�ǩ����ʱ�Ĵ�����
 *
 * @param {String} tag
 * @param {String} name
 * @param {String} value
 * @return {String}
 */
function onIgnoreTagAttr (tag, name, value) {
  // do nothing
}

/**
 * HTMLת��
 *
 * @param {String} html
 */
function escapeHtml (html) {
  return html.replace(REGEXP_LT, '&lt;').replace(REGEXP_GT, '&gt;');
}

/**
 * ��ȫ�ı�ǩ����ֵ
 *
 * @param {String} tag
 * @param {String} name
 * @param {String} value
 * @return {String}
 */
function safeAttrValue (tag, name, value) {
  // ת��Ϊ�Ѻõ�����ֵ�������ж�
  value = friendlyAttrValue(value);

  if (name === 'href' || name === 'src') {
    // ���� href �� src ����
    // ������ http:// | https:// | mailto: | / ��ͷ�ĵ�ַ
    value = value.replace(/(^\s*)|(\s*$)/g, "");
    if (value === '#') return '#';
    if (!(value.substr(0, 7) === 'http://' ||
         value.substr(0, 8) === 'https://' ||
         value.substr(0, 7) === 'mailto:' ||
         value.substr(0, 1) === '/')) {
      return '';
    }
  } else if (name === 'background') {
    // ���� background ���� �����xss©�������ˣ������Ѿ������ã�
    // javascript:
    REGEXP_DEFAULT_ON_TAG_ATTR_4.lastIndex = 0;
    if (REGEXP_DEFAULT_ON_TAG_ATTR_4.test(value)) {
      return '';
    }
  } else if (name === 'style') {
    // /*ע��*/
    REGEXP_DEFAULT_ON_TAG_ATTR_3.lastIndex = 0;
    if (REGEXP_DEFAULT_ON_TAG_ATTR_3.test(value)) {
      return '';
    }
    // expression()
    REGEXP_DEFAULT_ON_TAG_ATTR_7.lastIndex = 0;
    if (REGEXP_DEFAULT_ON_TAG_ATTR_7.test(value)) {
      return '';
    }
    // url()
    REGEXP_DEFAULT_ON_TAG_ATTR_8.lastIndex = 0;
    if (REGEXP_DEFAULT_ON_TAG_ATTR_8.test(value)) {
      REGEXP_DEFAULT_ON_TAG_ATTR_4.lastIndex = 0;
      if (REGEXP_DEFAULT_ON_TAG_ATTR_4.test(value)) {
        return '';
      }
    }
  }

  // ���ʱ��Ҫת��<>"
  value = escapeAttrValue(value);
  return value;
}

// ������ʽ
var REGEXP_LT = /</g;
var REGEXP_GT = />/g;
var REGEXP_QUOTE = /"/g;
var REGEXP_QUOTE_2 = /&quot;/g;
var REGEXP_ATTR_VALUE_1 = /&#([a-zA-Z0-9]*);?/img;
var REGEXP_ATTR_VALUE_COLON = /&colon;?/img;
var REGEXP_ATTR_VALUE_NEWLINE = /&newline;?/img;
var REGEXP_DEFAULT_ON_TAG_ATTR_3 = /\/\*|\*\//mg;
var REGEXP_DEFAULT_ON_TAG_ATTR_4 = /((j\s*a\s*v\s*a|v\s*b|l\s*i\s*v\s*e)\s*s\s*c\s*r\s*i\s*p\s*t\s*|m\s*o\s*c\s*h\s*a)\:/ig;
var REGEXP_DEFAULT_ON_TAG_ATTR_5 = /^[\s"'`]*(d\s*a\s*t\s*a\s*)\:/ig;
var REGEXP_DEFAULT_ON_TAG_ATTR_6 = /^[\s"'`]*(d\s*a\s*t\s*a\s*)\:\s*image\//ig;
var REGEXP_DEFAULT_ON_TAG_ATTR_7 = /e\s*x\s*p\s*r\s*e\s*s\s*s\s*i\s*o\s*n\s*\(.*/ig;
var REGEXP_DEFAULT_ON_TAG_ATTR_8 = /u\s*r\s*l\s*\(.*/ig;

/**
 * ��˫���Ž���ת��
 *
 * @param {String} str
 * @return {String} str
 */
function escapeQuote (str) {
  return str.replace(REGEXP_QUOTE, '&quot;');
}

/**
 * ��˫���Ž���ת��
 *
 * @param {String} str
 * @return {String} str
 */
function unescapeQuote (str) {
  return str.replace(REGEXP_QUOTE_2, '"');
}

/**
 * ��htmlʵ��������ת��
 *
 * @param {String} str
 * @return {String}
 */
function escapeHtmlEntities (str) {
  return str.replace(REGEXP_ATTR_VALUE_1, function replaceUnicode (str, code) {
    return (code.substr(0, 1) === 'x' || code.substr(0, 1) === 'X')
            ? String.fromCharCode(parseInt(code.substr(1), 16))
            : String.fromCharCode(parseInt(code, 10));
  });
}

/**
 * ��html5������Σ��ʵ��������ת��
 *
 * @param {String} str
 * @return {String}
 */
function escapeDangerHtml5Entities (str) {
  return str.replace(REGEXP_ATTR_VALUE_COLON, ':')
            .replace(REGEXP_ATTR_VALUE_NEWLINE, ' ');
}

/**
 * ������ɼ��ַ�
 *
 * @param {String} str
 * @return {String}
 */
function clearNonPrintableCharacter (str) {
  var str2 = '';
  for (var i = 0, len = str.length; i
< len; i++) {
    str2 += str.charCodeAt(i) < 32 ? ' ' : str.charAt(i);
  }
  return str2.replace(/(^\s*)|(\s*$)/g, "");
}

/**
 * ����ǩ������ֵת����һ���ַ������ڷ���
 *
 * @param {String} str
 * @return {String}
 */
function friendlyAttrValue (str) {
  str = unescapeQuote(str);             // ˫����
  str = escapeHtmlEntities(str);         // ת��HTMLʵ�����
  str = escapeDangerHtml5Entities(str);  // ת��Σ�յ�HTML5����ʵ�����
  str = clearNonPrintableCharacter(str); // ������ɼ��ַ�
  return str;
}

/**
 * ת����������ı�ǩ����ֵ
 *
 * @param {String} str
 * @return {String}
 */
function escapeAttrValue (str) {
  str = escapeQuote(str);
  str = escapeHtml(str);
  return str;
}

/**
 * ȥ�����ڰ������еı�ǩonIgnoreTag������
 */
function onIgnoreTagStripAll () {
  return '';
}

/**
 * ɾ����ǩ��
 *
 * @param {array} tags Ҫɾ���ı�ǩ�б�
 * @param {function} next �Բ����б��еı�ǩ�Ĵ���������ѡ
 */
function StripTagBody (tags, next) {
  if (typeof(next) !== 'function') {
    next = function () {};
  }

  var isRemoveAllTag = !(tags instanceof Array);
  function isRemoveTag (tag) {
    if (isRemoveAllTag) return true;
    return (function (tag) {
      for (var i = 0; i < tags.length; i++) {
        if (tags[i] == tag) return true;
      }
      return false;
    })(tag);
  }

  var removeList = [];   // Ҫɾ����λ�÷�Χ�б�
  var posStart = false;  // ��ǰ��ǩ��ʼλ��

  return {
    onIgnoreTag: function (tag, html, options) {
      if (isRemoveTag(tag)) {
        if (options.isClosing) {
          var ret = '[/removed]';
          var end = options.position + ret.length;
          removeList.push([posStart !== false ? posStart : options.position, end]);
          posStart = false;
          return ret;
        } else {
          if (!posStart) {
            posStart = options.position;
          }
          return '[removed]';
        }
      } else {
        return next(tag, html, options);
      }
    },
    remove: function (html) {
      var rethtml = '';
      var lastPos = 0;
      for (var item in removeList) {
        pos = removeList[item];
        rethtml += html.slice(lastPos, pos[0]);
        lastPos = pos[1];
      }
      rethtml += html.slice(lastPos);
      return rethtml;
    }
  };
}

/**
 * ȥ����ע��ǩ
 *
 * @param {String} html
 * @return {String}
 */
var STRIP_COMMENT_TAG_REGEXP = new RegExp("<" + "!--[\\s\\S]*?-->", "ig");
function stripCommentTag (html) {
  return html.replace(STRIP_COMMENT_TAG_REGEXP, '');
}


exports.whiteList = whiteList;
exports.onTag = onTag;
exports.onIgnoreTag = onIgnoreTag;
exports.onTagAttr = onTagAttr;
exports.onIgnoreTagAttr = onIgnoreTagAttr;
exports.safeAttrValue = safeAttrValue;
exports.escapeHtml = escapeHtml;
exports.escapeQuote = escapeQuote;
exports.unescapeQuote = unescapeQuote;
exports.escapeHtmlEntities = escapeHtmlEntities;
exports.escapeDangerHtml5Entities = escapeDangerHtml5Entities;
exports.clearNonPrintableCharacter = clearNonPrintableCharacter;
exports.friendlyAttrValue = friendlyAttrValue;
exports.escapeAttrValue = escapeAttrValue;
exports.onIgnoreTagStripAll = onIgnoreTagStripAll;
exports.StripTagBody = StripTagBody;
exports.stripCommentTag = stripCommentTag;
exports.allowCommentTag = false;
exports.stripIgnoreTagBody = false;

XSS_CONFIG = exports;
})();


/**
 * asp-xss-filter
 * @author zsx<zsx@zsxsoft.com>
 */
var XSS_PARSER = {};
(function () {
  var exports = {};
  
/**
 * �� HTML Parser
 *
 * @author ����<leizongmin@gmail.com>
 */


/**
 * ��ȡ��ǩ������
 *
 * @param {String} html �磺'<a hef="#">'
 * @return {String}
 */
function getTagName (html) {
  var i = html.indexOf(' ');
  if (i === -1) {
    var tagName = html.slice(1, -1);
  } else {
    var tagName = html.slice(1, i + 1);
  }
  tagName = tagName.replace(/(^\s*)|(\s*$)/g, "").toLowerCase();
  if (tagName.substr(0, 1) === '/') tagName = tagName.slice(1);
  if (tagName.substr(tagName.length - 1, 1) === '/') tagName = tagName.slice(0, -1);
  return tagName;
}

/**
 * �Ƿ�Ϊ�պϱ�ǩ
 *
 * @param {String} html �磺'<a hef="#">'
 * @return {Boolean}
 */
function isClosing (html) {
  return (html.slice(0, 2) === '</');
}

/**
 * ����HTML���룬������Ӧ�ĺ����������ش�����HTML
 *
 * @param {String} html
 * @param {Function} onTag �����ǩ�ĺ���
 *   ������ʽ�� function (sourcePosition, position, tag, html, isClosing)
 * @param {Function} escapeHtml ��HTML����ת��ĺ���
 * @return {String}
 */
function parseTag (html, onTag, escapeHtml) {
  'user strict';

  var rethtml = '';        // �����ص�HTML
  var lastPos = 0;         // ��һ����ǩ����λ��
  var tagStart = false;    // ��ǰ��ǩ��ʼλ��
  var quoteStart = false;  // ���ſ�ʼλ��
  var currentPos = 0;      // ��ǰλ��
  var len = html.length;   // HTML����
  var currentHtml = '';    // ��ǰ��ǩ��HTML����
  var currentTagName = ''; // ��ǰ��ǩ������

  // ��������ַ�
  for (currentPos = 0; currentPos < len; currentPos++) {
    var c = html.charAt(currentPos);
    if (tagStart === false) {
      if (c === '<') {
        tagStart = currentPos;
        continue;
      }
    } else {
      if (quoteStart === false) {
        if (c === '<') {
          rethtml += escapeHtml(html.slice(lastPos, currentPos));
          tagStart = currentPos;
          lastPos = currentPos;
          continue;
        }
        if (c === '>') {
          rethtml += escapeHtml(html.slice(lastPos, tagStart));
          currentHtml = html.slice(tagStart, currentPos + 1);
          currentTagName = getTagName(currentHtml);
          rethtml += onTag(tagStart,
                           rethtml.length,
                           currentTagName,
                           currentHtml,
                           isClosing(currentHtml));
          lastPos = currentPos + 1;
          tagStart = false;
          continue;
        }
        if (c === '"' || c === "'") {
          quoteStart = c;
          continue;
        }
      } else {
        if (c === quoteStart) {
          quoteStart = false;
          continue;
        }
      }
    }
  }
  if (lastPos < html.length) {
    rethtml += escapeHtml(html.substr(lastPos));
  }

  return rethtml;
}

// �������������ƹ����������ʽ
var REGEXP_ATTR_NAME = /[^a-zA-Z0-9_:\.\-]/img;

/**
 * ������ǩHTML���룬������Ӧ�ĺ�����������HTML
 *
 * @param {String} html ���ǩ'<a href="#" target="_blank">' ��Ϊ 'href="#" target="_blank"'
 * @param {Function} onAttr ��������ֵ�ĺ���
 *   ������ʽ�� function (name, value)
 * @return {String}
 */
function parseAttr (html, onAttr) {
  'user strict';

  var lastPos = 0;        // ��ǰλ��
  var retAttrs = [];      // �����ص������б�
  var tmpName = false;    // ��ʱ��������
  var len = html.length;  // HTML���볤��

  function addAttr (name, value) {
    name =  name.replace(/(^\s*)|(\s*$)/g, "");
    name = name.replace(REGEXP_ATTR_NAME, '').toLowerCase();
    if (name.length < 1) return;
    retAttrs.push(onAttr(name, value || ''));
  };

  // ��������ַ�
  for (var i = 0; i < len; i++) {
    var c = html.charAt(i),v;
    if (tmpName === false && c === '=') {
      tmpName = html.slice(lastPos, i);
      lastPos = i + 1;
      continue;
    }
    if (tmpName !== false) {
      if (i === lastPos && (c === '"' || c === "'")) {
        var j = html.indexOf(c, i + 1);
        if (j === -1) {
          break;
        } else {
          v = html.slice(lastPos + 1, j).replace(/(^\s*)|(\s*$)/g, "");
          addAttr(tmpName, v);
          tmpName = false;
          i = j;
          lastPos = i + 1;
          continue;
        }
      }
    }
    if (c === ' ') {
      v = html.slice(lastPos, i).replace(/(^\s*)|(\s*$)/g, "");
      if (tmpName === false) {
        addAttr(v);
      } else {
        addAttr(tmpName, v);
      }
      tmpName = false;
      lastPos = i + 1;
      continue;
    }
  }

  if (lastPos < html.length) {
    if (tmpName === false) {
      addAttr(html.slice(lastPos));
    } else {
      addAttr(tmpName, html.slice(lastPos));
    }
  }

  return retAttrs.join(' ').replace(/(^\s*)|(\s*$)/g, "");
}

exports.parseTag = parseTag;
exports.parseAttr = parseAttr;

  XSS_PARSER = exports;
})();

/**
 * asp-xss-filter
 * @author zsx<zsx@zsxsoft.com>
 */

/**
 * XSS���˶���
 *
 * @param {Object} options ѡ�whiteList, onTag, onTagAttr, onIgnoreTag,
 *                               onIgnoreTagAttr, safeAttrValue, escapeHtml
 *                               stripIgnoreTagBody, allowCommentTag
 */
var FilterXSS = function(options) {
  /**
   * ����XSS
   *
   * @author ����<leizongmin@gmail.com>
   */

  var DEFAULT = XSS_CONFIG;
  var parser = XSS_PARSER;
  var parseTag = parser.parseTag;
  var parseAttr = parser.parseAttr;
  /**
   * ����ֵ�Ƿ�Ϊ��
   *
   * @param {Object} obj
   * @return {Boolean}
   */
  function isNull(obj) {
    return (obj === undefined || obj === null);
  }

  /**
   * ȡ��ǩ�ڵ������б��ַ���
   *
   * @param {String} html
   * @return {Object}
   *   - {String} html
   *   - {Boolean} closing
   */
  function getAttrs(html) {
    var i = html.indexOf(' ');
    if (i === -1) {
      return {
        html: '',
        closing: (html.substr(html.length - 2, 1) === '/')
      };
    }
    html = html.slice(i + 1, -1).replace(/(^\s*)|(\s*$)/g, "");
    var isClosing = (html.substr(html.length - 1, 1) === '/');
    if (isClosing) html = html.slice(0, -1).replace(/(^\s*)|(\s*$)/g, "");
    return {
      html: html,
      closing: isClosing
    };
  }


  options = options || {};

  if (options.stripIgnoreTag) {
    if (options.onIgnoreTag) {
      //console.error('Notes: cannot use these two options "stripIgnoreTag" and "onIgnoreTag" at the same time');
    }
    options.onIgnoreTag = DEFAULT.onIgnoreTagStripAll;
  }

  options.whiteList = options.whiteList || DEFAULT.whiteList;
  options.onTag = options.onTag || DEFAULT.onTag;
  options.onTagAttr = options.onTagAttr || DEFAULT.onTagAttr;
  options.onIgnoreTag = options.onIgnoreTag || DEFAULT.onIgnoreTag;
  options.onIgnoreTagAttr = options.onIgnoreTagAttr || DEFAULT.onIgnoreTagAttr;
  options.safeAttrValue = options.safeAttrValue || DEFAULT.safeAttrValue;
  options.escapeHtml = options.escapeHtml || DEFAULT.escapeHtml;
  options.allowCommentTag = (typeof(options.allowCommentTag) != 'undefined' ? options.allowCommentTag : DEFAULT.allowCommentTag);
  //this.options = options;
  return {
    options: options,
    /**
     * ��ʼ����
     *
     * @param {String} html
     * @return {String}
     */
    process: function(html) {
      // ���ݸ�����������
      html = html || '';
      html = html.toString();
      if (!html) return '';

      var me = this;
      var options = me.options;
      var whiteList = options.whiteList;
      var onTag = options.onTag;
      var onIgnoreTag = options.onIgnoreTag;
      var onTagAttr = options.onTagAttr;
      var onIgnoreTagAttr = options.onIgnoreTagAttr;
      var safeAttrValue = options.safeAttrValue;
      var escapeHtml = options.escapeHtml

      // �Ƿ��ֹ��ע��ǩ
      if (!options.allowCommentTag) {
        html = DEFAULT.stripCommentTag(html);
      }

      // ���������stripIgnoreTagBody
      if (options.stripIgnoreTagBody) {
        var stripIgnoreTagBody = DEFAULT.StripTagBody(options.stripIgnoreTagBody, onIgnoreTag);
        onIgnoreTag = stripIgnoreTagBody.onIgnoreTag;
      } else {
        stripIgnoreTagBody = false;
      }

      var retHtml = parseTag(html, function(sourcePosition, position, tag, html, isClosing) {
        var info = {
          sourcePosition: sourcePosition,
          position: position,
          isClosing: isClosing,
          isWhite: (tag in whiteList)
        };

        // ����onTag����
        var ret = onTag(tag, html, info);
        if (!isNull(ret)) return ret;

        // Ĭ�ϱ�ǩ������
        if (info.isWhite) {
          // ��������ǩ��������ǩ����
          // ����Ǳպϱ�ǩ������Ҫ��������
          if (info.isClosing) {
            return '</' + tag + '>';
          }

          var attrs = getAttrs(html);
          var whiteAttrList = whiteList[tag];
          var attrsHtml = parseAttr(attrs.html, function(name, value) {

            // ����onTagAttr����
            var isWhiteAttr = (function (name) {
              for (var i = 0; i < whiteAttrList.length; i++) {
                if (whiteAttrList[i] == name) return true;
              }
              return false;
            })(name);
            var ret = onTagAttr(tag, name, value, isWhiteAttr);
            if (!isNull(ret)) return ret;

            // Ĭ�ϵ����Դ�����
            if (isWhiteAttr) {
              // ���������ԣ�����safeAttrValue��������ֵ
              value = safeAttrValue(tag, name, value);
              if (value) {
                return name + '="' + value + '"';
              } else {
                return name;
              }
            } else {
              // �ǰ��������ԣ�����onIgnoreTagAttr����
              var ret = onIgnoreTagAttr(tag, name, value, isWhiteAttr);
              if (!isNull(ret)) return ret;
              return;
            }
          });

          // �����µı�ǩ����
          var html = '<' + tag;
          if (attrsHtml) html += ' ' + attrsHtml;
          if (attrs.closing) html += ' /';
          html += '>';
          return html;

        } else {
          // �ǰ�������ǩ������onIgnoreTag����
          var ret = onIgnoreTag(tag, html, info);
          if (!isNull(ret)) return ret;
          return escapeHtml(html);
        }

      }, escapeHtml);

      // ���������stripIgnoreTagBody����Ҫ�Խ���ٽ��д���
      if (stripIgnoreTagBody) {
        retHtml = stripIgnoreTagBody.remove(retHtml);
      }

      return retHtml;

    }
  }
}



return FilterXSS;})();

function filterXSS(html, options) {
var xss = FilterXSS(options);
return xss.process(html);
}
</script>