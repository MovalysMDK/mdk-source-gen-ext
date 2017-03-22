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

<!-- 
Load method generation
 -->
<xsl:template match="dataloader-impl[dataloader-interface/type = 'SINGLE'] | dataloader-impl[dataloader-interface/type = 'WORKSPACE']" mode="loadMethod">

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected <xsl:value-of select="dataloader-interface/entity-type/name"/> load(MContext p_oContext, String p_sKey, Set&lt;DataLoaderParts&gt; p_oReload) throws DataloaderException {
		
		<xsl:choose>
			<xsl:when test="dataloader-interface/entity-type/transient = 'true' and dataloader-interface/entity-type/scope = 'APPLICATION'">
				
				<xsl:apply-templates select="." mode="generate-inner-load-for-single"/>
				
				<xsl:text>return  this.</xsl:text>
				<xsl:value-of select="dataloader-interface/entity-type/attribute-name"/>
				<xsl:text>;&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="dataloader-interface/entity-type/name"/>
				<xsl:text> r_o</xsl:text>
				<xsl:value-of select="dataloader-interface/entity-type/name"/>
				<xsl:text>;&#13;&#13;</xsl:text>
				
				<xsl:apply-templates select="." mode="generate-inner-load-for-single"/>
			
				<xsl:text>return  r_o</xsl:text>
				<xsl:value-of select="dataloader-interface/entity-type/name"/>
				<xsl:text>;&#13;</xsl:text>	
			</xsl:otherwise>
		</xsl:choose>
		
	}

</xsl:template>

<xsl:template match="dataloader-impl[dataloader-interface/type = 'SINGLE'] | dataloader-impl[dataloader-interface/type = 'WORKSPACE']" mode="generate-inner-load-for-single">
	
	<xsl:if test="dataloader-interface/entity-type/transient = 'false'">
		<xsl:text>&#13;</xsl:text>
	</xsl:if>

	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">load</xsl:with-param>
		<xsl:with-param name="defaultSource">
				<xsl:if test="dataloader-interface/entity-type/transient = 'false'">
					<xsl:value-of select="dao-interface/name"/>
					<xsl:text> o</xsl:text>
					<xsl:value-of select="dao-interface/name"/>
					<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
					<xsl:value-of select="dao-interface/name"/>
					<xsl:text>.class);&#13;</xsl:text>
				</xsl:if>
				
				<xsl:for-each select="dataloader-interface/combo-daos/combo-dao">
					<xsl:value-of select="."/>
					<xsl:text> o</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>.class);&#13;&#13;</xsl:text>
				</xsl:for-each>
		
				<xsl:if test="dataloader-interface/entity-type/transient = 'false'">
					<xsl:text>try {&#13;</xsl:text>
					<xsl:text>if (p_oReload.contains(DataLoaderPartEnum.DATA)) {&#13;</xsl:text>
					<xsl:text>r_o</xsl:text>
					<xsl:value-of select="dataloader-interface/entity-type/name"/>
					<xsl:text> = o</xsl:text>
					<xsl:value-of select="dao-interface/name"/>
					<xsl:text>.get</xsl:text>
					<xsl:value-of select="dataloader-interface/entity-type/name"/>
					<xsl:text>(</xsl:text>
					<xsl:if test="dataloader-interface/entity-type/scope != 'APPLICATION'">
						<xsl:text>this.getItemId(p_sKey)</xsl:text>
					</xsl:if>
					<xsl:if test="dataloader-interface/entity-type/scope = 'APPLICATION'">
						<xsl:text>1L</xsl:text>
					</xsl:if>
					<xsl:text>,LOAD_CASCADE,p_oContext);&#13;</xsl:text>
					<xsl:text>} else {&#13;</xsl:text>
					<xsl:text>r_o</xsl:text>
					<xsl:value-of select="dataloader-interface/entity-type/name"/>
					<xsl:text> = this.getData(p_sKey);&#13;</xsl:text>
					<xsl:text>}&#13;</xsl:text>
					<xsl:apply-templates select="dataloader-interface/combos/combo" mode="get-combo-entity-list"/>
					
					<xsl:text>} catch (DaoException e) {&#13;</xsl:text>
					<xsl:text>throw new DataloaderException(e);&#13;</xsl:text>
					<xsl:text>}&#13;</xsl:text>
				</xsl:if>
				
				<xsl:if test="dataloader-interface/entity-type/transient = 'true' and dataloader-interface/entity-type/scope = 'APPLICATION'">
					<xsl:text>if (</xsl:text><xsl:value-of select="dataloader-interface/entity-type/attribute-name"/><xsl:text>==null){&#13;</xsl:text>
						<xsl:text>this.</xsl:text>
						<xsl:value-of select="dataloader-interface/entity-type/attribute-name"/>
						<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
						<xsl:value-of select="entity-factory/name"/>
						<xsl:text>.class).createInstance();&#13;</xsl:text>
					<xsl:text>}&#13;&#13;</xsl:text>
					
					<xsl:apply-templates select="dataloader-interface/combos" mode="get-combo-entity-list"/>
					<xsl:text>&#13;</xsl:text>
				</xsl:if>
				
				<xsl:if test="dataloader-interface/entity-type/transient = 'true' and dataloader-interface/entity-type/scope != 'APPLICATION'">
					<xsl:text>r_o</xsl:text>
					<xsl:value-of select="dataloader-interface/entity-type/name"/>
					<xsl:text> = null;&#13;</xsl:text>
				</xsl:if>
	
				
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="combos" mode="get-combo-entity-list">
	try {
		<xsl:apply-templates select="combo" mode="get-combo-entity-list"/>
	} catch (DaoException e) {
		throw new DataloaderException(e);
	}
</xsl:template>

<xsl:template match="combo" mode="get-combo-entity-list">
	<xsl:if test="./entity-synchronizable = 'true'"> 
		<xsl:text>if (this.</xsl:text><xsl:value-of select="entity-attribute-name"/><xsl:text> == null || this.isReloadFromSynchro()) {&#13;</xsl:text>
	</xsl:if>

	<!-- TODO if to reload -->
	
	<xsl:apply-templates select="." mode="affect-combo-list" />
	
	<xsl:if test="./entity-synchronizable = 'true'"><xsl:text>}&#13;</xsl:text></xsl:if>

</xsl:template>

<xsl:template match="dataloader-combo[cascades]" mode="get-combo-entity-list">

	<!-- TODO if to reload -->
	<xsl:apply-templates select="." mode="affect-combo-list">
		<xsl:with-param name="cascade"><xsl:value-of select="entity-attribute-name"/>Cascade</xsl:with-param>
	</xsl:apply-templates>

</xsl:template>

<xsl:template match="node()" mode="affect-combo-list">
	<xsl:param name="cascade">CascadeSet.NONE</xsl:param>
	<xsl:text>if (p_oReload.contains(DataLoaderPartEnum.</xsl:text>
	<xsl:value-of select="translate(entity-attribute-name, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
	<xsl:text>)) {&#13;</xsl:text>
	<xsl:text>this.</xsl:text>
	<xsl:value-of select="entity-attribute-name"/>
	<xsl:text> = o</xsl:text>
	<xsl:value-of select="dao-name"/>
	<xsl:text>.getList</xsl:text>
	<xsl:value-of select="entity"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$cascade"/>
	<xsl:text>, p_oContext);&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

<!-- 
Load method generation
 -->
<xsl:template match="dataloader-impl[dataloader-interface/type = 'LIST']" mode="loadMethod">

	<xsl:variable name="resultVarName">r_list<xsl:value-of select="dataloader-interface/entity-type/name"/></xsl:variable>

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected List&lt;<xsl:value-of select="dataloader-interface/entity-type/name"/>&gt; load(MContext p_oContext, String p_sKey, Set&lt;DataLoaderParts&gt; p_oReload) throws DataloaderException {
		List&lt;<xsl:value-of select="dataloader-interface/entity-type/name"/>&gt; <xsl:value-of select="$resultVarName"/> = null ;
		
		<xsl:if test="dataloader-interface/entity-type/transient = 'false'">
			<xsl:text>&#13;</xsl:text>
		</xsl:if>
		
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">load</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:if test="dataloader-interface/entity-type/transient = 'false'">
				<xsl:value-of select="dao-interface/name"/>
				<xsl:text> o</xsl:text>
				<xsl:value-of select="dao-interface/name"/>
				<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
				<xsl:value-of select="dao-interface/name"/>
				<xsl:text>.class);&#13;</xsl:text>
				try {
					<xsl:value-of select="$resultVarName"/>
					<xsl:text> = o</xsl:text>
					<xsl:value-of select="dao-interface/name"/>
					<xsl:text>.getList</xsl:text>
					<xsl:value-of select="dataloader-interface/entity-type/name"/>(LOAD_CASCADE, p_oContext);
				} catch (DaoException oDaoException) {
					throw new DataloaderException(oDaoException);
				}
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
		return <xsl:value-of select="$resultVarName"/> ;
	}
</xsl:template>

</xsl:stylesheet>
