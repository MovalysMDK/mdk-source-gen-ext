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
	<xsl:include href="/com/adeuza/movalysfwk/mf4mdd/html5/templates/commons/replace-all.xsl"/>
	
	
	<xsl:variable name="replaceStep1From">p_foreignKeys_</xsl:variable>
	<xsl:variable name="replaceStep1To">'</xsl:variable>
	<xsl:variable name="replaceStep2From">p_</xsl:variable>
	<xsl:variable name="replaceStep2To">'</xsl:variable>
	<xsl:variable name="replaceStep3From">,</xsl:variable>
	<xsl:variable name="replaceStep3To">',</xsl:variable>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />


	<!-- ##################################################
			GESTION DES CASCADES
		 ################################################## -->

	<xsl:template match="dao" mode="generateCascadeData">
		<xsl:for-each select="/dao/class/association[(			(@type='many-to-many')
															or	(@type='many-to-one')
															or	(@type='one-to-many')
															or	(@type='one-to-one')
														)
														and (@transient='false')]">
			<xsl:element name="cascade">
				<xsl:attribute name="readAction">
					<xsl:choose>
						<!-- rules: xxx-to-many = getList, xxx-to-one = get -->
						<xsl:when test="(@type='many-to-many')">getList</xsl:when>
						<xsl:when test="(@type='many-to-one')">get</xsl:when>
						<xsl:when test="(@type='one-to-many')">getList</xsl:when>
						<xsl:when test="(@type='one-to-one')">get</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="parentAttrPointingChild">	<xsl:value-of select="@name"/>												</xsl:attribute>
				<xsl:attribute name="childDao">					<xsl:value-of select="class/name"/><xsl:text>Dao</xsl:text>					</xsl:attribute>
				<xsl:attribute name="childEntity">				<xsl:value-of select="class/name"/>											</xsl:attribute>
				<xsl:attribute name="childAttrPointingParent">	<xsl:value-of select="@opposite-name"/>										</xsl:attribute>
				<xsl:attribute name="aggregate-type">			<xsl:value-of select="@aggregate-type"/>									</xsl:attribute>
				<xsl:attribute name="opposite-navigable">		<xsl:value-of select="@opposite-navigable"/>									</xsl:attribute>
				<xsl:attribute name="relation-owner">			<xsl:value-of select="@relation-owner"/>									</xsl:attribute>
				<xsl:attribute name="type">						<xsl:value-of select="@type"/>												</xsl:attribute>
				<xsl:attribute name="opposite-aggregate-type">	<xsl:value-of select="@opposite-aggregate-type"/>                           </xsl:attribute>

				<xsl:attribute name="leftForeignKey">			
					<xsl:call-template name="string-lowercase">
						<xsl:with-param name="text" select="field/@name" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>


	<!-- ############################################################
			METHODES SIMPLES : GET/SAVE/UPDATE/SAVEORUPDATE/DELETE
		 ############################################################ -->

	<!-- generateMethodRecordName -->
	<xsl:template match="node()" mode="generateMethodRecordName">
		<xsl:param name="className" />
		<xsl:param name="methodNameToken"/>
		<xsl:param name="methodParameterToken"/>
	

		<xsl:choose>
			<xsl:when test="($methodParameterToken='')">
				<xsl:value-of select="$methodNameToken"/>
				<xsl:text>Record</xsl:text>
			</xsl:when>	
			<xsl:when test="($methodParameterToken='p_id')">
				<xsl:value-of select="$methodNameToken"/>
				<xsl:text>RecordById</xsl:text>
			</xsl:when>
			<xsl:when test="($methodParameterToken='p_ids')">
				<xsl:value-of select="$methodNameToken"/>
				<xsl:text>RecordByIds</xsl:text>
			</xsl:when>	
			<xsl:when test="	(not($methodNameToken = 'getNextId'))
							and	(not($methodNameToken = 'getNbEntities'))
							and	(not($methodNameToken = 'getTableName'))
							and (not(contains($methodNameToken, 'By')))">

							<xsl:value-of select="$methodNameToken"/>
							<xsl:text>Record</xsl:text>				
			</xsl:when>
			
			<xsl:otherwise>				
				<xsl:value-of select="substring-before($methodNameToken, $className)"></xsl:value-of>
				
				<xsl:if test="contains($methodNameToken, 'getNbEntitie')">
					<xsl:text>getNb</xsl:text>
				</xsl:if>

				<xsl:if test="contains($methodNameToken,'delete')"><xsl:text>List</xsl:text></xsl:if>
				<xsl:text>RecordByAttribute</xsl:text>
				
				<!-- 				Insert parameters into variable -->
				<xsl:variable name="methodParameterReplaceStep1">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="$methodParameterToken" />
					<xsl:with-param name="replace" select="$replaceStep1From" />
					<xsl:with-param name="by" select="$replaceStep1To" />
				</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="methodParameterReplaceStep2">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="$methodParameterReplaceStep1" />
					<xsl:with-param name="replace" select="$replaceStep2From" />
					<xsl:with-param name="by" select="$replaceStep2To" />
				</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="methodParameterReplaceStep3">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="$methodParameterReplaceStep2" />
					<xsl:with-param name="replace" select="$replaceStep3From" />
					<xsl:with-param name="by" select="$replaceStep3To" />
				</xsl:call-template>
				<xsl:text>'</xsl:text>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="contains($methodParameterReplaceStep3, ',')">
						<xsl:text>s([</xsl:text><xsl:value-of select="$methodParameterReplaceStep3" /><xsl:text>])</xsl:text>
					</xsl:when>
					<xsl:when test="contains(substring($methodParameterReplaceStep3, string-length($methodParameterReplaceStep3) - 2), 'id')">
						<xsl:text>(</xsl:text><xsl:value-of select="translate($methodParameterReplaceStep3, $uppercase, $smallcase)" /><xsl:text>)</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>(</xsl:text><xsl:value-of select="$methodParameterReplaceStep3" /><xsl:text>)</xsl:text>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	


	<xsl:template match="dao" mode="simple-methods">
		<xsl:param name="methodNameToken" />
		<xsl:param name="methodParameterToken" />		
		
		<xsl:variable name="methodNameFull">
			<xsl:apply-templates select="." mode="methods-name">
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="methodRecord">
			<xsl:apply-templates select="." mode="generateMethodRecordName">
				<xsl:with-param name="className" select="/dao/class/name"/>
				<xsl:with-param name="methodNameToken" select="$methodNameToken"/>
				<xsl:with-param name="methodParameterToken" select="$methodParameterToken"/>
			</xsl:apply-templates>
		</xsl:variable>

		<!-- function prototype -->
		<xsl:value-of select="//name"/><xsl:text>.prototype.</xsl:text><xsl:value-of select="$methodNameFull" /><xsl:text> = MFDaoNoSqlAbstract._</xsl:text><xsl:value-of select="$methodRecord" /><xsl:text>;&#10;</xsl:text>
	</xsl:template>


	
	<!-- ##################################################
			METHODES ASSOCIATIVES : GET[...]BY[...]IDS
			METHODES PAR CRITERES : GET[...]BY[...]
		 ################################################## -->

	<xsl:template match="dao" mode="extra-methods">	
		<xsl:param name="methodFilterToken"/>
		<xsl:param name="methodCascadeToken" />	
	
		<xsl:for-each select="/dao/method-signature[ 		(substring(@type, 1, 3)=$methodFilterToken)
														and (not(@type='existEntite')) ]">
			<xsl:variable name="methodNameTokenVariable">
				<xsl:choose>
					<xsl:when test="(@type='getNbEntite')">
						<xsl:text>getNbEntities</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(@type, 'Entite')"/>
						<xsl:value-of select="../class/uml-name"/>
					</xsl:otherwise>
				</xsl:choose>	    		
					
				<xsl:text>By</xsl:text>						
				<xsl:for-each select="./method-parameter">
					<xsl:value-of select="@name-capitalized"/>
					<xsl:if test="position() != last()"><xsl:text>And</xsl:text></xsl:if>
				</xsl:for-each>
	    	 </xsl:variable>
	    	 
			<xsl:variable name="methodParameterTokenVariable">				
				<xsl:for-each select="./method-parameter">
					<xsl:text>p_</xsl:text><xsl:if test="(../@type='getListEntiteByIds')"><xsl:text>foreignKeys_</xsl:text></xsl:if>
					<xsl:value-of select="@name"/>					
					<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
			</xsl:variable>
			
			
			<xsl:variable name="methodCriteriaTokenVariable">
				<xsl:for-each select="./method-parameter">
					<xsl:choose>
						<xsl:when test="(../@type='getListEntiteByIds')">
							<xsl:variable name="methodSignatureTempVariable"><xsl:value-of select="../@name"/></xsl:variable>
							<xsl:variable name="methodParameterTempVariable"><xsl:value-of select="@name"/></xsl:variable>
						
							<xsl:text>p_</xsl:text><xsl:if test="(../@type='getListEntiteByIds')"><xsl:text>foreignKeys_</xsl:text></xsl:if>							
							<xsl:value-of select="@name"/><xsl:text>|</xsl:text><xsl:value-of select="../../method-signature[(@name=$methodSignatureTempVariable) and (@type='getListEntite') and (@by-value='false')]/method-parameter/association/field/@name" />
<!-- 							<xsl:value-of select="../../method-signature[(@name=$methodSignatureTempVariable) and (@type='getListEntite') and (@by-value='false')]/method-parameter[(@name=substring-before($methodParameterTempVariable, 'ids'))]/association/field/@name" /> -->
							<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
						</xsl:when>						
						<xsl:otherwise>
							<xsl:text>p_</xsl:text>
							<xsl:value-of select="@name"/><xsl:text>|</xsl:text><xsl:value-of select="attribute/field/@name"/>
							<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:for-each>
			</xsl:variable>
	    	 
	    	 
			<xsl:apply-templates select="./.." mode="simple-methods">
			    <xsl:with-param name="methodNameToken" 		select="$methodNameTokenVariable"/>
			    <xsl:with-param name="methodParameterToken" select="$methodParameterTokenVariable"/>
			</xsl:apply-templates>		
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>