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

	<!-- ##################################################
			METHODES PAR CRITERES : GET[...]BY[...]CRITERIA
			                        GET[...]BY[...]ID
			METHODES ASSOCIATIVES : GET[...]BY[...]IDS			
		 ################################################## -->
		 
	<xsl:template match="dao" mode="methods-extra">
		<xsl:param name="methodFilterToken"/>
	
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
					<xsl:if test="(../@type='getListEntiteByIds')"><xsl:text>ids</xsl:text></xsl:if>
					<xsl:if test="position() != last()"><xsl:text>And</xsl:text></xsl:if>
				</xsl:for-each>
	    	 </xsl:variable>
	    	 
			<xsl:variable name="methodParameterTokenVariable">				
				<xsl:for-each select="./method-parameter">
					<xsl:variable name="methodSignatureName"><xsl:value-of select="../@name"/></xsl:variable>
					<xsl:variable name="methodSignatureType"><xsl:value-of select="../@type"/></xsl:variable>
					
					<xsl:choose>
						<xsl:when test="../@type='getListEntiteByIds'">
							<xsl:text>p_foreignKeys_</xsl:text><xsl:value-of select="@name"/><xsl:text>ids</xsl:text>
						</xsl:when>
						<xsl:when test="association/join-table/name">
							<xsl:text>p_foreignKeys_</xsl:text><xsl:value-of select="@name"/>
						</xsl:when>
						<xsl:when test="count(../../method-signature[(@name=$methodSignatureName)]) > 1">
							<xsl:choose>
								<xsl:when test="../../method-signature[(@name=$methodSignatureName) and (@type=$methodSignatureType) and (@by-value='false')]/method-parameter/association">
									<xsl:text>p_foreignKeys_</xsl:text><xsl:value-of select="@name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>p_</xsl:text><xsl:value-of select="@name"/>
								</xsl:otherwise>
							</xsl:choose>	
						</xsl:when>
						<xsl:otherwise>							
							<xsl:text>p_</xsl:text><xsl:value-of select="@name"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
			</xsl:variable>
			
			
			<xsl:variable name="methodCriteriaTokenVariable">
				<xsl:for-each select="./method-parameter">
					<xsl:variable name="methodSignatureName"><xsl:value-of select="../@name"/></xsl:variable>
					<xsl:variable name="methodSignatureType"><xsl:value-of select="../@type"/></xsl:variable>
								
					<xsl:element name="criteria">
									
						<!-- parameterName -->
						<xsl:choose>
							<xsl:when test="../@type='getListEntiteByIds'">
								<xsl:attribute name="parameterName">	<xsl:text>p_foreignKeys_</xsl:text><xsl:value-of select="@name"/><xsl:text>ids</xsl:text>		</xsl:attribute>
							</xsl:when>
							<xsl:when test="association/join-table/name">
								<xsl:attribute name="parameterName">	<xsl:text>p_foreignKeys_</xsl:text><xsl:value-of select="@name"/>								</xsl:attribute>
							</xsl:when>
							<xsl:when test="count(../../method-signature[(@name=$methodSignatureName)]) > 1">
								<xsl:choose>
									<xsl:when test="../../method-signature[(@name=$methodSignatureName) and (@type=$methodSignatureType) and (@by-value='false')]/method-parameter/association">
										<xsl:attribute name="parameterName">	<xsl:text>p_foreignKeys_</xsl:text><xsl:value-of select="@name"/>						</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="parameterName">	<xsl:text>p_</xsl:text><xsl:value-of select="@name"/>									</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>	
							</xsl:when>
							<xsl:otherwise>							
								<xsl:attribute name="parameterName">	<xsl:text>p_</xsl:text><xsl:value-of select="@name"/>											</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>						
						
						<!-- sqlName -->
						<xsl:choose>
						
							<!-- sqlName: inner data: association/join-table/... -->
							<xsl:when test="association/join-table/name">
											<xsl:attribute name="sqlName">			<xsl:value-of select="association/join-table/name"/><xsl:text>.</xsl:text><xsl:value-of select="association/join-table/crit-fields/field/@name"/>	</xsl:attribute>
							</xsl:when>
							
							<!-- sqlName: inner data: association/field/... -->												
							<xsl:when test="association/field/@name">
											<xsl:attribute name="sqlName">			<xsl:value-of select="association/field/@name"/>																										</xsl:attribute>
							</xsl:when>
							
							<!-- sqlName: previous node data: ... -->
							<xsl:when test="count(../../method-signature[(@name=$methodSignatureName)]) > 1">
								<xsl:choose>
									<!-- sqlName: previous node data: association/join-table/... -->	
									<xsl:when test="../../method-signature[(@name=$methodSignatureName) and (@type=$methodSignatureType) and (@by-value='false')]/method-parameter/association/join-table/name">
											<xsl:attribute name="sqlName">
																					<xsl:value-of select="../../method-signature[(@name=$methodSignatureName) and (@type=$methodSignatureType) and (@by-value='false')]/method-parameter/association/join-table/name"/>
																					<xsl:text>.</xsl:text><xsl:value-of select="../../method-signature[(@name=$methodSignatureName) and (@type=$methodSignatureType) and (@by-value='false')]/method-parameter/association/join-table/crit-fields/field/@name"/>	
											</xsl:attribute>
									</xsl:when>
									
									<!-- sqlName: previous node data: association/field/... -->							
									<xsl:otherwise>
											<xsl:attribute name="sqlName">			
																					<xsl:value-of select="../../method-signature[(@name=$methodSignatureName) and (@type=$methodSignatureType) and (@by-value='false')]/method-parameter/association/field/@name"/>
											</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							
							<!-- sqlName: inner data: association/field/... -->	
							<xsl:otherwise>							
											<xsl:attribute name="sqlName">			<xsl:value-of select="attribute/field/@name"/>						</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>																
						
						<!-- byValue -->
						<xsl:attribute name="byValue">			<xsl:value-of select="../@by-value"/>									</xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:variable>
			
			
			<xsl:variable name="methodInnerJoinTokenVariable">
				<xsl:for-each select="./method-parameter">
					<xsl:variable name="methodSignatureName"><xsl:value-of select="../@name"/></xsl:variable>	
				
					<xsl:choose>					
						<xsl:when test="(association/join-table/name)">
							<xsl:element name="join">
								<xsl:attribute name="joinTableName">			<xsl:value-of select="association/join-table/name"/>					</xsl:attribute>
								<xsl:attribute name="classTableName">			<xsl:value-of select="../../class/table-name"/>							</xsl:attribute>
								<xsl:attribute name="classIdentifierName">		<xsl:value-of select="../../class/identifier/attribute/field/@name"/>	</xsl:attribute>
								<xsl:attribute name="joinTableKeyFieldName">	<xsl:value-of select="association/join-table/key-fields/field/@name"/>	</xsl:attribute>
								<xsl:attribute name="joinTableCritFieldName">	<xsl:value-of select="association/join-table/crit-fields/field/@name"/>	</xsl:attribute>
							</xsl:element>
						</xsl:when>	
						
						<xsl:when test="not(association/join-table/name)
											and (../../method-signature[(@name=$methodSignatureName) and (@type='getListEntite') and (@by-value='false')]/method-parameter/association/join-table/name)">
							<xsl:element name="join">
								<xsl:attribute name="joinTableName">			<xsl:value-of select="../../method-signature[(@name=$methodSignatureName) and (@type='getListEntite') and (@by-value='false')]/method-parameter/association/join-table/name"/>						</xsl:attribute>
								<xsl:attribute name="classTableName">			<xsl:value-of select="../../class/table-name"/>																																						</xsl:attribute>
								<xsl:attribute name="classIdentifierName">		<xsl:value-of select="../../class/identifier/attribute/field/@name"/>																																</xsl:attribute>
								<xsl:attribute name="joinTableKeyFieldName">	<xsl:value-of select="../../method-signature[(@name=$methodSignatureName) and (@type='getListEntite') and (@by-value='false')]/method-parameter/association/join-table/key-fields/field/@name"/>	</xsl:attribute>
								<xsl:attribute name="joinTableCritFieldName">	<xsl:value-of select="../../method-signature[(@name=$methodSignatureName) and (@type='getListEntite') and (@by-value='false')]/method-parameter/association/join-table/crit-fields/field/@name"/>	</xsl:attribute>
							</xsl:element>
						</xsl:when>
								
						<xsl:otherwise />
					</xsl:choose>					
				</xsl:for-each>
			</xsl:variable>
	    	 
	    	 
			<xsl:apply-templates select="./.." mode="simple-methods">
			    <xsl:with-param name="methodNameToken" 		select="$methodNameTokenVariable"/>
			    <xsl:with-param name="methodParameterToken" select="$methodParameterTokenVariable"/>
			    <xsl:with-param name="methodCriteriaToken" 	select="$methodCriteriaTokenVariable"/>
			    <xsl:with-param name="methodInnerJoinToken" select="$methodInnerJoinTokenVariable"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>