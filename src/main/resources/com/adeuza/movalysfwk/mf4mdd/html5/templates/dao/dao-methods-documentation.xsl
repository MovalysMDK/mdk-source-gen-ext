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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exsl="http://exslt.org/common"
xmlns:str="http://exslt.org/strings"
extension-element-prefixes="exsl">

<xsl:output method="text"/>

	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/dao/dao-methods-name.xsl"/>
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/dao/dao-methods-parameters.xsl"/>
	
	

	<xsl:template match="dao" mode="methods-documentation">
		<xsl:param name="methodNameToken" />
		<xsl:param name="methodParameterToken" />
		<xsl:param name="methodCriteriaToken" />
		
		
		<xsl:variable name="methodNameFull">
			<xsl:apply-templates select="." mode="methods-name">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="methodParametersFull">
			<xsl:apply-templates select="." mode="methods-parameters">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
			</xsl:apply-templates>
		</xsl:variable>
				
		
		<!-- function documentation -->
		<xsl:text>	/**&#10;</xsl:text>
		<xsl:text>	 * @ngdoc method&#10;</xsl:text>
   		<xsl:text>	 * @name </xsl:text><xsl:value-of select="//name"/><xsl:text>#</xsl:text><xsl:value-of select="$methodNameFull"/><xsl:text>&#10;</xsl:text>
   		<xsl:text>	 * @function&#10;</xsl:text>
   		<xsl:text>	 *&#10;</xsl:text>
   		<xsl:text>	 * @description&#10;</xsl:text>
   		<xsl:choose>
   			<xsl:when test="($methodNameToken= 'getNbEntities')">
   				<xsl:text>	 * Returns the number of entities.&#10;</xsl:text>
   			</xsl:when>
   			<xsl:when test="(substring($methodNameToken, 1, 3) = 'get')">
   				<xsl:choose>
   					<xsl:when test="($methodParameterToken='p_id')">
   						<xsl:text>	 * Returns a </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text> by id.&#10;</xsl:text>
					</xsl:when>					
					<xsl:when test="($methodParameterToken='p_ids')">
					   	<xsl:text>	 * Returns a list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s by ids.&#10;</xsl:text>
					</xsl:when>				
					<xsl:when test="(starts-with($methodNameFull, 'getList'))">
						<xsl:text>	 * Returns a list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s according to the parameter(s).&#10;</xsl:text>
   					</xsl:when>   					
   					<xsl:otherwise>
   						<xsl:text>	 * Returns the list of all </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s.&#10;</xsl:text>
   					</xsl:otherwise>
   				</xsl:choose>
   			</xsl:when>
   			   			
   			<xsl:when test="(substring($methodNameToken, 1, 12) = 'saveOrUpdate')">
   				<xsl:choose>
   					<xsl:when test="($methodParameterToken='p_entity')">
   						<xsl:text>	 * Saves of updates a </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>.&#10;</xsl:text>
					</xsl:when>					
					<xsl:when test="($methodParameterToken='p_entities')">
					   	<xsl:text>	 * Saves of updates a list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s.&#10;</xsl:text>
					</xsl:when>					
					<xsl:otherwise />
   				</xsl:choose>
   			</xsl:when>   			
   			
   			<xsl:when test="(substring($methodNameToken, 1, 4) = 'save')">
   				<xsl:choose>
   					<xsl:when test="($methodParameterToken='p_entity')">
   						<xsl:text>	 * Saves a </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>.&#10;</xsl:text>
					</xsl:when>					
					<xsl:when test="($methodParameterToken='p_entities')">
					   	<xsl:text>	 * Saves a list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s.&#10;</xsl:text>
					</xsl:when>					
					<xsl:otherwise />
   				</xsl:choose>
   			</xsl:when>
   			
   			
   			<xsl:when test="(substring($methodNameToken, 1, 6) = 'update')">
   				<xsl:choose>
   					<xsl:when test="($methodParameterToken='p_entity')">
   						<xsl:text>	 * Updates a </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>.&#10;</xsl:text>
					</xsl:when>					
					<xsl:when test="($methodParameterToken='p_entities')">
					   	<xsl:text>	 * Updates a list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s.&#10;</xsl:text>
					</xsl:when>					
					<xsl:otherwise />
   				</xsl:choose>
   			</xsl:when>
   			
   			<xsl:when test="(substring($methodNameToken, 1, 6) = 'delete')">
   				<xsl:choose>
   					<xsl:when test="($methodParameterToken='p_id')">
   						<xsl:text>	 * Deletes a </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text> by id.&#10;</xsl:text>
					</xsl:when>					
					<xsl:when test="($methodParameterToken='p_ids')">
					   	<xsl:text>	 * Deletes a list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s by ids.&#10;</xsl:text>
					</xsl:when>			
   					<xsl:when test="($methodParameterToken='p_entity')">
   						<xsl:text>	 * Delete a </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>.&#10;</xsl:text>
					</xsl:when>					
					<xsl:when test="($methodParameterToken='p_entities')">
					   	<xsl:text>	 * Deletes a list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s.&#10;</xsl:text>
					</xsl:when>					
					<xsl:otherwise />
   				</xsl:choose>
   			</xsl:when> 			
   			
   			<xsl:otherwise />
   		</xsl:choose>
   		<xsl:text>	 *&#10;</xsl:text>
   		
   		<xsl:if test="($methodParameterToken='p_id')">
   			<xsl:text>	 * @param {Integer} p_id Integer id of the </xsl:text><xsl:value-of select="/dao/class/name" /><xsl:text> to process&#10;</xsl:text>
   		</xsl:if>
   		<xsl:if test="($methodParameterToken='p_ids')">
   			<xsl:text>	 * @param {Array&lt;Integer&gt;} p_ids Array containing ids of </xsl:text><xsl:value-of select="/dao/class/name" /><xsl:text>s to process</xsl:text><xsl:if test="(substring($methodNameToken, 1, 3) = 'get')"><xsl:text> (optional)</xsl:text></xsl:if><xsl:text>&#10;</xsl:text>
   		</xsl:if>
   		<xsl:if test="($methodParameterToken='p_entity')">
   			<xsl:text>	 * @param {</xsl:text><xsl:value-of select="/dao/class/name" /><xsl:text>} p_entity </xsl:text><xsl:value-of select="/dao/class/name" /><xsl:text> to process&#10;</xsl:text>
   		</xsl:if>
   		<xsl:if test="($methodParameterToken='p_entities')">
   			<xsl:text>	 * @param {Array&lt;</xsl:text><xsl:value-of select="/dao/class/name" /><xsl:text>&gt;} p_entities Array containing </xsl:text><xsl:value-of select="/dao/class/name" /><xsl:text>s to process&#10;</xsl:text>
   		</xsl:if>
   		<xsl:if test="$methodCriteriaToken">  
   			<xsl:for-each select="(exsl:node-set($methodCriteriaToken)/criteria)">
   				<xsl:choose>
   					<!-- ends-with() equivalent -->
   					<xsl:when test="substring(@parameterName, string-length() - string-length('ids') +1)">
   						<xsl:text>	 * @param {Array&lt;Integer&gt;} </xsl:text><xsl:value-of select="@parameterName" /><xsl:text>&#10;</xsl:text>
   					</xsl:when>
   					<xsl:otherwise>
   						<xsl:text>	 * @param {?} </xsl:text><xsl:value-of select="@parameterName" /><xsl:text>&#10;</xsl:text>
   					</xsl:otherwise>
   				</xsl:choose>
	   		</xsl:for-each>
		</xsl:if>
   		
		<xsl:text>	 * @param {MFContext} p_context MFContext object&#10;</xsl:text>
		
		<xsl:if test="contains($methodParametersFull, 'p_cascadeSet')">
			<xsl:text>	 * @param {Array&lt;String&gt;} p_cascadeSet Array containing children tables names to process&#10;</xsl:text>
		</xsl:if>
		
		<xsl:if test="contains($methodParametersFull, 'p_toSync')">
			<xsl:text>	 * @param {Boolean} p_toSync Boolean equal to true when sync must be done, false otherwise&#10;</xsl:text>
		</xsl:if>
		
		<xsl:if test="contains($methodParametersFull, 'p_cascadeSetForDelete')">
			<xsl:text>	 * @param {Array&lt;String&gt;} p_cascadeSetForDelete Array containing children tables names with entites to delete within the process&#10;</xsl:text>
		</xsl:if>
		<xsl:text>	 *&#10;</xsl:text>
		
		<xsl:choose>
   			<xsl:when test="($methodNameToken= 'getNbEntities')">
   				<xsl:text>	 * @returns {Integer} Returns an Integer equal to the number of entities.&#10;</xsl:text>
   			</xsl:when>   			
   			<xsl:when test="(substring($methodNameToken, 1, 7) = 'getList')">
   				<xsl:text>	 * @returns {Array&lt;String&gt;} Returns an Array of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s, including children if required.&#10;</xsl:text>	
   			</xsl:when>
   			<xsl:when test="(substring($methodNameToken, 1, 3) = 'get')">
   				<xsl:text>	 * @returns {</xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>} Returns the </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>, including children if required&#10;</xsl:text>
			</xsl:when>
   			<xsl:when test="(substring($methodNameToken, 1, 16) = 'saveOrUpdateList')">
   				<xsl:text>	 * @returns {Array&lt;Promise&gt;} Returns an Array of promise results equal to true if the list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s was saved or updated, false otherwise.&#10;</xsl:text>
   			</xsl:when>   
   			<xsl:when test="(substring($methodNameToken, 1, 12) = 'saveOrUpdate')">
   				<xsl:text>	 * @returns {Promise} Returns a promise equal to true if the </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text> was saved or updated, false otherwise.&#10;</xsl:text>
   			</xsl:when>
   			<xsl:when test="(substring($methodNameToken, 1, 8) = 'saveList')">
   				<xsl:text>	 * @returns {Array&lt;Promise&gt;} Returns an Array of promise results equal to true if the list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s was saved, false otherwise.&#10;</xsl:text>
   			</xsl:when>   
   			<xsl:when test="(substring($methodNameToken, 1, 4) = 'save')">
   				<xsl:text>	 * @returns {Promise} Returns a promise equal to true if the </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text> was saved, false otherwise.&#10;</xsl:text>
   			</xsl:when>
   			<xsl:when test="(substring($methodNameToken, 1, 10) = 'updateList')">
   				<xsl:text>	 * @returns {Array&lt;Promise&gt;} Returns an Array of promise results equal to true if the list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s was updated, false otherwise.&#10;</xsl:text>
   			</xsl:when>   
   			<xsl:when test="(substring($methodNameToken, 1, 6) = 'update')">
   				<xsl:text>	 * @returns {Promise} Returns a promise equal to true if the </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text> was updated, false otherwise.&#10;</xsl:text>
   			</xsl:when>
   			<xsl:when test="(substring($methodNameToken, 1, 10) = 'deleteList')">
   				<xsl:text>	 * @returns {Array&lt;Promise&gt;} Returns an Array of promise results equal to true if the list of </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text>s was deleted, false otherwise.&#10;</xsl:text>
   			</xsl:when>   
   			<xsl:when test="(substring($methodNameToken, 1, 6) = 'delete')">
   				<xsl:text>	 * @returns {Promise} Returns a promise equal to true if the </xsl:text><xsl:value-of select="/dao/class/name"/><xsl:text> was deleted, false otherwise.&#10;</xsl:text>
   			</xsl:when>	
   			
   			<xsl:otherwise />
   		</xsl:choose>		
		<xsl:text>	 */&#10;</xsl:text>
	</xsl:template>

</xsl:stylesheet>