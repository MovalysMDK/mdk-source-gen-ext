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

<!--<xsl:template name="cascade-getlist-init">
	<xsl:param name="interface"/>
	<xsl:param name="classe"/>
	<xsl:text>CascadeOptim oCascadeOptim = this.cascadeOptimDefinition.createCascadeOptim();</xsl:text>
</xsl:template>-->

	<xsl:template match="dao" mode="create-cascade-optim">
		<xsl:text>	/**&#13;</xsl:text>
		<xsl:text>	 * {@inheritDoc}&#13;</xsl:text>
		<xsl:text>	 */&#13;</xsl:text>
		<xsl:text>	@Override&#13;</xsl:text>
		<xsl:text>	protected CascadeOptim createCascadeOptim() {&#13;</xsl:text>
		<xsl:text>		return this.cascadeOptimDefinition.createCascadeOptim();&#13;</xsl:text>
		<xsl:text>	}&#13;</xsl:text>
	</xsl:template>

<!--
Initialise l'object CascadeOptim pour une chargement optimisé par List. 
-->
<!-- 
<xsl:template name="cascade-getlist-pre">
	<xsl:param name="interface"/>
	<xsl:param name="classe"/>
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected CascadeOptim preTraitementCascade() {
		<xsl:text>CascadeOptim r_oCascadeOptim = new CascadeOptim( </xsl:text><xsl:value-of select="//dao-interface/name"/>.PK_FIELDS, <xsl:value-of select="//dao-interface/name"/>.ALIAS_NAME );
		<!- - enregistrement des cascades many-to-one et relation vers 1
		et enregistrement des cascades one-one et relationOwner		
		 - ->
		<xsl:for-each select="$classe/descendant::association[(@type = 'many-to-one' or (@type='one-to-one' and @relation-owner='true')) and not(parent::association)]">
		r_oCascadeOptim.registerCascade(<xsl:value-of select="$interface/name"/>
		<xsl:text>.Cascade.</xsl:text>
		<xsl:value-of select="@cascade-name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>
		<xsl:text>.PK_FIELDS, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>
		<xsl:text>.ALIAS_NAME );</xsl:text>
		</xsl:for-each>

		<!- - enregistrement des cascades one-to-many 
		et enregistrement des cascades one-one et not relationOwner  (utilisé pour le fill)
		 - ->
		<xsl:for-each select="$classe/descendant::association[(@type = 'one-to-many' or (@type='one-to-one' and @relation-owner='false')) and not(parent::association)]">
		r_oCascadeOptim.registerCascade(<xsl:value-of select="$interface/name"/>
		<xsl:text>.Cascade.</xsl:text>
		<xsl:value-of select="@cascade-name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>
		<xsl:text>.ALIAS_NAME );</xsl:text>
		</xsl:for-each>
		
		<!- - enregistrement des cascades many-to-many
		 - ->
		<xsl:for-each select="$classe/descendant::association[@type = 'many-to-many' and not(parent::association)]">
			r_oCascadeOptim.registerCascade(<xsl:value-of select="$interface/name"/>
				<xsl:text>.Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="join-table/dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
				<xsl:text>, </xsl:text><xsl:value-of select="dao-interface/name"/>.ALIAS_NAME);
				
			r_oCascadeOptim.registerJoinClass(<xsl:value-of select="$interface/name"/>
			<xsl:text>.Cascade.</xsl:text>
			<xsl:value-of select="@cascade-name"/>
			<xsl:text>);</xsl:text>
		</xsl:for-each>
		
		return r_oCascadeOptim ;
	}

</xsl:template>
 -->
<!--
Initialise l'object CascadeOptim pour une chargement optimisé par List. 
-->
<xsl:template name="cascade-init-optimDefinition">
	<xsl:param name="interface"/>
	<xsl:param name="classe"/>
	
	/**
	 * Définition des optimisations des cascades
	 */
	protected CascadeOptimDefinition cascadeOptimDefinition ;
	
</xsl:template>

<xsl:template name="cascade-init-optimDefinition-initialize">
	<xsl:param name="interface"/>
	<xsl:param name="classe"/>
	
	<!-- enregistrement des cascades many-to-one et relation vers 1
	et enregistrement des cascades one-one et relationOwner		
	 -->
	 
	cascadeOptimDefinition = new CascadeOptimDefinition(<xsl:value-of select="//dao-interface/name"/>
		<xsl:text>.PK_FIELDS, </xsl:text><xsl:value-of select="//dao-interface/name"/>.ALIAS_NAME);
	 
	<xsl:for-each select="$classe/descendant::association[@transient = 'false' and (@type = 'many-to-one' or (@type='one-to-one' and @relation-owner='true')) and not(parent::association)]">
		cascadeOptimDefinition.registerCascade(<xsl:value-of select="$interface/name"/>
		<xsl:text>Cascade.</xsl:text>
		<xsl:value-of select="@cascade-name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>
		<xsl:text>.PK_FIELDS, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>
		<xsl:text>.ALIAS_NAME );</xsl:text>
	</xsl:for-each>

	<!-- enregistrement des cascades one-to-many 
	et enregistrement des cascades one-one et not relationOwner  (utilisé pour le fill)		
	 -->		
	<xsl:for-each select="$classe/descendant::association[@transient = 'false' and (@type = 'one-to-many' or (@type='one-to-one' and @relation-owner='false')) and not(parent::association)]">
		cascadeOptimDefinition.registerCascade(<xsl:value-of select="$interface/name"/>
		<xsl:text>Cascade.</xsl:text>
		<xsl:value-of select="@cascade-name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="dao-interface/name"/>
		<xsl:text>.ALIAS_NAME );</xsl:text>
	</xsl:for-each>
		
	<!-- enregistrement des cascades many-to-many		
	 -->
	<xsl:for-each select="$classe/descendant::association[@transient = 'false' and @type = 'many-to-many' and not(parent::association)]">
		cascadeOptimDefinition.registerCascade(<xsl:value-of select="$interface/name"/>
			<xsl:text>Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="join-table/dao-interface/name"/>.FK_<xsl:value-of select="@opposite-cascade-name"/>
			<xsl:text>, </xsl:text><xsl:value-of select="dao-interface/name"/>.ALIAS_NAME);
			
		cascadeOptimDefinition.registerJoinClass(<xsl:value-of select="$interface/name"/>
		<xsl:text>Cascade.</xsl:text>
		<xsl:value-of select="@cascade-name"/>
		<xsl:text>);</xsl:text>
	</xsl:for-each>
</xsl:template>

<!--
Initialise l'object CascadeOptim pour une chargement optimisé par List. 
-->
<!--<xsl:template name="cascade-fill-pre">
	<xsl:param name="interface"/>
	<xsl:param name="classe"/>

</xsl:template>
-->



	<xsl:template name="cascade-getlist-preTraitementCascadeN">
		<xsl:param name="interface"/>
		<xsl:param name="traitementFill">false</xsl:param>
		<xsl:param name="object">r_o<xsl:value-of select="$interface/name"/></xsl:param>

		<xsl:for-each select="class/association[@transient = 'false' and (@type='one-to-many' or @type='many-to-many')]">
		<!-- Si traitement fill -->
		<xsl:if test="$traitementFill = 'true' and count(interface/linked-interfaces/linked-interface[ name = 'MethodLoadable']) > 0">
		if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>)) {
			<!-- Si la relation est null, on instancie la liste -->
			if ( <xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/><xsl:text>() == null ) {</xsl:text>
				<xsl:value-of select="$object"/>.<xsl:value-of select="set-accessor"/>
				<xsl:text>( new ArrayList&lt;</xsl:text><xsl:value-of select="interface/name"/>&gt;());
				p_oCascadeOptim.registerEntityForCascade(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>, 
					<xsl:value-of select="$object"/>.idToString(), <xsl:value-of select="$object"/>, <xsl:value-of select="$object"/>.getId());
			}
			else {
				for( <xsl:value-of select="interface/name"/> o<xsl:value-of select="interface/name"/><xsl:text> : </xsl:text>
					<xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>()) {
					p_oCascadeOptim.registerEntityForCascadeUsingLoadMethod(<xsl:value-of select="$interface/name"/>
					<xsl:text>Cascade.</xsl:text><xsl:value-of select="@cascade-name"/>, o<xsl:value-of select="interface/name"/>);
				}
			}
		}				
		</xsl:if>
		<xsl:if test="not($traitementFill = 'true' and count(interface/linked-interfaces/linked-interface[ name = 'MethodLoadable']) > 0)">
		if ( p_oCascadeSet.contains(<xsl:value-of select="$interface/name"/>Cascade.<xsl:value-of select="@cascade-name"/>
			<xsl:text>) &amp;&amp; </xsl:text>
			<xsl:value-of select="$object"/>.<xsl:value-of select="get-accessor"/>() == null) {
			<xsl:value-of select="$object"/>.<xsl:value-of select="set-accessor"/>
				<xsl:text>( new ArrayList&lt;</xsl:text><xsl:value-of select="interface/name"/>&gt;());			
		}
		</xsl:if>
		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>