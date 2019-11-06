'use strict';

(function (q) {
  'use strict';

  if (!window.veevaBridge) {
    var constructSOQL = function constructSOQL(object, fields, where, sort, limit) {
      var soql = ['SELECT', fields.join(), 'FROM', object];
      if (where) {
        soql.push('WHERE', where);
      }
      if (sort && sort.length) {
        soql.push('ORDER BY', sort);
      }
      if (limit) {
        soql.push('LIMIT', limit);
      }
      return soql.join(' '); //.replace(/ /g, '+');
    },
        idWhere = function idWhere(id) {
      return 'ID = \'' + id + '\'';
    },
        transformReturn = function transformReturn(resp, objectName) {
      var results = {
        success: true,
        record_count: resp.totalSize
      },
          records = resp.records,
          d = records.length,
          thisID,
          record;
      // stupid hack to normalize the ID/Id member name since it is different on the iPad vs in the Rest API
      while (d--) {
        record = records[d];
        if (record.Id) {
          record.ID = record.Id;
        }
      }
      results[objectName] = resp.records;
      return results;
    },
        cache = {
      objectLabels: {},
      objectQueries: {},
      objectDescriptions: {},
      translations: {},
      currentObject: {},
      veevaMessages: {}
    },
        b64EncodeUnicode = function b64EncodeUnicode(str) {
      return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, function (match, p1) {
        return String.fromCharCode(parseInt(p1, 16));
      }));
    },
        getQueryCacheSignature = function getQueryCacheSignature(queryConfig) {
      var strings = [queryConfig.object, queryConfig.fields, queryConfig.where || '', queryConfig.sort || '', queryConfig.limit || ''],
          string = strings.join('');
      return b64EncodeUnicode(string);
    };
    /**
     * Represents a wrapper for communicating with the Salesforce REST API via the ForceTK library.
     * @constructor
     * @param {object} forceClient - Instance of the ForceTK library.
     */
    window.veevaBridge = function (forceClient) {
      /**
       *  Run a query
       *  @private
       *  @param {object} queryConfig - \{object: String, fields: Array, where: String, sort: String, limit: String\}
       *  @param {string} queryConfig.object - Name of the object to query
       *  @param {array} queryConfig.fields - An array of field names to return
       *  @param {string} queryConfig.where - the where statement without the "where" string. ex: where: "Name = 'Bob\'s Port-o-potties"
       *  @param {string} queryConfig.sort - the sort statment without the "order by" string. ex: sort: "LastModifiedDate DESC"
       *  @param {integer} queryConfig.limit - the number of records to return.
       *  @return {promise} - The promise returned when resolved will return the results of the query.
       **/
      this.queryObject = function (queryConfig) {
        var deferred = q.defer(),
            soql = constructSOQL(queryConfig.object, queryConfig.fields, queryConfig.where, queryConfig.sort, queryConfig.limit);
        deferred.promise.then(function (resp) {
          cache.objectQueries[getQueryCacheSignature(queryConfig)] = resp;
        });
        forceClient.query(soql, deferred.resolve, deferred.reject); // i am not sure this will work but that would be cool.
        return deferred.promise;
      };
      /**
       *  Run a query
       *  @param {object} queryConfig - \{object: String, fields: Array, where: String, sort: String, limit: String\}
       *  @param {string} queryConfig.object - Name of the object to query
       *  @param {array} queryConfig.fields - An array of field names to return
       *  @param {string} queryConfig.where - the where statement without the "where" string. ex: where: "Name = 'Bob\'s Port-o-potties"
       *  @param {string} queryConfig.sort - the sort statment without the "order by" string. ex: sort: "LastModifiedDate DESC"
       *  @param {integer} queryConfig.limit - the number of records to return.
       *  @return {promise} - The promise returned when resolved will return the results of the query.
       **/
      this.runQuery = function (queryConfig) {
        var deferred = q.defer(),
            queryCache = cache.objectQueries[getQueryCacheSignature(queryConfig)];
        if (queryCache) {
          deferred.resolve(transformReturn(queryCache, queryConfig.object));
        } else {
          this.queryObject(queryConfig).then(function (results) {
            deferred.resolve(transformReturn(results, queryConfig.object));
          }, function (e) {
            deferred.reject(e);
          });
        }
        return deferred.promise;
      };
      /**
       *  Run a query to get the labels of object(s)
       *  @param {array} objects - An array of object names for which to get labels.
       *  @return {promise} - The promise returned when resolved will return the results of the query.
       **/
      this.getObjectLabels = function (objects) {
        var deferred = q.defer(),
            deferredPool = [],
            promisePool = [],
            o = 0,
            deferredPoolLength = 0,
            deferredIndex;
        if (!(objects instanceof Array)) {
          objects = [objects];
        }
        for (o = objects.length; o--;) {
          deferredIndex = deferredPool.push(q.defer()) - 1;
          promisePool.push(deferredPool[deferredIndex].promise);
          if (cache.objectLabels[objects[o]]) {
            deferredPool[deferredIndex].resolve(cache.objectLabels[objects[o]]);
          } else {
            forceClient.metadata(objects[o], deferredPool[deferredIndex].resolve, deferredPool[deferredIndex].reject);
          }
        }
        q.all(promisePool).then(function (responses) {
          // coallesce all the object labels into a single return value
          var r = responses.length,
              response,
              labels = { success: true };
          // {success: true, Medical_Event_vod__c: [{plural: "Medical Events", singular: "Medical Event"}]}
          while (r--) {
            // cache.objectLabels[responses[r].objectDescribe.name] = responses[r]
            response = (cache.objectLabels[responses[r].objectDescribe.name] = responses[r]).objectDescribe;
            labels[response.name] = [{ singular: response.label, plural: response.labelPlural }];
            // put the labels into a labels object or array
          }
          deferred.resolve(labels);
        }, function (error) {
          deferred.reject(error);
        });
        return deferred.promise;
      };
      /**
       *  Run a query to get the a certain field value for the object that is the current top-level subject.
       *  @param {string} object - Name of the object.
       *  @param {string} field - Name of the field
       *  @param {string} id - ID of the object
       *  @return {promise} - The promise returned when resolved will return the results of the query.
       **/
      this.getDataForCurrentObject = function (object, field, id) {
        var deferred = q.defer();
        this.queryObject({ object: object, fields: [field], where: idWhere(id) }).then(function (results) {
          // send as message to frame
          var resp = transformReturn(results, object),
              record = results.records[0],
              fieldToReturn = field.toUpperCase() === 'ID' ? 'ID' : field,
              fieldToReference = field.toUpperCase() === 'ID' ? 'Id' : field;
          resp[object] = {};
          resp[object][fieldToReturn] = record && record[fieldToReference] ? record[fieldToReference] : '';
          deferred.resolve(resp);
        }, function (e) {
          deferred.reject(e);
        });
        return deferred.promise;
      };
      /**
       *  Run a query to get the labels of fields
       *  @param {object} queryConfig - \{object: String, fields: Array\}
       *  @param {string} queryConfig.object - Name of the object for which to get the field labels
       *  @param {array} queryConfig.fields - An array of field names for which to get the field labels
       *  @return {promise} - The promise returned when resolved will return the results of the query.
       **/
      this.getFieldLabels = function (queryConfig) {
        var deferred = q.defer(),
            deferredInner = q.defer(),
            queryCache = cache.objectDescriptions[queryConfig.object],
            getLabelsFromResp = function getLabelsFromResp(describe) {
          var resp = { success: true },
              fields = describe.fields,
              f = fields.length,
              newFields = {};
          resp[queryConfig.object] = newFields;
          while (f--) {
            newFields[fields[f].name] = fields[f].label;
          }
          return resp;
        };
        if (queryCache) {
          deferredInner.promise.then(function (cached) {
            deferred.resolve(cached);
          });
          deferredInner.resolve(getLabelsFromResp(queryCache));
        } else {
          deferredInner.promise.then(function (describe) {
            cache.objectDescriptions[queryConfig.object] = describe;
            deferred.resolve(getLabelsFromResp(describe));
          }, function (error) {
            deferred.reject(error);
          });
          forceClient.describe(queryConfig.object, deferredInner.resolve, deferredInner.reject);
        }
        return deferred.promise;
      };
      /**
       *  Run a query to get the value labels of the items in a picklist
       *  @param {object} queryConfig - \{object: String, field: String\}
       *  @param {string} queryConfig.object - Name of the object for which to get the picklist value labels
       *  @param {string} queryConfig.field - The picklist field name
       *  @return {promise} - The promise returned when resolved will return the results of the query which will be an array of the value labels.
       **/
      this.getPicklistValueLabels = function (queryConfig) {
        var deferred = q.defer(),
            deferredInner = q.defer(),
            queryCache = cache.objectDescriptions[queryConfig.object],
            getPicklistValueLabelsFromResp = function getPicklistValueLabelsFromResp(describe) {
          var resp = { success: true },
              fields = describe.fields,
              f = fields.length,
              picklistValueLabels = {},
              name;
          resp[queryConfig.object] = picklistValueLabels;
          while (f--) {
            name = fields[f].name;
            if (fields[f].name === queryConfig.field) {
              // at this point we found the field that is the picklist we are looking for. the picklist values are an array and we need to convert them to an object.
              for (var picklist = fields[f].picklistValues, p = picklist.length; p--;) {
                picklistValueLabels[picklist[p].value] = picklist[p].label;
              }
            }
          }
          return picklistValueLabels;
        };
        if (queryCache) {
          deferredInner.promise.then(function (cached) {
            deferred.resolve(getPicklistValueLabelsFromResp(cached));
          });
          deferredInner.resolve(queryCache);
        } else {
          deferredInner.promise.then(function (describe) {
            cache.objectDescriptions[queryConfig.object] = describe;
            deferred.resolve(getPicklistValueLabelsFromResp(describe));
          });
          forceClient.describe(queryConfig.object, deferredInner.resolve, deferredInner.reject);
        }
        return deferred.promise;
      };

      /**
       *  Run a query to get the text value of the requested veeva message
       *  @param {string} languageLocaleKey - the language value from the user's profile
       *  @param {array} msgsToGet - array of string names of the messages desired.
       *  @return {promise} - The promise returned when resolved will return the results of the messages query which will be an array of the value labels.
       **/
      this.getVeevaMessagesWithDefault = function (languageLocaleKey, msgsToGet) {

        var deferred = q.defer(),
            queryConfig = {
          object: 'Message_vod__c',
          fields: ['Name', 'Category_vod__c', 'Language_vod__c', 'Text_vod__c']
        },
            whereSubClauses = [],
            index = msgsToGet.length;
        while (index--) {
          whereSubClauses.push('(Name=\'' + msgsToGet[index].msgName + '\' AND Category_vod__c=\'' + msgsToGet[index].msgCategory + '\')');
        }
        queryConfig.where = '(' + whereSubClauses.join(' OR ') + ')' + ' AND Language_vod__c=\'' + languageLocaleKey + '\'';
        return this.runQuery(queryConfig);
      };
    };
  }
})(Q);
//# sourceMappingURL=onOfflineBridge.js.map

'use strict';

/**
 *    Bridge Initialization Script
 *    @constructor
 *    @param {object} Bridge - the Bridge class defined in onOfflineBridge.js
 **/
(function (Bridge) {
    'use strict';

    var sfClient = new forcetk.Client(),
        prop,
        bridge,
        keywordToObjectMap = {
        'Account': 'Account',
        'AccountPlan': 'Account_Plan_vod__c',
        'HTMLReport': 'HTML_Report_vod__c',
        'Order': 'Order_vod__c',
        'TSF': 'TSF_vod__c',
        'User': 'User'
    },
        methodWhiteList = ['ajax', 'query', 'describe', 'metadata', 'setSessionToken'],
        returnMessage = function returnMessage(message, deferredId, source, command) {
        message.deferredId = deferredId;
        message.command = command || 'queryReturn';
        source.postMessage(JSON.stringify(message), '*');
    },
        returnError = function returnError(error, deferredId, source) {
        console.log('return error', error);
        returnMessage(error, deferredId, source, 'error');
    },
        idWhere = function idWhere(id) {
        return 'ID = \'' + id + '\'';
    },
        listen = function listen(message) {
        var data;
        if (typeof message.data === 'string') {
            try {
                data = JSON.parse(message.data);
            } catch (e) {
                data = {};
            }
        } else data = message.data;

        var queryConfig = data,
            // {command:'', object:'', where:''...}
        command = queryConfig.command,
            source = message.source,
            deferredId = queryConfig.deferredId,
            success = function success(results) {
            returnMessage(results, deferredId, source);
        },
            failure = function failure(error) {
            returnError(error, deferredId, source);
        };
        switch (command) {
            case 'queryObject':
                {
                    bridge.runQuery(queryConfig).then(success, failure);
                    break;
                }
            case 'getFieldLabel':
                {
                    bridge.getFieldLabels(queryConfig).then(function (labels) {
                        returnMessage(labels, deferredId, source);
                    }, failure);
                    break;
                }
            case 'getObjectLabels':
                {
                    bridge.getObjectLabels(queryConfig.object).then(function (labels) {
                        returnMessage(labels, deferredId, source);
                    }, failure);
                    break;
                }
            case 'getDataForObjectV2':
                {
                    var objectName;

                    if (keywordToObjectMap.hasOwnProperty(queryConfig.object)) {
                        objectName = keywordToObjectMap[queryConfig.object];
                    } else {
                        objectName = queryConfig.object;
                    }

                    var id = getObjectIdByObjectName(objectName);

                    bridge.getDataForCurrentObject(objectName, queryConfig.fields[0], id).then(function (results) {
                        results[queryConfig.object] = results[objectName];
                        returnMessage(results, deferredId, source);
                    }, failure);
                    break;
                }
            case 'getPicklistValueLabels':
                {
                    bridge.getPicklistValueLabels(queryConfig).then(function (results) {
                        var retMsg = {};
                        retMsg[queryConfig.object] = {};
                        retMsg[queryConfig.object][queryConfig.field] = results;
                        returnMessage(retMsg, deferredId, source);
                    }, failure);
                    break;
                }
        }
    },
        getObjectIdByObjectName = function getObjectIdByObjectName(objectName) {
        var currentObjectName = HTMLConfig.currentObject;
        var id;

        if (objectName === currentObjectName) {
            id = HTMLConfig.currentObjectID;
        } else if (objectName === 'User') {
            id = HTMLConfig.userID;
        } else if (objectName === 'Account') {
            id = HTMLConfig.accountID;
        } else if (objectName === 'HTML_Report_vod__c') {
            id = HTMLConfig.reportID;
        } else if (objectName === 'TSF_vod__c') {
            id = HTMLConfig.tsfID;
        }

        return id;
    },
        initializeSFClient = function initializeSFClient(config) {
        sfClient.setSessionToken(config.sessionID);
        bridge = new Bridge(sfClient);
    },
        checkReady = function checkReady() {
        if (window.HTMLConfig) {
            initializeSFClient(window.HTMLConfig);
        } else {
            setTimeout(checkReady, 50);
        }
    };

    var protoTypeList = Object.getPrototypeOf(sfClient);
    for (prop in protoTypeList) {
        if (protoTypeList.hasOwnProperty(prop)) {
            if (methodWhiteList.indexOf(prop) < 0) {
                protoTypeList[prop] = function () {};
            }
        }
    }

    if (window.addEventListener) {
        window.addEventListener('message', listen, false);
    } else {
        window.attachEvent('onmessage', listen);
    }
    checkReady();
})(window.veevaBridge);
//# sourceMappingURL=main.js.map
