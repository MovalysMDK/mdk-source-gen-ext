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

<!-- Traite les champs de la clé primaire ( deuxieme passe : on traite les cascades sur la clé primaire -->
<xsl:template name="jdbc-retrieve-pk-secondpass">
	<xsl:param name="interface"/>
	<xsl:param name="optimList"/>
	<xsl:param name="resultSet"/>

	<!-- si attribute d'association -->
	<xsl:if test="count(ancestor::association) = 1">
		<xsl:if test="count(following-sibling::attribute) = 0 ">

		<xsl:call-template name="jdbc-retrieve-readassociation-fromcache"/>
	
		<xsl:variable name="associationNameWithUpper"><xsl:text>o</xsl:text><xsl:call-template name="first-letter-to-uppercase"><xsl:with-param name="text"><xsl:value-of select="../@name"/></xsl:with-param></xsl:call-template></xsl:variable>
	
			if ( oCached<xsl:value-of select="../@name"/> != null ) {
				<xsl:text>r_o</xsl:text><xsl:value-of select="$interface/name"/>.<xsl:value-of select="../set-accessor"/>
				<xsl:text>(</xsl:text>oCached<xsl:value-of select="../@name"/>);
			}
			else {
				<xsl:text>r_o</xsl:text><xsl:value-of select="$interface/name"/>.<xsl:value-of select="../set-accessor"/>
				<xsl:text>(</xsl:text><xsl:value-of select="$associationNameWithUpper"/>);

				if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="../@cascade-name"/>)) {
				<!-- si optimisation par list -->
				<xsl:if test="$optimList = 'true'">
					<xsl:text>p_oCascadeOptim.registerEntityForCascade(</xsl:text>
					<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="../@cascade-name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="$associationNameWithUpper"/>
					<xsl:text>.idToString(), r_o</xsl:text>
					<xsl:value-of select="$interface/name"/>
					<xsl:text>, </xsl:text>
					<xsl:for-each select="../descendant::attribute">
						<xsl:value-of select="$associationNameWithUpper"/>
						<xsl:text>.</xsl:text>
						<xsl:if test="count(ancestor::association) = 2">
							<xsl:value-of select="get-accessor"/>
							<xsl:text>().</xsl:text>	
						</xsl:if>
						<xsl:value-of select="get-accessor"/>
						<xsl:text>()</xsl:text>
						<xsl:if test="position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsltext>);</xsltext>
				</xsl:if>
				
				<!-- si pas d'optim list -->
				<xsl:if test="$optimList = 'false'">
				<xsl:text>DaoQuery oDaoQuery = </xsl:text>
				<xsl:if test="../@self-ref = 'false'">
					<xsl:text>this.</xsl:text>
					<xsl:value-of select="../dao-interface/bean-ref"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:text>getSelectDaoQuery();</xsl:text>
				<xsl:text>r_o</xsl:text><xsl:value-of select="$interface/name"/>.<xsl:value-of select="../set-accessor"/>
				<xsl:text>( </xsl:text>
				<xsl:if test="../@self-ref = 'false'">
					<xsl:text>this.</xsl:text>
					<xsl:value-of select="../dao-interface/bean-ref"/>
					<xsl:text>.</xsl:text>
				</xsl:if>
				<xsl:text>get</xsl:text><xsl:value-of select="../interface/name"/>
				<xsl:text>(</xsl:text>
					<xsl:value-of select="$associationNameWithUpper"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="get-accessor"/>
						<xsl:text>()</xsl:text>
					<!--
					<xsl:for-each select="../attribute">
						<xsl:call-template name="replace-string">
							<xsl:with-param name="text">
								<xsl:call-template name="replace-string">
									<xsl:with-param name="text"><xsl:value-of select="jdbc-retrieve"/></xsl:with-param>
									<xsl:with-param name="from">POSITION</xsl:with-param>
									<xsl:with-param name="to"><xsl:value-of select="@pos"/></xsl:with-param>						
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="from">RESULTSET</xsl:with-param>
							<xsl:with-param name="to" select="$resultSet"/>
						</xsl:call-template>
					</xsl:for-each>
					 -->
				<xsl:text>, oDaoQuery, p_oCascadeSet, p_oDaoSession, p_oContext));</xsl:text>
				</xsl:if>
				}
			}
		</xsl:if>
		
	</xsl:if>

</xsl:template>

</xsl:stylesheet>