/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.xmodele;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.dom4j.Element;

import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.SInterface;

/**
 * DataLoader interface model
 */
public class MDataLoaderInterface extends SInterface {

	/**
	 * Data loader type
	 */
	private MDataLoaderType type ;
	
	/**
	 * Entity type managed by the loader
	 */
	private MEntityImpl entity = null;
	
	/**
	 * Synchronizable
	 */
	private boolean synchronizable = false ;
	
	/**
	 * Drop down lists
	 */
	private List<MDataLoaderCombo> combos = new ArrayList<MDataLoaderCombo>();
	
	/**
	 * @param p_sType
	 * @param p_sUmlName
	 * @param p_sName
	 * @param p_oPackage
	 */
	public MDataLoaderInterface( String p_sUmlName, String p_sName, MPackage p_oPackage) {
		super("dataloader-interface", p_sUmlName, p_sName, p_oPackage);
	}
	
	/**
	 * Ajoute une nouvelle combo.
	 * @param p_oCombo objet de type <code>MDataLoaderCombo</code>.
	 */
	public void addCombo(MDataLoaderCombo p_oCombo){
		if (!combos.contains(p_oCombo)){
			combos.add(p_oCombo);
		}
	}
	
	/**
	 * Return true if the combo already exist in the combo list of this current <code>DataLoader</code>.
	 * @param p_oCombo the combo to text
	 * @return true if the combo list of the current DataLoader contains the combo in parameter, false otherwise. 
	 */
	public boolean containsCombo(MDataLoaderCombo p_oCombo){
		return getCombo(p_oCombo.getEntityDao(), p_oCombo.getEntityViewModel()) != null;
	}
	
	/**
	 * Return true if a combo contains in the list has already the same configuration send as parameter.
	 * @param p_oDao the combo dao to test
	 * @param p_oVm the combo ViewModel to test 
	 * @return true if a combo contains in the list has already the same configuration send as parameter, false otherwise. 
	 */
	public MDataLoaderCombo getCombo(MDaoInterface p_oDao, MViewModelImpl p_oVm){
		for (MDataLoaderCombo oTempCombo : combos){
			if (p_oDao.equals(oTempCombo.getEntityDao())
					&& p_oVm.equals(oTempCombo.getEntityViewModel())) {
				return oTempCombo;
			}
		}
		return null;
	}
	
	/**
	 * @return
	 */
	public MDataLoaderType getType() {
		return type;
	}

	/**
	 * @param p_oType
	 */
	public void setType(MDataLoaderType p_oType) {
		this.type = p_oType;
	}

	/**
	 * @return
	 */
	public MEntityImpl getEntity() {
		return this.entity;
	}

	/**
	 * @param p_oEntityTypeDesc
	 */
	public void setEntity(MEntityImpl p_oEntity) {
		this.entity = p_oEntity;
		this.addImport(p_oEntity.getMasterInterface().getFullName());
	}

	/**
	 * @return
	 */
	public boolean isSynchronizable() {
		return synchronizable;
	}

	/**
	 * @param p_bSynchronizable
	 */
	public void setSynchronizable(boolean p_bSynchronizable) {
		this.synchronizable = p_bSynchronizable;
	}
	
	
	public List<MDataLoaderCombo> getCombos(){
		return combos;
		
	}
	

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected void toXmlInsertBeforeDocumentation(Element p_xElement) {
		super.toXmlInsertBeforeDocumentation(p_xElement);
		p_xElement.addElement("type").setText(this.getType().name());
		p_xElement.addElement("synchronizable").setText(Boolean.toString(this.synchronizable));
		
		Element xEntity = p_xElement.addElement("entity-type");
		xEntity.addElement("name").setText(this.entity.getMasterInterface().getName());
		xEntity.addElement("full-name").setText(this.entity.getMasterInterface().getFullName());
		String sAttributeName = this.entity.getMasterInterface().getName();
		xEntity.addElement("attribute-name").setText(StringUtils.uncapitalize(sAttributeName));
		xEntity.addElement("transient").setText(Boolean.toString(this.entity.isTransient()));
		xEntity.addElement("scope").setText(this.entity.getScope().name());
		
		Set<String> oDaos = new HashSet<>();
		if (combos!=null && !combos.isEmpty()){
			Element xCombos = p_xElement.addElement("combos");
			for (MDataLoaderCombo oCombo : combos){
				xCombos.add(oCombo.toXml());
				if (oCombo.getEntityDao() != null) {
					oDaos.add(oCombo.getEntityDao().getName());
				}
			}
		}
		
		xEntity = p_xElement.addElement("combo-daos");
		for (String sDao : oDaos) {
			xEntity.addElement("combo-dao").setText(sDao);
		}
		
	}
}
