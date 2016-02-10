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

<xsl:template match="class">
<xsl:text>package </xsl:text><xsl:value-of select="package"/>;

import java.io.Serializable;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOListImpl;
import java.util.List;
import java.util.Map;
<xsl:if test="//*[(name()= 'association' and  (@type='one-to-many' or @type='many-to-many'))]">import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOList;</xsl:if>
<xsl:for-each select="import">
<xsl:sort select="."/>
<xsl:text>import </xsl:text><xsl:value-of select="."/><xsl:text> ;
</xsl:text>
</xsl:for-each>

import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.annotations.RelationInverse ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.AbstractBOPersistableEntity;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CascadeSet ;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CloneException;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.CloneSession;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.MergeException;
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.references.Reference;
<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) > 0">	
import com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.loadmethod.LoadMethod;
</xsl:if>

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

//@non-generated-start[imports]
<xsl:value-of select="non-generated/bloc[@id='imports']"/>
<xsl:text>//@non-generated-end</xsl:text>

/**
 * <xsl:value-of select="documentation"/>
 *
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Copyright (c) 2010</p>]]></xsl:text>
 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>Company: Adeuza</p>]]></xsl:text>
 *
 */
@SuppressWarnings("serial")	
public class <xsl:value-of select="name"/> extends AbstractBOPersistableEntity<xsl:text>&lt;</xsl:text><xsl:value-of select="implements/interface/@name"/><xsl:text>&gt;</xsl:text>
<!-- xsl:if test="count(implements/interface) != 0"-->
<xsl:text> implements </xsl:text>
<xsl:for-each select="implements/interface">
<xsl:value-of select="@name"/>
<xsl:text>, </xsl:text>
</xsl:for-each><!-- /xsl:if-->Serializable, Cloneable {
	
	<xsl:for-each select="//*[((name() = 'attribute' and @derived = 'false') or name()= 'association') and not(ancestor::association)]">
	
	/**
	 * <xsl:value-of select="documentation/doc-attribute"/>
	 * <xsl:if test="name()= 'attribute'"><xsl:variable name="name" select="field/@name"/>	
	 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Attribute <xsl:value-of select="$name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
 	 *<xsl:text> </xsl:text>
	 	<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> type=</xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:text> mandatory=</xsl:text>
		<xsl:value-of select="@nullable = 'false'"/>
		<xsl:if test="@unique and @unique='true'">
			<xsl:text> unique=</xsl:text>
			<xsl:value-of select="@unique and @unique='true'"/>
		</xsl:if>
		<xsl:if test="@unique-key">			
			<xsl:variable name="unique-key" select="@unique-key"/>
			<xsl:text> unique-key=true</xsl:text>
			<xsl:text> unique-key-name=</xsl:text><xsl:value-of select="@unique-key"/>
			<xsl:text> unique-key-relation=</xsl:text>
			
			<xsl:for-each select="//pojo/class/identifier/attribute[@unique-key=$unique-key and field/@name!=$name] | //pojo/class/attribute[@unique-key=$unique-key and field/@name!=$name]">
				<xsl:value-of select="field/@name"/>
				<xsl:if test="position() != last()">
					<xsl:text>,</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	</xsl:if>
	<xsl:if test="name()= 'association'">
	 * <xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>Cascade <xsl:value-of select="@cascade-name"/><xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	 *<xsl:text> </xsl:text>
		 <!-- type de relation -->
		<xsl:if test="@type = 'many-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'one-to-one'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation OneToOne</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<xsl:if test="@type = 'many-to-many'">
			<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
			<xsl:text>Relation ManyToMany</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
		</xsl:if>
		<!-- objet cible -->
		<xsl:text disable-output-escaping="yes"><![CDATA[<p>]]></xsl:text>
		<xsl:text> targetEntity=</xsl:text>
		<xsl:value-of select="interface/name"/>
		<!-- obligatoire -->
		<xsl:if test="@type = 'many-to-one' or @type = 'one-to-one'">
			<xsl:text> mandatory=</xsl:text>
			<xsl:value-of select="@optional != 'true'"/>
		</xsl:if>
		<!-- proprietaire de la relation -->
		<xsl:text> relationOwner=</xsl:text>
		<xsl:value-of select="@relation-owner"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[</p>]]></xsl:text>
	</xsl:if>
	 */
	<xsl:if test="name()= 'association'">
		<xsl:text>@RelationInverse(name="</xsl:text><xsl:value-of select="@opposite-name"/><xsl:text>")
		</xsl:text>
	</xsl:if>
	<xsl:value-of select="@visibility"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@type-short-name"/>
		<xsl:if test="@contained-type-short-name">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="@contained-type-short-name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@name"/> ;
		
	</xsl:for-each>
	
//@non-generated-start[attributes]
<xsl:value-of select="non-generated/bloc[@id='attributes']"/>
<xsl:text>//@non-generated-end</xsl:text>
		
		
	<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) > 0">	
	/**
	 *  Méthode de chargement
	 */
	private LoadMethod&lt;<xsl:value-of select="implements/interface/@name"/>&gt; loadMethod = LoadMethod<xsl:value-of select="implements/interface/@name"/>.BY_ID;
	</xsl:if>
	
	/**
	 * Constructor <xsl:for-each select="javadoc">
 	 * <xsl:value-of select="."/>
	</xsl:for-each>
	 */
	protected <xsl:value-of select="name"/>() {
	
		//@me plop
		<xsl:for-each select="descendant::attribute[not(ancestor::association)  and @derived = 'false']">
			<xsl:choose>
				<!-- gestion du null sur l'objet Long -->
				<xsl:when test="(@type-short-name='Long' and @init='null')">
					<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = 0L ;&#13;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>// </xsl:text><xsl:value-of select="@type-short-name"/>  <xsl:value-of select="@init"/><xsl:text>&#13;</xsl:text>
					<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = </xsl:text><xsl:value-of select="@init"/><xsl:text>;&#13;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="//association[not(parent::association)]">
			<xsl:text>this.</xsl:text><xsl:value-of select="@name"/><xsl:text> = null ;&#13;</xsl:text>
		</xsl:for-each>
			
//@non-generated-start[constructor]
<xsl:value-of select="non-generated/bloc[@id='constructor']"/>
<xsl:text>//@non-generated-end</xsl:text>
	}
	
	<xsl:for-each select="//*[(name() = 'attribute' or name()= 'association') and not(parent::association)]">
	/** 
	 * {@inheritDoc}
	 * 
<xsl:if test="../implements">	 * @see <xsl:value-of select="../implements/interface/@full-name"/>#<xsl:value-of select="get-accessor"/>()</xsl:if>
<xsl:if test="../../implements">	 * @see <xsl:value-of select="../../implements/interface/@full-name"/>#<xsl:value-of select="get-accessor"/>()</xsl:if>
	 */
	@Override
	public<xsl:text> </xsl:text>
					<xsl:value-of select="@type-short-name"/>
		<xsl:if test="@contained-type-short-name">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="@contained-type-short-name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text><xsl:value-of select="get-accessor"/>() {
		<xsl:if test="@derived = 'false' or name() = 'association'">
		return this.<xsl:value-of select="@name"/> ;
		</xsl:if>
		<xsl:if test="@derived = 'true' and name() = 'attribute'">
<xsl:variable name="derivedGetter"><xsl:value-of select="@name"/><xsl:text>-getter</xsl:text></xsl:variable>
//@non-generated-start[<xsl:value-of select="$derivedGetter"/>]
<xsl:value-of select="/class/non-generated/bloc[@id=$derivedGetter]"/>
<xsl:text>//@non-generated-end</xsl:text>
		return <xsl:value-of select="@init"/> ;
		</xsl:if>
	}

	/**
	 * {@inheritDoc}
	 * 
<xsl:if test="../implements">	 * @see <xsl:value-of select="../implements/interface/@full-name"/>#<xsl:value-of select="set-accessor"/></xsl:if>
<xsl:if test="../../implements">	 * @see <xsl:value-of select="../../implements/interface/@full-name"/>#<xsl:value-of select="set-accessor"/></xsl:if>
	 <xsl:text>(</xsl:text><xsl:value-of select="@type-name"/><xsl:text>)</xsl:text>
<xsl:if test="(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)">
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.AbstractBOEntity#setList(BOList,BOList)</xsl:if>
	 */
	@Override
	<xsl:text>public void </xsl:text>
	<xsl:value-of select="set-accessor"/>( <xsl:value-of select="@type-short-name"/>
		<xsl:if test="@contained-type-short-name">
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="@contained-type-short-name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of  select="parameter-name"/> ) {
		<xsl:if test="(name() = 'attribute' and not(parent::association) and @derived = 'false') or (name()= 'association' and  (@type='many-to-one' or @type='one-to-one') and not(parent::association))">
			<xsl:if test="name()= 'attribute'">this.onSetterAttribute(<xsl:value-of select="//implements/interface/@name"/>.ATTRIBUTES.<xsl:value-of select="@name-uppercase"/>);</xsl:if>
			<xsl:if test="name()= 'association'">this.onSetter(<xsl:value-of select="//implements/interface/@name"/>.ATTRIBUTES.<xsl:value-of select="@cascade-name"/>, this.<xsl:value-of select="@name"/>, <xsl:value-of select="parameter-name"/> );</xsl:if>
			this.<xsl:value-of select="@name"/> = <xsl:value-of select="parameter-name"/>;
		</xsl:if>
		<xsl:if test="name() = 'attribute' and not(parent::association) and @derived = 'true'">
<xsl:variable name="derivedGetter"><xsl:value-of select="@name"/><xsl:text>-setter</xsl:text></xsl:variable>
//@non-generated-start[<xsl:value-of select="$derivedGetter"/>]
<xsl:value-of select="/class/non-generated/bloc[@id=$derivedGetter]"/>
<xsl:text>//@non-generated-end</xsl:text>
		</xsl:if>
		<xsl:if test="(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)">
		this.<xsl:value-of select="@name"/> = this.setList(this.<xsl:value-of select="@name"/>,<xsl:value-of select="parameter-name"/>);</xsl:if>
	}
	</xsl:for-each>
	
	/**
	 * {@inheritDoc}
	 * 
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEntity#idToString()
	 */
	public String idToString() {
		StringBuilder r_sId = new StringBuilder();
		<xsl:for-each select="identifier/descendant::attribute">
			<xsl:if test="parent::identifier">
				<xsl:text>r_sId.append( String.valueOf( this.</xsl:text>
				<xsl:value-of select="@name"/><xsl:text>));
				</xsl:text>
			</xsl:if>
			<xsl:if test="parent::association">
				<xsl:text>r_sId.append( String.valueOf( this.</xsl:text><xsl:value-of select="../@name"/>
				<xsl:text>.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>()));
				</xsl:text>
			</xsl:if>
			<xsl:if test="position() != last()">
				<xsl:text>r_sId.append('|');
				</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>return r_sId.toString();</xsl:text>
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEntity#startRecordChanges(CascadeSet)
	 */
	@Override
	public void startRecordChanges(CascadeSet p_oCascadeSet) {
		super.startRecordChanges(p_oCascadeSet);<xsl:for-each select="//*[(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)]">
		if(this.<xsl:value-of select="@name"/>!=null){
			this.<xsl:value-of select="@name"/>.startRecordChanges();
			if(p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
				for (<xsl:value-of select="./interface/name"/> o<xsl:value-of select="./interface/name"/> : this.<xsl:value-of select="@name"/>){
					o<xsl:value-of select="./interface/name"/>.startRecordChanges();
				}
			}
		}</xsl:for-each>
	}

	<xsl:if test="@join-class = 'true'">
	/**
	 * Renvoie l'identifiant de l'attribut <xsl:value-of select="left-association/name-for-join-class"/> au format chaîne de caractères.
	 *
	 * @return l'identifiant de l'attribut <xsl:value-of select="left-association/name-for-join-class"/> au format chaîne de caractères.
	 */
	 public String <xsl:value-of select="left-association/name-for-join-class"/>IdToString() {
	 	StringBuffer r_sId = new StringBuffer();
	 	<xsl:for-each select="left-association/attr">
	 		<xsl:text>r_sId.append( String.valueOf( this.</xsl:text>
	 		<xsl:value-of select="@name"/>
	 		<xsl:text>));</xsl:text>
	 		<xsl:if test="position() != last()">
			<xsl:text>r_sId.append('|');
			</xsl:text>
			</xsl:if>
	 	</xsl:for-each>
	 	return r_sId.toString();
	 }
	 
	/**
	 * Renvoie l'identifiant de l'attribut <xsl:value-of select="right-association/name-for-join-class"/> au format chaîne de caractères.
	 *
	 * @return l'identifiant de l'attribut <xsl:value-of select="right-association/name-for-join-class"/> au format chaîne de caractères.
	 */
	 public String <xsl:value-of select="right-association/name-for-join-class"/>IdToString() {
	 	StringBuffer r_sId = new StringBuffer();
	 	<xsl:for-each select="right-association/attr">
	 		<xsl:text>r_sId.append( String.valueOf( this.</xsl:text>
	 		<xsl:value-of select="@name"/>
	 		<xsl:text>));</xsl:text>
	 		<xsl:if test="position() != last()">
			<xsl:text>r_sId.append('|');
			</xsl:text>
			</xsl:if>
	 	</xsl:for-each>
	 	return r_sId.toString();
	 }
	</xsl:if>
	
	/**
	 * {@inheritDoc}
	 * 
	 * @see <xsl:value-of select="implements/interface/@full-name"/>#clone(CascadeSet,CloneSession)
	 */
	public <xsl:value-of select="implements/interface/@name"/> clone(CascadeSet p_oCascadeSet, CloneSession p_oCloneSession) throws CloneException {
		<xsl:value-of select="implements/interface/@name"/> r_o<xsl:value-of select="implements/interface/@name"/> = (<xsl:value-of select="implements/interface/@name"/>) p_oCloneSession.getFromCache(<xsl:value-of select="implements/interface/@name"/>.ENTITY_NAME, this.idToString());
		if(r_o<xsl:value-of select="implements/interface/@name"/> == null){
			try {
				r_o<xsl:value-of select="//implements/interface/@name"/> = this.getClass().newInstance();
				p_oCloneSession.addToCache(<xsl:value-of select="//implements/interface/@name"/>.ENTITY_NAME, this.idToString(), r_o<xsl:value-of select="implements/interface/@name"/>);
				<xsl:for-each select="//*[(name() = 'attribute' and not(parent::association))]">
					<xsl:if test="./@type-short-name!='Timestamp'">
						<xsl:text>r_o</xsl:text><xsl:value-of select="//implements/interface/@name"/>
						<xsl:text>.</xsl:text><xsl:value-of select="set-accessor"/>
						<xsl:text>(</xsl:text>
						<xsl:if test="@derived = 'false'">
							<xsl:text>this.</xsl:text><xsl:value-of select="@name"/>
						</xsl:if>
						<xsl:if test="@derived = 'true'">
							<xsl:text>this.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>()</xsl:text>
						</xsl:if>						
						<xsl:text>);&#13;</xsl:text>
					</xsl:if>
					<xsl:if test="./@type-short-name='Timestamp'">
						if(this.<xsl:value-of select="./get-accessor"/>()!=null){
							r_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="set-accessor"/>((Timestamp)this.<xsl:value-of select="@name"/>.clone());
						}
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="count(identifier/descendant::attribute) = 1">
				/*DISABLED IN BACKPORT
				if (!p_oCascadeSet.contains(CascadeSet.GenericCascade.NOT_ALL_DYN) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.NOT_DYN)){
					r_o<xsl:value-of select="//implements/interface/@name"/>.setMapDynamicalField(this.getMapDynamicalField().clone());
				}
				*/
				</xsl:if>
				
				<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) > 0">
				r_o<xsl:value-of select="//implements/interface/@name"/>.setLoadMethod(this.getLoadMethod());
				</xsl:if>
				
				<xsl:for-each select="//*[(name()= 'association' and  (@type='many-to-one' or @type='one-to-one') and not(parent::association))]">
				if(this.<xsl:value-of select="@name"/>!=null){
					if (p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
						r_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="set-accessor"/>((<xsl:value-of select="@type-short-name"/>)this.<xsl:value-of select="@name"/>.clone(p_oCascadeSet,p_oCloneSession));
					}else {
						<xsl:value-of select="@type-short-name"/> o<xsl:value-of select="@type-short-name"/> = (<xsl:value-of select="@type-short-name"/>) p_oCloneSession.getFromCache(<xsl:value-of select="@type-short-name"/>.ENTITY_NAME, this.<xsl:value-of select="@name"/>.idToString());
						if(o<xsl:value-of select="@type-short-name"/>==null){
							o<xsl:value-of select="@type-short-name"/> = this.<xsl:value-of select="@name"/>;
						}
						r_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="set-accessor"/>(o<xsl:value-of select="@type-short-name"/>);
					}
				}
				</xsl:for-each>
				<xsl:for-each select="//*[(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)]">
				if (p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>)) {
					if(this.<xsl:value-of select="@name"/>!=null){
						r_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="set-accessor"/>(this.<xsl:value-of select="@name"/>.clone(p_oCascadeSet, p_oCloneSession));
					}
				}</xsl:for-each>
				
				if ( p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL_REFERENCES)
					|| p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL )
					|| p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.REFERENCES)) {
					for( Reference oReference : this.getReferences()) {
						r_o<xsl:value-of select="//implements/interface/@name"/>.addReference(oReference.clone());
					}
				}				
				
				//@non-generated-start[clone]
<xsl:value-of select="non-generated/bloc[@id='clone']"/>
<xsl:text>//@non-generated-end</xsl:text>
			} catch (InstantiationException e) {
				throw new CloneException(e);
			} catch (IllegalAccessException e) {
				throw new CloneException(e);
			}
		}
		((AbstractBOPersistableEntity&lt;<xsl:value-of select="implements/interface/@name"/>&gt;)r_o<xsl:value-of select="implements/interface/@name"/>).setUpdatedAttributes( this.getUpdatedAttributes());
		if ( this.isRecordChanges() ) {
			r_o<xsl:value-of select="implements/interface/@name"/>.startRecordChanges();
		}
		return r_o<xsl:value-of select="implements/interface/@name"/>;
	}
	
	/**
	 * {@inheritDoc}
	 * 
	 * com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEntity#privateMergeWith(com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.MEntity)
	 */
	@Override
	public void mergeWith(<xsl:value-of select="implements/interface/@name"/> p_o<xsl:value-of select="implements/interface/@name"/>, CascadeSet p_oCascadeSet) throws MergeException {<xsl:for-each select="//*[(name() = 'attribute' and not(parent::association))]">
		if(p_o<xsl:value-of select="//implements/interface/@name"/>.isAttributeUpdated(<xsl:value-of select="//implements/interface/@name"/>.ATTRIBUTES.<xsl:value-of select="@name-uppercase"/>)){
			this.<xsl:value-of select="set-accessor"/>(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>());
		}</xsl:for-each><xsl:if test="count(identifier/descendant::attribute) = 1">
		/*DISABLED IN BACKPORT
		if (!p_oCascadeSet.contains(CascadeSet.GenericCascade.NOT_ALL_DYN) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.NOT_DYN)){
			this.setMapDynamicalField(p_o<xsl:value-of select="//implements/interface/@name"/>.getMapDynamicalField());
		}
		*/
		</xsl:if>
		if (p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL_REFERENCES)
			|| p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL )
			|| p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.REFERENCES)) {
			for( Reference oReference : p_o<xsl:value-of select="//implements/interface/@name"/>.getReferences()) {
				this.addReference(oReference);
			}
		}
		<xsl:for-each select="//*[(name()= 'association' and  (@type='many-to-one' or @type='one-to-one') and not(parent::association))]">
		// #1 Détection écrasement
		if (p_o<xsl:value-of select="//implements/interface/@name"/>.isAttributeUpdated(<xsl:value-of select="//implements/interface/@name"/>.ATTRIBUTES.<xsl:value-of select="@cascade-name"/>)) {
			if (this.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> this.<xsl:value-of select="get-accessor"/>().equals(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>()) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text>
				(p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>))){
				// #1.1 Object identiques (même ID) et Cascade : on remplace par un mergeWith
				this.<xsl:value-of select="get-accessor"/>().mergeWith(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>(),p_oCascadeSet);
			} else if(this.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> this.<xsl:value-of select="get-accessor"/>().equals(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>()) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text>
				!(p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>))) {
				// #1.2 Object identiques (même ID) et non Cascade : Rien
			} else {
				// #1.3 Objets différents
				this.<xsl:value-of select="set-accessor"/>(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>());
			}
		// #2 mergeWith demandé avec cascades (sur objets non-null)
		} else {
			if(this.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> this.<xsl:value-of select="get-accessor"/>().equals(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>()) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text>
				(p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>))){
				// #2.1 Object identiques (même ID) et Cascade : on remplace par un mergeWith
				this.<xsl:value-of select="get-accessor"/>().mergeWith(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>(),p_oCascadeSet);
			} else if(this.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> !this.<xsl:value-of select="get-accessor"/>().equals(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>()) <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text>
				(p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>))) {
				// #2.2 Object non Identiques (ID différent) et Cascade : MergeException
				throw new MergeException("Cas incohérent : vous demandez un merge pour une relation to-one sur des objets d'id différents (cascade <xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>) ");
			} // else #2.3 Non Cascade Rien
		}</xsl:for-each><xsl:for-each select="//*[(name()= 'association' and  (@type='one-to-many' or @type='many-to-many')) and not(parent::association)]">
		if (this.<xsl:value-of select="get-accessor"/>()!=null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>()!=null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> (p_oCascadeSet.contains(CascadeSet.GenericCascade.ALL) || p_oCascadeSet.contains(<xsl:value-of select="//implements/interface/@name"/>.Cascade.<xsl:value-of select="@cascade-name"/>))) {
			this.<xsl:value-of select="set-accessor"/>(p_o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>());
		}</xsl:for-each>
		//@non-generated-start[mergeWith]
<xsl:value-of select="non-generated/bloc[@id='mergeWith']"/>
<xsl:text>//@non-generated-end</xsl:text>
	}
	
	/**
	 * {@inheritDoc}
	 * 
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEntity#equalsFull(java.lang.Object)
	 */
	@Override
	public boolean equalsFull(Object p_oObject) {
		boolean r_bEquals = true;
		if (this != p_oObject) {
			if (p_oObject instanceof <xsl:value-of select="implements/interface/@name"/>) {
				<xsl:value-of select="implements/interface/@name"/> o<xsl:value-of select="implements/interface/@name"/> = (<xsl:value-of select="implements/interface/@name"/>
				<xsl:text>) p_oObject;&#13;</xsl:text>
				<xsl:text>EqualsBuilder oEqualsBuilder = new EqualsBuilder();&#13;</xsl:text>
				<xsl:for-each select="//*[(name() = 'attribute' and not(parent::association))]">
					<xsl:text>oEqualsBuilder.append(</xsl:text>
					<xsl:if test="@derived = 'false'">
						<xsl:text>this.</xsl:text><xsl:value-of select="@name"/>
					</xsl:if>
					<xsl:if test="@derived = 'true'">
						<xsl:text>this.</xsl:text><xsl:value-of select="get-accessor"/><xsl:text>()</xsl:text>
					</xsl:if>						
					<xsl:text>,o</xsl:text>
					<xsl:value-of select="//implements/interface/@name"/>
					<xsl:text>.</xsl:text>
					<xsl:value-of select="get-accessor"/>
					<xsl:text>());&#13;</xsl:text>
				</xsl:for-each>
				boolean bAreAssociationsValide = true;
				<xsl:if test="count(identifier/descendant::attribute) = 1">
				/*DISABLED IN BACKPORT
				<xsl:text>oEqualsBuilder.append(this.getMapDynamicalField(),o</xsl:text>
				<xsl:value-of select="//implements/interface/@name"/>
				<xsl:text>.getMapDynamicalField());</xsl:text>
				*/
				</xsl:if>
				<xsl:for-each select="//*[(name()= 'association' and  (@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')) and not(parent::association))]">
				if (bAreAssociationsValide) {
					if (this.<xsl:value-of select="@name"/>!=null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null){<xsl:for-each select="attribute">
						oEqualsBuilder.append(this.<xsl:value-of select="../@name"/>.<xsl:value-of select="get-accessor"/>(),o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="../get-accessor"/>().<xsl:value-of select="get-accessor"/>());</xsl:for-each><xsl:if test="not(@optional='true')">
					} else {
						throw new IllegalStateException("L'entité n'est pas valide. L'association '<xsl:value-of select="@name"/>' doit être valuée.");
					}</xsl:if><xsl:if test="@optional='true'">
					} else if ((this.<xsl:value-of select="@name"/>!=null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() == null)
								|| (this.<xsl:value-of select="@name"/>==null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null)){
						bAreAssociationsValide = false;
					}</xsl:if>
				}</xsl:for-each>
				//@non-generated-start[equals]
<xsl:value-of select="non-generated/bloc[@id='equals']"/>
<xsl:text>//@non-generated-end</xsl:text>
				if (bAreAssociationsValide) {
					r_bEquals = oEqualsBuilder.isEquals();
				} else{
					r_bEquals = false;
				}
			} else {
				r_bEquals = false;
			}
		}
		return r_bEquals;
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object p_oObject) {
		boolean r_bEquals = true;
		if (this != p_oObject) {
			if (p_oObject instanceof <xsl:value-of select="implements/interface/@name"/>) {
				<xsl:value-of select="implements/interface/@name"/> o<xsl:value-of select="implements/interface/@name"/> = (<xsl:value-of select="implements/interface/@name"/>) p_oObject;
				<xsl:text>EqualsBuilder oEqualsBuilder = new EqualsBuilder();</xsl:text>
				//@non-generated-start[equals-startbuild]
<xsl:value-of select="non-generated/bloc[@id='equals-startbuild']"/>
<xsl:text>//@non-generated-end</xsl:text>


				<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) = 0">
				<xsl:for-each select="identifier/attribute">
					oEqualsBuilder.append(this.<xsl:value-of select="@name"/>,o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>
					<xsl:text>());</xsl:text>
				</xsl:for-each>
				<xsl:for-each select="identifier/association">
					if(this.<xsl:value-of select="@name"/>!=null <xsl:text disable-output-escaping="yes"><![CDATA[&&]]></xsl:text> o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="get-accessor"/>() != null){<xsl:for-each select="attribute">
						oEqualsBuilder.append(this.<xsl:value-of select="../@name"/>.<xsl:value-of select="get-accessor"/>(),o<xsl:value-of select="//implements/interface/@name"/>.<xsl:value-of select="../get-accessor"/>().<xsl:value-of select="get-accessor"/>());</xsl:for-each><xsl:if test="not(@optional='true')">
					} else {
						throw new IllegalStateException("L'entité n'est pas valide. L'association '<xsl:value-of select="@name"/>' doit être valuée.");
					}
					</xsl:if>
					<xsl:if test="@optional='true'">
					} else {
						throw new IllegalStateException("La génération n'est pas correcte. Veuillez contacter le service client.");
					}
					</xsl:if>
				</xsl:for-each>
				</xsl:if>
				
				<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) > 0">
					oEqualsBuilder.append(true,this.getLoadMethod().getHelper().equals(this,o<xsl:value-of select="implements/interface/@name"/>
					<xsl:text>));</xsl:text>
				</xsl:if>
				
				//@non-generated-start[equals-endbuild]
<xsl:value-of select="non-generated/bloc[@id='equals-endbuild']"/>
<xsl:text>//@non-generated-end</xsl:text>				
				r_bEquals = oEqualsBuilder.isEquals();
			} else {
				r_bEquals = false;
			}
		}
		return r_bEquals;
	}

<!-- 	
	/**
	 * {@inheritDoc}
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		HashCodeBuilder oHashCodeBuilder = new HashCodeBuilder();<xsl:for-each select="//*[(name() = 'attribute' and not(parent::association))]">
		oHashCodeBuilder.append(this.<xsl:value-of select="@name"/>);</xsl:for-each>
		<xsl:if test="count(identifier/descendant::attribute) = 1">
		/*DISABLED IN BACKPORT
		<xsl:text>oHashCodeBuilder.append(this.getMapDynamicalField().hashCode());</xsl:text>
		*/
		</xsl:if>
		<xsl:for-each select="//*[(name()= 'association' and  (@type='many-to-one' or (@type='one-to-one' and @relation-owner='true')) and not(parent::association))]">
		if (this.<xsl:value-of select="@name"/><xsl:text>!=null) {</xsl:text>
			<xsl:for-each select="attribute">
			oHashCodeBuilder.append(this.<xsl:value-of select="../@name"/>.<xsl:value-of select="get-accessor"/><xsl:text>());</xsl:text>
			</xsl:for-each>
		} else {
			oHashCodeBuilder.append(-1);
		}</xsl:for-each>
		//@non-generated-start[hashCode]
<xsl:value-of select="non-generated/bloc[@id='hashCode']"/>
<xsl:text>//@non-generated-end</xsl:text>
		return oHashCodeBuilder.toHashCode();
	}
 -->
 
	/**
	 * {@inheritDoc}
	 * 
	 * @see com.adeuza.movalysfwk.backoffice.mf4bjclassic.core.beans.BOEntity#hashCodeByKey()
	 */
	@Override
	public int hashCode() {
		HashCodeBuilder oHashCodeBuilder = new HashCodeBuilder();
		//@non-generated-start[hashCodeByKey-startbuild]
<xsl:value-of select="non-generated/bloc[@id='hashCodeByKey-startbuild']"/>
<xsl:text>//@non-generated-end</xsl:text>		
		<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) = 0">
		<xsl:for-each select="identifier/attribute">
			oHashCodeBuilder.append(this.<xsl:value-of select="@name"/>
			<xsl:text>);</xsl:text>
		</xsl:for-each>
		<xsl:for-each select="identifier/association">
		if (this.<xsl:value-of select="@name"/>!=null) {<xsl:for-each select="attribute">
			oHashCodeBuilder.append(this.<xsl:value-of select="../@name"/>.<xsl:value-of select="get-accessor"/>());</xsl:for-each>
		} else {
			oHashCodeBuilder.append(-1);
		}</xsl:for-each>
		</xsl:if>
		
		<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) > 0">
		this.getLoadMethod().getHelper().hashCode(this, oHashCodeBuilder);
		</xsl:if>
		
		//@non-generated-start[hashCodeByKey-endbuild]
<xsl:value-of select="non-generated/bloc[@id='hashCodeByKey-endbuild']"/>
<xsl:text>//@non-generated-end</xsl:text>
		return oHashCodeBuilder.toHashCode();
	}

	<xsl:if test="count( implements/interface/linked-interfaces/linked-interface[name = 'MethodLoadable'] ) > 0">	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public LoadMethod&lt;<xsl:value-of select="implements/interface/@name"/>&gt; getLoadMethod() {
		return this.loadMethod;
	}
	
	/**
	 * Affecte l'objet loadMethod 
	 * @param p_oLoadMethod Objet loadMethod
	 */
	@Override
	public void setLoadMethod(LoadMethod&lt;<xsl:value-of select="implements/interface/@name"/>&gt; p_oLoadMethod) {
		this.loadMethod = p_oLoadMethod;
	}
	</xsl:if>

	<xsl:apply-templates select="implements/interface/linked-interfaces/linked-interface[name = 'MAdmAble']"/>

//@non-generated-start[methods]
<xsl:value-of select="non-generated/bloc[@id='methods']"/>
<xsl:text>//@non-generated-end</xsl:text>
}
	
</xsl:template>

<!--
	Méthodes des objets implémentants l'interface MAdmAble et qui n'apparaissent pas dans le modèle. 
 -->
<xsl:template match="linked-interface[name = 'MAdmAble']">
	/**
	 * Returns &lt;code&gt;true&lt;/code&gt; if the current object is living. &lt;code&gt;false&lt;/code&gt; otherwise.
	 * @return &lt;code&gt;true&lt;/code&gt; if the current object is living. &lt;code&gt;false&lt;/code&gt; otherwise.
	 */
	@Override
	public boolean isLiving() {
		return MLiving.LIVING.equals(this.admLivingRecord);
	}

	/**
	 * Returns &lt;code&gt;true&lt;/code&gt; if the current object is dead. &lt;code&gt;false&lt;/code&gt; otherwise.
	 * @return &lt;code&gt;true&lt;/code&gt; if the current object is dead. &lt;code&gt;false&lt;/code&gt; otherwise.
	 */
	@Override
	public boolean isDead() {
		return MLiving.DEAD.equals(this.admLivingRecord);
	}
</xsl:template>

<xsl:template name="mappedBy">
	<xsl:if test="@relation-owner='false'">
		<xsl:text>,mappedBy="</xsl:text>
		<xsl:value-of select="@mapped-by"/>
		<xsl:text>"</xsl:text>
	</xsl:if>
</xsl:template>

<!-- 




 -->

</xsl:stylesheet>