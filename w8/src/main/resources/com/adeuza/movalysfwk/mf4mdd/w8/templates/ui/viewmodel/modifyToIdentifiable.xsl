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
				
<!-- updateFromIdentifiable method (implementation)-->
<xsl:template match="viewmodel" mode="modifyToIdentifiable-method">

	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override void ModifyToIdentifiable(IMEntity entity, IMFContext context){&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">modifyToIdentifiable-before</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="./entity-to-update/name">
		<xsl:value-of select="./entity-to-update/name"/><xsl:text> _entity = entity as </xsl:text>
		<xsl:value-of select="./entity-to-update/name"/><xsl:text>;</xsl:text>
		<xsl:apply-templates select="mapping" mode="generate-method-modify"/>
	</xsl:if>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">modifyToIdentifiable-after</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;&#13;</xsl:text>
	
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override IMEntity ModifyToIdentifiable(IMFContext context){&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">modifyToIdentifiable-before</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="./entity-to-update/name">
		<xsl:value-of select="./entity-to-update/name"/><xsl:text> _entity = ClassLoader.GetInstance().GetBean<![CDATA[<]]></xsl:text>
		<xsl:value-of select="./entity-to-update/name"/><![CDATA[>]]><xsl:text>();</xsl:text>
		<xsl:apply-templates select="mapping" mode="generate-method-modify"/>
		<xsl:text>&#13;</xsl:text>
	</xsl:if>
	
	<xsl:choose> 
		<xsl:when test="./entity-to-update/name">
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">modifyToIdentifiable-after</xsl:with-param>
				<xsl:with-param name="defaultSource"></xsl:with-param>
			</xsl:call-template>
			<xsl:text>return _entity;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">modifyToIdentifiable-after</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>return null;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>}&#13;&#13;</xsl:text>
	
</xsl:template>


<xsl:template match="mapping" mode="generate-method-modify">
	<xsl:text>if (_entity != null) {</xsl:text>
	<xsl:apply-templates select="attribute[setter]" mode="generate-method-modify"/>
	<xsl:apply-templates select="entity[setter]" mode="generate-method-modify"/>
	<xsl:apply-templates select="../dataloader-impl/dao-interface/dao/class/association[@type='many-to-one']" mode="generate-method-modify"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">modify-to-identifiable</xsl:with-param>
		<xsl:with-param name="defaultSource"></xsl:with-param>
	</xsl:call-template>
	
	<xsl:apply-templates select="../external-lists/external-list/viewmodel" mode="generate-method-modify"/>
	
	<xsl:text>}&#13;</xsl:text>
</xsl:template>	


<xsl:template match="entity" mode="generate-method-modify">
	<xsl:param name="var-parent-entity">_entity</xsl:param>

	<xsl:variable name="var-entity">
		<xsl:text>o</xsl:text><xsl:value-of select="@type"/>
	</xsl:variable>
	
	<xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="getter/@name"/>
		</xsl:call-template>
	</xsl:variable>
						
	<xsl:variable name="setter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="setter/@name"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:if test=".//attribute/setter">
		<xsl:text>{</xsl:text>

		<xsl:if test="@mandatory = 'false'">
		if ( <xsl:apply-templates select=".//attribute" mode="testEntityFieldsValued"/> ) {
		</xsl:if>
			
		<xsl:value-of select="@type"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="$getter-name"/>
		<xsl:text>;</xsl:text>
		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> == null) {</xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> = </xsl:text>
		<xsl:text> ClassLoader.GetInstance().GetBean&lt;</xsl:text>
		<xsl:value-of select="@type"/>
		<xsl:text>Factory&gt;().CreateInstance();</xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="$setter-name"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text>;}&#13;</xsl:text>

		<xsl:apply-templates select="attribute[setter]" mode="generate-method-modify">
			<xsl:with-param name="var-entity" select="$var-entity"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="entity" mode="generate-method-modify">
			<xsl:with-param name="var-parent-entity" select="$var-entity"/>
		</xsl:apply-templates>
			
		<xsl:if test="@mandatory = 'false'">
		}
		else {
			<xsl:value-of select="$var-parent-entity"/>
			<xsl:text>.</xsl:text>
			<xsl:value-of select="$setter-name"/>
			<xsl:text> = null;</xsl:text>
		}
		</xsl:if>

		<xsl:text>}&#13;</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template match="entity[@mapping-type='vm']" mode="generate-method-modify">
	<xsl:param name="var-parent-entity">_entity</xsl:param>

	<xsl:text>if (this.</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text> == null) {</xsl:text>

	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="setter/@name"/>
	<xsl:text>= null ;</xsl:text>

	<xsl:text>} else {</xsl:text>

	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="setter/@name"/>
	<xsl:text>(ClassLoader.GetInstance().GetBean&lt;</xsl:text>
	<xsl:value-of select="setter/@factory"/>
	<xsl:text>&gt;().CreateInstance());</xsl:text>

	<xsl:text>this.</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text>.ModifyToIdentifiable(</xsl:text>
	<xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="getter/@name"/>
	<xsl:text>);</xsl:text>
	
	<xsl:text>}&#13;</xsl:text>
</xsl:template>
	
	
<xsl:template match="entity[@mapping-type='vmlist' and setter and ../../type/name!='LISTITEM_2' and ../../type/name!='LISTITEM_3']" mode="generate-method-modify">
	<xsl:param name="var-parent-entity">_entity</xsl:param>

	<!--vm-property-name prefix is 'vM' instead 'VM'  fix-->
	<xsl:variable name="viewModelName" select="concat(translate(substring(@vm-property-name,1,1),'v','V'),substring(@vm-property-name,2))"/>
	<xsl:variable name="viewModelNode" select="../../subvm/viewmodel[property-name = $viewModelName]"/>
	<xsl:variable name="vmIdentifier" select="$viewModelNode/identifier/attribute/@name"/>
	<xsl:variable name="entityIdentifier" select="$viewModelNode/mapping/attribute[@vm-attr = $vmIdentifier]/getter/@name"/>
	<xsl:variable name="cellVmType" select="$viewModelNode/subvm/viewmodel/implements/interface/@name"/>
	<xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="getter/@name"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:text>if (this.</xsl:text><xsl:value-of select="$viewModelNode/name"/><xsl:text> != null) {</xsl:text>
	<xsl:text>Dictionary&lt;String, </xsl:text><xsl:value-of select="@type"/><xsl:text>&gt; dictById = new Dictionary&lt;String, </xsl:text>
	<xsl:value-of select="@type"/><xsl:text>&gt;();</xsl:text>
	if ( _entity.<xsl:value-of select="$getter-name"/> != null ) {
	foreach( <xsl:value-of select="@type"/> entityForList in _entity.<xsl:value-of select="$getter-name"/>
	<xsl:text>) { dictById.Add(entityForList.</xsl:text>
	<xsl:variable name="entityIdentifier-upperfirt">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="$entityIdentifier"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$entityIdentifier-upperfirt"/>
	<xsl:text>.ToString(), entityForList);</xsl:text>
	}
	<xsl:text>_entity.</xsl:text><xsl:value-of select="$getter-name"/><xsl:text> = new List&lt;</xsl:text>
	<xsl:value-of select="@type"/><xsl:text>&gt;();</xsl:text>
	}
	foreach( <xsl:value-of select="$cellVmType"/><xsl:text> vmCell in this.</xsl:text><xsl:value-of select="$viewModelNode/name"/>.ListViewModel) {
	<xsl:value-of select="@type"/><xsl:text> entityForList = null;</xsl:text>
	<xsl:text>if(dictById.ContainsKey(vmCell.</xsl:text>
	<xsl:variable name="vmIdentifier-upperfirt">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="$vmIdentifier"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$vmIdentifier-upperfirt"/><xsl:text>.ToString())){</xsl:text>
	<xsl:text>entityForList = dictById[vmCell.</xsl:text>
	<xsl:value-of select="$vmIdentifier-upperfirt"/><xsl:text>.ToString()];}</xsl:text>
	<xsl:text>if ( entityForList == null ) {
	               entityForList = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
	<xsl:value-of select="@type"/>
	<xsl:text>Factory&gt;().CreateInstance();
	           }
	           vmCell.ModifyToIdentifiable(entityForList, context);
	           _entity.</xsl:text><xsl:value-of select="getter/@add-method"/><xsl:text>(entityForList);</xsl:text>
	
	<xsl:if test="@aggregate-type = 'COMPOSITE'">
		<xsl:text>dictById.Remove(vmCell.</xsl:text><xsl:value-of select="$vmIdentifier-upperfirt"/><xsl:text>.ToString());</xsl:text>
	</xsl:if>
	<xsl:text>}}&#13;</xsl:text>
</xsl:template>	
	
	
<xsl:template match="entity[@mapping-type='vmlist' and setter and ../../type/name='LISTITEM_2' or ../../type/name='LISTITEM_3']" mode="generate-method-modify">
	<xsl:param name="var-parent-entity">_entity</xsl:param>

	<!--vm-property-name prefix is 'vM' instead 'VM'  fix-->
	<xsl:variable name="viewModelName" select="concat(translate(substring(@vm-property-name,1,1),'v','V'),substring(@vm-property-name,2))"/>
	<xsl:variable name="viewModelNode" select="../../subvm/viewmodel[property-name = $viewModelName]"/>
	<xsl:variable name="vmIdentifier" select="$viewModelNode/subvm/viewmodel/identifier/attribute/@name"/>
	<xsl:variable name="entityIdentifier" select="$viewModelNode/subvm/viewmodel/mapping/attribute[@vm-attr = $vmIdentifier]/getter/@name"/>
	<xsl:variable name="cellVmType" select="$viewModelNode/subvm/viewmodel/implements/interface/@name"/>

	<xsl:text>if (this.</xsl:text><xsl:value-of select="$viewModelNode/name"/><xsl:text> != null) {</xsl:text>
	<xsl:text>Dictionary&lt;String, </xsl:text><xsl:value-of select="@type"/><xsl:text>&gt; dictById = new Dictionary&lt;String, </xsl:text><xsl:value-of select="@type"/><xsl:text>&gt;();</xsl:text>
	<xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="getter/@name"/>
		</xsl:call-template>
	</xsl:variable>
           if ( _entity.<xsl:value-of select="$getter-name"/> != null ) {
               foreach( <xsl:value-of select="@type"/><xsl:text> entityForList in _entity.</xsl:text><xsl:value-of select="$getter-name"/><xsl:text>) {
                   dictById.Add(entityForList.</xsl:text>
                   <xsl:variable name="entityIdentifier-upperfirt"><xsl:call-template name="string-uppercase-firstchar">
					<xsl:with-param name="text" select="$entityIdentifier"/>
					</xsl:call-template></xsl:variable>
					<xsl:value-of select="$entityIdentifier-upperfirt"/>
                   <xsl:text>.ToString(),entityForList);
               }</xsl:text>
               <xsl:text>_entity.</xsl:text>
               <xsl:value-of select="$getter-name"/>
               <xsl:text> = new List&lt;</xsl:text><xsl:value-of select="@type"/><xsl:text>&gt;();</xsl:text>
           }
           foreach( <xsl:value-of select="$cellVmType"/> vmCell in this.<xsl:value-of select="$viewModelNode/name"/>.ListViewModel) {
				<xsl:value-of select="@type"/><xsl:text> entityForList = null;</xsl:text>
				<xsl:text>if(dictById.ContainsKey(vmCell.</xsl:text>
				<xsl:variable name="vmIdentifier-upperfirt">
               		<xsl:call-template name="string-uppercase-firstchar">
						<xsl:with-param name="text" select="$vmIdentifier"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$vmIdentifier-upperfirt"/><xsl:text>.ToString())){</xsl:text>
                <xsl:text>entityForList = dictById[vmCell.</xsl:text>
				<xsl:value-of select="$vmIdentifier-upperfirt"/><xsl:text>.ToString()];}</xsl:text>
               	<xsl:text>if ( entityForList == null ) {
                   entityForList = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
				<xsl:value-of select="@type"/>
				<xsl:text>Factory&gt;().CreateInstance();
               }
               vmCell.ModifyToIdentifiable(entityForList, context);
               _entity.</xsl:text><xsl:value-of select="getter/@add-method"/>(entityForList);
           }
	<xsl:text>}&#13;</xsl:text>
</xsl:template>	
	
<xsl:template match="attribute[setter]" mode="generate-method-modify">
	<xsl:param name="var-entity">_entity</xsl:param>

	<xsl:choose>
		<xsl:when test="setter/@formula">
		
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="text">
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="text">
							<xsl:call-template name="string-replace-all">
								<xsl:with-param name="text">
									<xsl:call-template name="string-replace-all">
										<xsl:with-param name="text" select="setter/@formula"/>
										<xsl:with-param name="replace" select="'COMPONENT'"/>
										<xsl:with-param name="by">
											<xsl:value-of select="$var-entity"/><xsl:text>.</xsl:text>
											<xsl:variable name="setter-name"><xsl:call-template name="string-uppercase-firstchar">
											<xsl:with-param name="text" select="setter/@name"/>
											</xsl:call-template></xsl:variable>
											<xsl:value-of select="$setter-name"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:with-param>
								<xsl:with-param name="replace" select="'VALUE'"/>
								<xsl:with-param name="by">
									<xsl:text>this.</xsl:text>
									<xsl:variable name="vm-attr"><xsl:call-template name="string-uppercase-firstchar">
									<xsl:with-param name="text" select="@vm-attr"/>
									</xsl:call-template></xsl:variable>
									<xsl:value-of select="$vm-attr"/>
				    				<xsl:choose>
				    					<xsl:when test="contains(@vm-attr,'_id')='true'">
											<xsl:text></xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>.Value</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="replace" select="'FACTORY'"/>
						<xsl:with-param name="by">
							<xsl:value-of select="@expandableEntityShortName"/><xsl:text>Factory</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="replace" select="'RESULT'"/>
				<xsl:with-param name="by">
					<xsl:value-of select="$var-entity"/><xsl:text>.</xsl:text>
					<xsl:variable name="setter-name"><xsl:call-template name="string-uppercase-firstchar">
					<xsl:with-param name="text" select="setter/@name"/>
					</xsl:call-template></xsl:variable>
					<xsl:value-of select="$setter-name"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="$var-entity"/>
			<xsl:text>.</xsl:text>
			<xsl:variable name="setter-name">
				<xsl:call-template name="string-uppercase-firstchar">
					<xsl:with-param name="text" select="setter/@name"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$setter-name"/>
			<xsl:text> = </xsl:text>			
			<xsl:text>this.</xsl:text>
			<xsl:variable name="vm-attr">
				<xsl:call-template name="string-uppercase-firstchar">
					<xsl:with-param name="text" select="@vm-attr"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$vm-attr"/>
	    	<xsl:choose>
		    	<xsl:when test="contains(@vm-attr,'_id')='true'">
					<xsl:text></xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>.Value</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:text>;&#13;</xsl:text>
</xsl:template>


<xsl:template match="attribute" mode="generate-method-modify">
	<xsl:text>// Pas de mise à jour de l'entité pour l'attribut </xsl:text>
	<xsl:variable name="vm-attr">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="@vm-attr"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$vm-attr"/>
	<xsl:text>&#13;</xsl:text>
</xsl:template>


<xsl:template match="attribute" mode="testEntityFieldsValued">
	<xsl:if test="position() > 1">
		<xsl:text>||</xsl:text>
	</xsl:if>
	<xsl:text>this._</xsl:text>
	<xsl:value-of select="@vm-attr"/>
	<xsl:text> != null </xsl:text>
</xsl:template>

<!--  Cas d'une pickerlist -->
<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="generate-method-modify">
	<xsl:param name="var-parent-entity">_entity</xsl:param>
	
	<xsl:variable name="comboViewModelName">
		<xsl:value-of select="implements/interface/@name"/>
	</xsl:variable>
	
	<!-- <xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="../../../mapping/entity[@vm-type = $comboViewModelName]/getter/@name"/>
		</xsl:call-template>
	</xsl:variable> -->
	
	<xsl:variable name="getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="../../../mapping/entity[@vm-type=$comboViewModelName]">
						<xsl:value-of select="../../../mapping/entity[@vm-type = $comboViewModelName]/getter/@name"/>
					</xsl:when>
					<xsl:when test="../../../mapping/entity/entity[@vm-type=$comboViewModelName]">
						<xsl:value-of select="../../../mapping/entity/entity[@vm-type = $comboViewModelName]/../getter/@name"/>
						<xsl:text>.</xsl:text>
						<xsl:call-template name="string-uppercase-firstchar">
							<xsl:with-param name="text">
								<xsl:value-of select="../../../mapping/entity/entity[@vm-type = $comboViewModelName]/getter/@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="identifier-getter-name">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="../../../mapping/attribute[@vm-attr='id_id']/getter/@name"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="selectionName">
		<xsl:choose>
			<xsl:when test="../../../../viewmodel[type/name='FIXED_LIST_ITEM']">
				<xsl:value-of select="type/item"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="type/item"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	

	<xsl:text>if(this.Selected</xsl:text>
	<xsl:value-of select="$selectionName"/>
	<xsl:text> != null){</xsl:text>
	<xsl:value-of select="entity-to-update/factory-name"/>
	<xsl:text> o</xsl:text><xsl:value-of select="entity-to-update/factory-name"/>
	<xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text>
	<xsl:value-of select="entity-to-update/factory-name"/>
	<xsl:text>&gt;();</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
	<xsl:text> o</xsl:text><xsl:value-of select="entity-to-update/name"/>
	<xsl:text> = o</xsl:text><xsl:value-of select="entity-to-update/factory-name"/><xsl:text>.CreateInstance();</xsl:text>
	<xsl:text> o</xsl:text><xsl:value-of select="entity-to-update/name"/><xsl:text>.</xsl:text><xsl:value-of select="$identifier-getter-name"/>
	<xsl:text> = this.Selected</xsl:text>
	<xsl:value-of select="$selectionName"/>
    <xsl:text>.</xsl:text>
<!--         Ceci est l'identifier du mauvais VM, mais ces deux VM étant construits a partir des même données, leur variable d'id auront toujours le meme nom -->
    <xsl:value-of select="identifier/attribute/@name-capitalized"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="$getter-name"/>
    <xsl:text> = </xsl:text>
    <xsl:text> o</xsl:text><xsl:value-of select="entity-to-update/name"/>
    <xsl:text>;</xsl:text>       
    <xsl:text>}&#13;else{</xsl:text>
    <xsl:value-of select="$var-parent-entity"/>
	<xsl:text>.</xsl:text>
	<xsl:value-of select="$getter-name"/>
    <xsl:text> = null;}&#13;</xsl:text>
 
</xsl:template>


<xsl:template match="association" mode="generate-method-modify">
	<xsl:text>if (_entity.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text> != null)</xsl:text>
       <xsl:text>{_entity.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>.Id = this.IdParent;}</xsl:text>
	<xsl:text>&#13;</xsl:text>
</xsl:template>
	
</xsl:stylesheet>