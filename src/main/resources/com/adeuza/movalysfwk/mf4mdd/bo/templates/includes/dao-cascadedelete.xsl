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

<!-- Exécution des cascades avant l'update/save -->
<xsl:template name="cascadedelete-before">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	<xsl:param name="object"/>
	<xsl:param name="traitement-list" select="'false'"/>

	<xsl:for-each select="$class/descendant::association[@transient='false' and (@type='one-to-many' or (@type='one-to-one' and @relation-owner='true')) and not(parent::association)]">
	if ( p_oCascadeSet.contains( <xsl:value-of select="$interface/name"/>
	<xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
	<xsl:text> )) {
	</xsl:text>
	
		<xsl:if test="$traitement-list = 'true'">
		for (<xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/> : <xsl:value-of select="$object"/>) {
		</xsl:if>
	
		<xsl:if test="@self-ref = 'false'">
			<xsl:text>this.</xsl:text>
			<xsl:value-of select="dao-interface/bean-ref"/>
			<xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:text>delete</xsl:text>
		<xsl:if test="$traitement-list = 'true'">
			<xsl:if test="@type='one-to-many'"><xsl:text>List</xsl:text></xsl:if>
			<xsl:value-of select="interface/name"/><xsl:text>(</xsl:text>
			<xsl:text> o</xsl:text>
			<xsl:value-of select="$interface/name"/>
		</xsl:if>
		<xsl:if test="$traitement-list = 'false'">
			<xsl:if test="@type='one-to-many'"><xsl:text>List</xsl:text></xsl:if>
			<xsl:value-of select="interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$object"/>			
		</xsl:if> 
		<xsl:text>.</xsl:text>
		<xsl:value-of select="get-accessor"/>
		<xsl:text>(), p_oCascadeSet, p_oContext );</xsl:text>
		
		<xsl:if test="$traitement-list = 'true'">
		}
		</xsl:if>
	}
	</xsl:for-each>

	<!-- Traitement de la join classe -->
	<xsl:for-each select="class/descendant::association[@transient='false' and @type='many-to-many' and not(parent::association)]">
	if ( p_oCascadeSet.contains( <xsl:value-of select="$interface/name"/>
	<xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
	<xsl:text> )) {
	</xsl:text>
	
		<xsl:if test="$traitement-list = 'true'">
		for (<xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/> : <xsl:value-of select="$object"/>) {
		</xsl:if>
	
		<xsl:text>this.</xsl:text>
		<xsl:value-of select="join-table/dao-interface/bean-ref"/>
		<xsl:text>.</xsl:text>

		<xsl:text>delete</xsl:text><xsl:value-of select="join-table/interface/name"/><xsl:text>By</xsl:text>
		<xsl:for-each select="join-table/key-fields/field">
			<xsl:value-of select="@method-crit-name"/>
			<xsl:if test="position() != last()">
				<xsl:text>And</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>( </xsl:text>
		
		<xsl:for-each select="$class/identifier/descendant::attribute">
		<xsl:if test="$traitement-list = 'true'">
			<xsl:text> o</xsl:text>
			<xsl:value-of select="$interface/name"/>
		</xsl:if>
		<xsl:if test="$traitement-list = 'false'">
			<xsl:value-of select="$object"/>
		</xsl:if> 
		<xsl:text>.</xsl:text>
		<xsl:value-of select="get-accessor"/>
		<xsl:text>()</xsl:text>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
		</xsl:for-each>
		
		<xsl:text>, p_oCascadeSet, p_oContext);</xsl:text>
		
		<xsl:if test="$traitement-list = 'true'">
		}
		</xsl:if>
		
	}
	</xsl:for-each>

</xsl:template>


<!-- Exécution des cascades après le delete -->
<xsl:template name="cascadedelete-after">
	<xsl:param name="interface"/>
	<xsl:param name="class"/>
	<xsl:param name="object"/>
	<xsl:param name="traitement-list" select="'false'"/>		
		
	<xsl:for-each select="$class/descendant::association[@transient='false' and (@type='many-to-one' or (@type='one-to-one' and @relation-owner='false') or @type='many-to-many') and not(parent::association)]">
	if ( p_oCascadeSet.contains( <xsl:value-of select="$interface/name"/>
	<xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
	<xsl:text> )</xsl:text>
	<xsl:if test="@type='many-to-many'">
		<xsl:text> &amp;&amp; p_oCascadeSet.contains(</xsl:text>
		<xsl:value-of select="$interface/name"/>
		<xsl:text>.Cascade.</xsl:text><xsl:value-of select="@joinclass-cascade-name"/>
		<xsl:text> )</xsl:text>	
	</xsl:if>
	<xsl:text>) {
	</xsl:text>
	
		<xsl:if test="$traitement-list = 'true'">
		for (<xsl:value-of select="$interface/name"/> o<xsl:value-of select="$interface/name"/> : <xsl:value-of select="$object"/>) {
		</xsl:if>

		<xsl:text>this.</xsl:text>	
		<xsl:if test="@self-ref = 'false'">
			<xsl:value-of select="dao-interface/bean-ref"/>
			<xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:text>delete</xsl:text>
		<xsl:if test="$traitement-list = 'true'">
			<xsl:if test="@type='many-to-many'"><xsl:text>List</xsl:text></xsl:if>
			<xsl:value-of select="interface/name"/><xsl:text>(</xsl:text>
			<xsl:text> o</xsl:text>
			<xsl:value-of select="$interface/name"/>
		</xsl:if>
		<xsl:if test="$traitement-list = 'false'">
			<xsl:if test="@type='many-to-many'"><xsl:text>List</xsl:text></xsl:if>
			<xsl:value-of select="interface/name"/><xsl:text>(</xsl:text>
			<xsl:value-of select="$object"/>
		</xsl:if> 
		<xsl:text>.</xsl:text>
		<xsl:value-of select="get-accessor"/>
		<xsl:text>(), p_oCascadeSet, p_oContext );</xsl:text>
		
		<xsl:if test="$traitement-list = 'true'">
		}
		</xsl:if>
	}
	</xsl:for-each>

</xsl:template>

</xsl:stylesheet>