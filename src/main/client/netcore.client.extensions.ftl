[#import "_macros.ftl" as global/]
[#function removeConstantParams params]
  [#local result = []]
  [#list params![] as param]
    [#if !param.constant??]
      [#local result = result + [param]/]
    [/#if]
  [/#list]
  [#return result/]
[/#function]
[#function getParamNames params]
  [#local result = []]
  [#list params as param]
    [#local result = result + [param.name]/]
  [/#list]
  [#return result?join(", ")/]
[/#function]
/*
 * Copyright (c) 2018-2020, FusionAuth, All Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 */

using System;
using System.Collections.Generic;
using io.fusionauth.domain;
using io.fusionauth.domain.api;
using io.fusionauth.domain.api.email;
using io.fusionauth.domain.api.identityProvider;
using io.fusionauth.domain.api.jwt;
using io.fusionauth.domain.api.passwordless;
using io.fusionauth.domain.api.report;
using io.fusionauth.domain.api.twoFactor;
using io.fusionauth.domain.api.user;
using io.fusionauth.domain.oauth2;

namespace io.fusionauth {
  public static class FusionAuthClientExtensions {
    [#list apis as api]
		[#assign params = removeConstantParams(api.params![])]

    /// <summary>
      [#list api.comments as comment]
    /// ${comment}
      [/#list]
    /// </summary>
    /// <param name="client">The <see cref="IFusionAuthClient"> to extend.</param>
      [#list params as param]
    /// <param name="${param.name}"> ${param.comments?join("\n     /// ")}</param>
      [/#list]
    /// <returns>
    /// When successful, the response will contain the log of the action. If there was a validation error or any
    /// other type of error, this will return the Errors object in the response. Additionally, if FusionAuth could not be
    /// contacted because it is down or experiencing a failure, the response will contain an Exception, which could be an
    /// IOException.
    /// </returns>
     [#if api.deprecated??]
    [Obsolete("${api.deprecated?replace("{{renamedMethod}}", (api.renamedMethod!'')?cap_first)}")]
     [/#if]
    public static ClientResponse<${global.convertType(api.successResponse, "csharp")}> ${api.methodName?cap_first}(this IFusionAuthClient client[#if params?size > 0], [/#if]${global.methodParameters(api, "csharp")}) {
      return client.${api.methodName?cap_first}Async(${getParamNames(params)}).GetAwaiter().GetResult();
    }
    [/#list]
  }
}
