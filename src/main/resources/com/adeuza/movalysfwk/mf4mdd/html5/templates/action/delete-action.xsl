<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text"/>
	
	<xsl:template match="action[action-type='DELETEDETAIL']" mode="genereAction">

<xsl:variable name="vmFactory"><xsl:value-of select="viewmodel/name"/>Factory</xsl:variable>
<xsl:variable name="daoProxy"><xsl:value-of select="dao-interface/name"/>Proxy</xsl:variable>
<xsl:variable name="entity"><xsl:value-of select="class/name"/></xsl:variable>
<xsl:variable name="dataloader"><xsl:value-of select="viewmodel/dataloader-impl/name"/></xsl:variable>

<xsl:text>'use strict';&#10;</xsl:text>
<xsl:text>angular.module('view_</xsl:text><xsl:value-of select="viewmodel/uml-name"/><xsl:text>').factory('</xsl:text><xsl:value-of select="name"/><xsl:text>', [</xsl:text>

	<xsl:apply-templates select="." mode="declare-protocol-imports"/>

<xsl:text> {&#10;</xsl:text>
<xsl:text>        return {&#10;</xsl:text>
<xsl:text>            createInstance: function() {&#10;&#10;</xsl:text>

<xsl:text>                var action = MFBaseAction.createInstance({&#10;</xsl:text>
<xsl:text>                    atomic: true,&#10;</xsl:text>
<xsl:text>                    database: true,&#10;</xsl:text>
<xsl:text>                    type: '</xsl:text><xsl:value-of select="name"/><xsl:text>'&#10;</xsl:text>
<xsl:text>                });&#10;&#10;</xsl:text>

<xsl:text>                /**&#10;</xsl:text>
<xsl:text>                 * Execute operations&#10;</xsl:text>
<xsl:text>                 **/&#10;</xsl:text>
<xsl:text>                action.doAction = function(context, params) {&#10;&#10;</xsl:text>

<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">doAction</xsl:with-param>
			<xsl:with-param name="defaultSource">

<xsl:text>                    var that = this;&#10;</xsl:text>
<xsl:text>                    try {&#10;</xsl:text>	

<xsl:if test="class/transient = 'false'">

<xsl:text>                        if ( !angular.isUndefinedOrNull(</xsl:text><xsl:value-of select="$dataloader"/><xsl:text>.dataModel)) {&#10;</xsl:text>

<xsl:text>                            </xsl:text><xsl:value-of select="$daoProxy"/><xsl:text>.delete</xsl:text><xsl:value-of select="$entity"/>
		<xsl:text>(</xsl:text><xsl:value-of select="$dataloader"/>
		<xsl:text>.dataModel, context, []).then(function (modelEntity) {&#10;</xsl:text>

<xsl:text>                                </xsl:text><xsl:value-of select="$dataloader"/><xsl:text>.dataModel = null;&#10;</xsl:text>
<xsl:text>                                that.resolvePromise(</xsl:text><xsl:value-of select="$dataloader"/><xsl:text>.dataModel, context);&#10;</xsl:text>
<xsl:text>                            }, function (result) {&#10;</xsl:text>
<xsl:text>                                context.addError('Error deleting entity: ' + result.error);&#10;</xsl:text>
<xsl:text>                                that.rejectPromise(result.error, context);&#10;</xsl:text>
<xsl:text>                            });&#10;</xsl:text>
<xsl:text>                        }&#10;</xsl:text>

</xsl:if>

<xsl:text>                    } catch (error) {&#10;</xsl:text>
<xsl:text>                        context.addError('Error deleting entity: ' + error);&#10;</xsl:text>
<xsl:text>                        that.rejectPromise(error, context);&#10;</xsl:text>
<xsl:text>                    }&#10;</xsl:text>
<xsl:text>                    return this;&#10;</xsl:text>

	</xsl:with-param>
</xsl:call-template>

<xsl:text>                };&#10;&#10;</xsl:text>

<xsl:text>                return action;&#10;</xsl:text>
<xsl:text>            }&#10;&#10;</xsl:text>

<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
		<xsl:with-param name="defaultSource">
		</xsl:with-param>
</xsl:call-template>

<xsl:text>        };&#10;&#10;</xsl:text>

<xsl:text>    }&#10;</xsl:text>
<xsl:text>]);&#10;</xsl:text>

	</xsl:template>
	
	
	<xsl:template match="action[action-type='DELETEDETAIL']" mode="declare-extra-imports">
	
		<objc-import import="MFBaseAction" import-in-function="MFBaseAction" scope="local"/>
		
	</xsl:template>

</xsl:stylesheet>