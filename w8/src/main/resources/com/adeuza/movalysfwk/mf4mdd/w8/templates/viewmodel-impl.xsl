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
<xsl:output method="text" />

<xsl:include href="commons/file-header.xsl" />
<xsl:include href="commons/imports.xsl" />
<xsl:include href="commons/non-generated.xsl"/>
<xsl:include href="commons/replace-all.xsl"/>
	
<xsl:include href="ui/viewmodel/attribute-getter-setter.xsl" />
<xsl:include href="ui/viewmodel/subvm-getter-setter.xsl" />
<xsl:include href="ui/viewmodel/updateFromIdentifiable.xsl"/>
<xsl:include href="ui/viewmodel/clear.xsl"/>
<xsl:include href="ui/viewmodel/modifyToIdentifiable.xsl"/>

<xsl:template match="viewmodel">

	<xsl:apply-templates select="." mode="file-header">
	<xsl:with-param name="fileName"><xsl:value-of select="name" /><xsl:text>.cs</xsl:text></xsl:with-param>
	</xsl:apply-templates>

	<xsl:apply-templates select="." mode="declare-impl-imports" />
	
	<xsl:call-template name="viewmodel-imports" />
			
	<xsl:text>&#13;&#13;</xsl:text>	
			
	<xsl:text>namespace </xsl:text><xsl:value-of select="./package" /><xsl:text>{</xsl:text>
	<xsl:text>&#13;&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Class </xsl:text><xsl:value-of select="./name" /><xsl:text>.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public class </xsl:text><xsl:value-of select="./name" /><xsl:text> : AbstractViewModel&lt;</xsl:text><xsl:value-of select="./name" /><xsl:text>&gt; </xsl:text>
	<xsl:apply-templates select="implements/interface"	mode="generate-implement-interface" />
	<xsl:text>{</xsl:text>
	
	<xsl:text>&#13;&#13;#region Constructor&#13;</xsl:text>

	<!-- Constructor -->
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Constructor.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	<xsl:text>public </xsl:text><xsl:value-of select="./name" /><xsl:text>()</xsl:text><xsl:text>{</xsl:text>
	<xsl:apply-templates select="subvm/viewmodel" mode="subvm-constructor" />
	<xsl:text>_controller.AnalyzeType&lt;</xsl:text><xsl:value-of select="./name" /><xsl:text>&gt;();</xsl:text>
	<xsl:text>PopulateValidation();&#13;</xsl:text>
	<xsl:text>&#13;</xsl:text>

	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">constructor</xsl:with-param>
	<xsl:with-param name="defaultSource">
		<!-- Navigation initialization -->
		<xsl:apply-templates select="navigations/navigation" mode="navigation-constructor" />
	</xsl:with-param>
	</xsl:call-template>

	<xsl:text>}&#13;</xsl:text>
	<!-- End constructor -->


	<xsl:call-template name="generate-populateValidation" />
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;#region Properties&#13;</xsl:text>
	
	<xsl:text>&#13;</xsl:text>	
	
	<xsl:apply-templates select="attribute" mode="generate-attribute-get-and-set" />

	<!-- Génération des propriétés liées à la navigation -->
	<xsl:apply-templates select="navigations/navigation" mode="navigation-properties" />

	<xsl:text>&#13;</xsl:text>	
	<xsl:apply-templates select="subvm/viewmodel" mode="generate-subvm-get-and-set" />
	<xsl:text>&#13;</xsl:text>	
	<xsl:apply-templates select="." mode="generate-combo-attribute"/>
	
	<xsl:if test="type/name='LISTITEM_2'">
		<xsl:text>&#13;private bool _IsSelected;
	    public bool IsSelected
	    {
	        get
	        {
	            return _IsSelected;
	        }
	        set
	        {
	            _IsSelected = value;
	            OnPropertyChanged("IsSelected");
	        }
	    }</xsl:text>
	</xsl:if>
	
	<xsl:if test="type/name='MASTER' and type/is-list='false' and dataloader-impl/dao-interface/dao/class/association[@type='many-to-one']">
		<xsl:text>&#13;private long _idParent;
	    public long IdParent
	    {
	        get
	        {
	            return _idParent;
	        }
	        set
	        {
	            _idParent = value;
	            OnPropertyChanged("IdParent");
	        }
	    }</xsl:text>
	</xsl:if>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">custom-properties</xsl:with-param>
	<xsl:with-param name="defaultSource"/>
	</xsl:call-template>
		
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;#region Methods&#13;</xsl:text>

	<!-- Génération des méthodes liées à la navigation -->
	<xsl:apply-templates select="navigations/navigation" mode="navigation-methods" />
	
	<xsl:apply-templates select="." mode="generate-deepCopy" />
	
	<xsl:call-template name="generate-updateFromViewModel" />
	
	<xsl:if test="dataloader-impl">
		<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
		<xsl:text>public void UpdateFromDataLoader(</xsl:text><xsl:value-of select="dataloader-impl/dataloader-interface/name"/><xsl:text> p_dataloader) {&#13;</xsl:text>
		<xsl:text>if (p_dataloader == null) {
			this.UpdateFromIdentifiable(null);
		} else {
		</xsl:text>
		<xsl:apply-templates select="." mode="add-update-to-dataloader"/>
		<xsl:text>&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">updateFromDataloader-method</xsl:with-param>
			<xsl:with-param name="defaultSource"></xsl:with-param>
		</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
		<xsl:text>this.IsDirty = false;&#13;</xsl:text>
		}&#13;
	</xsl:if>
	
	<xsl:apply-templates select="attribute[@derived='true']" mode="generate-calculate-method"/>
	
	<xsl:choose>
		<xsl:when test="mapping/entity | mapping/attribute">
			<xsl:apply-templates select="mapping" mode="generate-method-clear"/>
		</xsl:when>
		<xsl:when test="subvm/viewmodel">
			<xsl:apply-templates select="subvm" mode="generate-method-clear"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
			<xsl:text>public override void Clear(){&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">clear-after</xsl:with-param>
				<xsl:with-param name="defaultSource"></xsl:with-param>
				</xsl:call-template>
			<xsl:text>&#13;}&#13;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">other-methods</xsl:with-param>
	</xsl:call-template> 
	
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>&#13;#region Internal mapper&#13;</xsl:text>
		
	<xsl:apply-templates select="." mode="updateFromIdentifiable-method"/>
	<xsl:apply-templates select="." mode="modifyToIdentifiable-method"/>
	<xsl:apply-templates select="." mode="defineViewModelName-method"/>
	
	<xsl:apply-templates select="." mode="generate-validate" />
	<xsl:if test="subvm/viewmodel">
		<xsl:apply-templates select="subvm" mode="generate-haserrors" />
	</xsl:if>
	<xsl:text>&#13;#endregion&#13;</xsl:text>
	
	<xsl:text>}&#13;</xsl:text>
	<xsl:text>}&#13;</xsl:text>

</xsl:template>

<!-- general case of the pickerlist -->
<xsl:template match="viewmodel[external-lists/external-list/viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="add-update-to-dataloader">
	<xsl:text>&#13;viewModelCreator.update</xsl:text>
	<xsl:value-of select="./implements/interface/@name"/>
	<xsl:apply-templates select="./external-lists/external-list" mode="update-vmcreator-pickerlist-declaration"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list" mode="update-vmcreator-pickerlist-in-fixedList-declaration"/>
	<xsl:text>(</xsl:text>
	<xsl:text>p_dataloader.GetData()</xsl:text>	
	<xsl:apply-templates select="./external-lists/external-list" mode="update-vmcreator-pickerlist-parameter"/>
	<xsl:apply-templates select="./subvm/viewmodel/external-lists/external-list" mode="update-vmcreator-pickerlist-in-fixedList-parameter"/>
	<xsl:text>);&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="add-update-to-dataloader">
	<xsl:value-of select="dataloader-impl/dataloader-interface/entity-type/name"/>
	<xsl:text> data = p_dataloader.GetData();
     if (data == null) {
     	data = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="dataloader-impl/dataloader-interface/entity-type/name"/><xsl:text>Factory&gt;().CreateInstance();	
      }&#13;</xsl:text>

	<xsl:text>ViewModelCreator viewModelCreator = ClassLoader.GetInstance().GetBean&lt;ViewModelCreator&gt;();&#13;</xsl:text>

	<xsl:value-of select="./implements/interface/@name"/><xsl:text> _vm = </xsl:text>
	<xsl:text>viewModelCreator.update</xsl:text>
    <xsl:value-of select="implements/interface/@name"/>
    <xsl:apply-templates select="./subvm/viewmodel" mode="add-update-to-dataloader-for-fixed-list-declaration"/>
    <xsl:text>(data</xsl:text>
    <xsl:apply-templates select="./subvm/viewmodel" mode="add-update-to-dataloader-for-fixed-list-parameter"/>
    <xsl:text>);</xsl:text>

	<xsl:text>if (_vm != null){&#13;</xsl:text>
	<xsl:apply-templates select="./identifier/attribute|./attribute" mode="generate-updateFromViewModel-attribute"/>
	<xsl:apply-templates select="./subvm/viewmodel" mode="generate-updateFromViewModel-subvm"/>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="generate-updateFromViewModel-external-list"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromViewModel-method</xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;</xsl:text>
	<xsl:text>}</xsl:text>

</xsl:template>


<!-- In case of a pickerlist inside a fixed list -->
<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="add-update-to-dataloader-for-fixed-list-declaration">
	<xsl:apply-templates select="./external-lists/external-list" mode="update-vmcreator-pickerlist-in-fixedList-declaration"/>
</xsl:template>

<!-- In case of a pickerlist inside a fixed list -->
<xsl:template match="viewmodel[type/name='FIXED_LIST']" mode="add-update-to-dataloader-for-fixed-list-parameter">
	<xsl:apply-templates select="./external-lists/external-list" mode="update-vmcreator-pickerlist-in-fixedList-parameter"/>
</xsl:template>

<xsl:template match="viewmodel" mode="add-update-to-dataloader-for-fixed-list-declaration">
</xsl:template>

<xsl:template match="viewmodel" mode="add-update-to-dataloader-for-fixed-list-parameter">
</xsl:template>


<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist-declaration">
	<xsl:text>WithLst</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist-parameter">
	<xsl:text>, p_dataloader</xsl:text>
	<xsl:text>.GetList</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>()</xsl:text>
	
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist-in-fixedList-declaration">
	<xsl:text>WithLst</xsl:text>
	<xsl:value-of select="entity-to-update/name"/>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="update-vmcreator-pickerlist-in-fixedList-parameter">
	<xsl:text>, p_dataloader</xsl:text>
	<xsl:text>.GetList</xsl:text>
	<xsl:value-of select="uml-name"/>
	<xsl:text>()</xsl:text>
</xsl:template>

<xsl:template match="viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="defineViewModelName-method">
	<xsl:apply-templates select="." mode="defineViewModelName-method-for-combo"/>
</xsl:template>

<xsl:template match="viewmodel" mode="defineViewModelName-method">
</xsl:template>

<xsl:template match="viewmodel[linked-interface/name='MFUIBaseListViewModel']" mode="defineViewModelName-method-for-combo">
	<xsl:text>&#13;public String defineViewModelName {&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">defineViewModelName</xsl:with-param>
	<xsl:with-param name="defaultSource">
    	<xsl:text>return "</xsl:text>
    	<xsl:value-of select="name"/>
    	<xsl:text>";&#13;</xsl:text>
    </xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;&#13;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="defineViewModelName-method-for-combo">
</xsl:template>

<xsl:template match="node()" mode="declare-extra-imports">
</xsl:template>
<!-- End cases pickerlist -->


<!-- Generate Validate -->

<xsl:template match="viewmodel[type/name='LISTITEM_1']" mode="generate-validate">
	<xsl:text>&#13;/// &lt;summary&gt;&#13;</xsl:text>
	<xsl:text>/// Validate the viewmodel before save.&#13;</xsl:text>
	<xsl:text>/// &lt;/summary&gt;&#13;</xsl:text>
	 
	<xsl:text>public Boolean validate () {&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">validate</xsl:with-param>
	<xsl:with-param name="defaultSource">
		<xsl:text>Boolean result = true;&#13;</xsl:text>
	    	<xsl:apply-templates select="mapping/attribute" mode="generate-test-variables-validate"/>
	    <xsl:text>return result;&#13;</xsl:text>
       </xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;}&#13;&#13;</xsl:text>
</xsl:template>


<xsl:template match="viewmodel" mode="generate-validate">
</xsl:template>

<xsl:template match="subvm" mode="generate-haserrors">
	<xsl:text>/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override bool HasErrors()&#13;</xsl:text>
    <xsl:text>{&#13;</xsl:text>
    	<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">generate-haserrors-method</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>return base.HasErrors()</xsl:text>
				<xsl:for-each select="viewmodel">
					<xsl:text> | </xsl:text>
					<xsl:value-of select="property-name" />
					<xsl:text>.HasErrors()</xsl:text>
				</xsl:for-each>
				<xsl:text>;&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
    <xsl:text>}&#13;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="generate-test-variables-validate">
	<xsl:text>result = result &amp;&amp; (this.</xsl:text>
	<xsl:variable name="vm-attr">
		<xsl:call-template name="string-uppercase-firstchar">
			<xsl:with-param name="text" select="@vm-attr"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$vm-attr"/><xsl:text> != null);&#13;</xsl:text>
</xsl:template>

<xsl:template match="interface" mode="generate-implement-interface">
	<xsl:text>, </xsl:text>
	<xsl:value-of select="@name" />
</xsl:template>

<xsl:template name="generate-populateValidation">
	<xsl:text>public override void PopulateValidation()</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">populateValidation-method</xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>
	
<xsl:template match="viewmodel" mode="generate-deepCopy">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override IViewModel DeepCopy()</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:value-of select="implements/interface/@name"/><xsl:text> _vm = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>&gt;();</xsl:text>
	<xsl:apply-templates select="./identifier/attribute|./attribute" mode="generate-deepCopy-attribute"/>
	<xsl:apply-templates select="./subvm/viewmodel" mode="generate-deepCopy-subvm"/>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="generate-deepCopy-external-list"/>
	<xsl:text>_vm.WeakMasterViewModel = this.WeakMasterViewModel;</xsl:text>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">deepCopy-method</xsl:with-param>
	</xsl:call-template>
	<xsl:text>return _vm;</xsl:text>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="generate-deepCopy-attribute">
	<xsl:choose>
		<xsl:when test="not(parent::identifier)">
			<xsl:text>_vm.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>.Value</xsl:text>
			<xsl:text> = this.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>.Value;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>_vm.</xsl:text><xsl:value-of select="@name-capitalized"/>
			<xsl:text> = this.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
<xsl:template match="viewmodel" mode="generate-deepCopy-subvm">
	<xsl:choose>
		<xsl:when test="parameters/parameter[@name = 'baseName'] or type/name='LIST_1'">
			<xsl:text>_vm.</xsl:text><xsl:value-of select="property-name"/>
			<xsl:text> = this.</xsl:text><xsl:value-of select="property-name"/><xsl:text>;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="not(parent::identifier) and @enum='false'">
					<xsl:text>_vm.</xsl:text><xsl:value-of select="property-name"/><xsl:text>.Value</xsl:text>
					<xsl:text> = this.</xsl:text><xsl:value-of select="property-name"/><xsl:text>.Value;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>_vm.</xsl:text><xsl:value-of select="property-name"/>
					<xsl:text> = this.</xsl:text><xsl:value-of select="property-name"/><xsl:text>;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

	
<xsl:template match="viewmodel" mode="generate-deepCopy-external-list">
	<xsl:choose>
		<xsl:when test="parameters/parameter[@name = 'baseName']">
			<xsl:text>_vm.Selected</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>Item</xsl:text>
			<xsl:text> = this.Selected</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>Item;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="not(parent::identifier)">
					<xsl:text>_vm.</xsl:text><xsl:value-of select="property-name"/><xsl:text>.Value</xsl:text>
					<xsl:text> = this.</xsl:text><xsl:value-of select="property-name"/><xsl:text>.Value;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>_vm.</xsl:text><xsl:value-of select="property-name"/>
					<xsl:text> = this.</xsl:text><xsl:value-of select="property-name"/><xsl:text>;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="generate-updateFromViewModel">
	<xsl:text>&#13;/// &lt;inheritDoc/&gt;&#13;</xsl:text>
	<xsl:text>public override void UpdateFromViewModel(IViewModel vm)</xsl:text>
	<xsl:text>{&#13;</xsl:text>
	<xsl:value-of select="./implements/interface/@name"/><xsl:text> _vm = vm as </xsl:text><xsl:value-of select="./implements/interface/@name"/><xsl:text>;</xsl:text>
    <xsl:text>if (_vm != null){&#13;</xsl:text>
	<xsl:apply-templates select="./identifier/attribute|./attribute" mode="generate-updateFromViewModel-attribute"/>
	<xsl:apply-templates select="./subvm/viewmodel" mode="generate-updateFromViewModel-subvm"/>
	<xsl:apply-templates select="./external-lists/external-list/viewmodel" mode="generate-updateFromViewModel-external-list"/>
	<xsl:text>&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromViewModel-method</xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#13;</xsl:text>
    <xsl:text>}</xsl:text>
	<xsl:text>this.IsDirty = false;&#13;</xsl:text>
	<xsl:call-template name="non-generated-bloc">
		<xsl:with-param name="blocId">updateFromViewModel-method-after</xsl:with-param>
	</xsl:call-template>
	<xsl:text>}&#13;</xsl:text>
</xsl:template>

<xsl:template match="attribute" mode="generate-updateFromViewModel-attribute">
	<xsl:choose>
		<xsl:when test="not(parent::identifier)">
			<xsl:text>this.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>.Value</xsl:text>
			<xsl:text> = _vm.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>.Value;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>this.</xsl:text><xsl:value-of select="@name-capitalized"/>
			<xsl:text> = _vm.</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="viewmodel" mode="generate-updateFromViewModel-subvm">
	<xsl:text>this.</xsl:text><xsl:value-of select="property-name"/>
	<xsl:text> = _vm.</xsl:text><xsl:value-of select="property-name"/><xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="viewmodel" mode="generate-updateFromViewModel-external-list">
	<xsl:choose>
		<xsl:when test="parameters/parameter[@name = 'baseName']">
			<xsl:text>this.Selected</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>Item</xsl:text>
			<xsl:text> = _vm.Selected</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>Item;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		<xsl:text>this.</xsl:text><xsl:value-of select="property-name"/>
		<xsl:text> = _vm.</xsl:text><xsl:value-of select="property-name"/><xsl:text>;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="attribute" mode="generate-calculate-method">
	<xsl:call-template name="non-generated-bloc">
	<xsl:with-param name="blocId">calculate-method</xsl:with-param>
	<xsl:with-param name="defaultSource">
		<xsl:text>//[MFOnPropertyChange("Champ1.Value", "Champ2.Value")]
		public void Calculate</xsl:text><xsl:value-of select="@name-capitalized"/><xsl:text>()
		{</xsl:text>
	   	//TODO Dev
		<xsl:text>}&#13;</xsl:text>
	</xsl:with-param>
	</xsl:call-template>
</xsl:template>

	<xsl:template match="viewmodel" mode="subvm-constructor">
		<xsl:text>this.</xsl:text><xsl:value-of select="name"/>
		<xsl:text> = ClassLoader.GetInstance().GetBean&lt;</xsl:text><xsl:value-of select="implements/interface/@name"/>
		<xsl:text>&gt;();&#13;</xsl:text>
	</xsl:template>


	<xsl:template match="navigation" mode="navigation-constructor">
		<!-- Property for a button navigation. Generate a command -->
		<xsl:if test="@type='NAVIGATION'">
			<xsl:value-of select="target/vm-name"/>
			<xsl:text>NavigationCommand = new MDKDelegateCommand(Execute</xsl:text>
			<xsl:value-of select="target/vm-name"/>
			<xsl:text>Navigation);&#13;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="navigation" mode="navigation-properties">
		<!-- Property for a button navigation. Generate a command -->
		<xsl:if test="@type='NAVIGATION'">
			<xsl:text>private ICommand vm</xsl:text>
			<xsl:value-of select="target/vm-name"/>
			<xsl:text>NavigationCommand;&#13;</xsl:text>

			<xsl:text>/// &lt;summary&gt;
				/// Command that navigates to</xsl:text>
			<xsl:value-of select="target/vm-name"/>
			<xsl:text>.&#13;/// &lt;/summary&gt;</xsl:text>
			<xsl:text>&#13;public ICommand </xsl:text>
			<xsl:value-of select="target/vm-name"/>
			<xsl:text>NavigationCommand&#13;</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:text>get;&#13;</xsl:text>
			<xsl:text>set;&#13;</xsl:text>
			<xsl:text>}&#13;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="navigation" mode="navigation-methods">
		<!-- Property for a button navigation. Generate a command -->
		<xsl:if test="@type='NAVIGATION'">
			<xsl:text>&#13;public void Execute</xsl:text>
			<xsl:value-of select="target/vm-name"/>
			<xsl:text>Navigation(Object parameter)&#13;</xsl:text>
			<xsl:text>{&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">Execute<xsl:value-of select="target/vm-name"/>Navigation-method</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>IMDKNavigationService navigationService = ClassLoader.GetInstance().GetBean&lt;IMDKNavigationService&gt;();&#13;</xsl:text>
					<xsl:text>navigationService.Navigate("</xsl:text>
					<xsl:value-of select="target/name"/>
					<xsl:text>Controller");&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>}&#13;</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>