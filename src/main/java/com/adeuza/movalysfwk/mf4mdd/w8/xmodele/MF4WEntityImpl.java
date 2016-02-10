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
package com.adeuza.movalysfwk.mf4mdd.w8.xmodele;

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;

public class MF4WEntityImpl extends MEntityImpl{
	
	private boolean createFromExpandableProcessor;
	
	private String packageFromExpandableProcessor;
	
	private String classFromExpandableProcessor;

	private String originPackageFromExpandableProcessor;
	
	private String originClassFromExpandableProcessor;
	
	private String originAttributeFromExpandableProcessor;

	public MF4WEntityImpl(String p_sName, MPackage p_oPackage,
			String p_sUmlName, String p_sEntityName) {
		super(p_sName, p_oPackage, p_sUmlName, p_sEntityName);
		
		this.createFromExpandableProcessor = false;
		this.packageFromExpandableProcessor = "";
		this.classFromExpandableProcessor = "";
	}

	public boolean isCreateFromExpandableProcessor() {
		return createFromExpandableProcessor;
	}


	public void setCreateFromExpandableProcessor(
			boolean createFromExpandableProcessor) {
		this.createFromExpandableProcessor = createFromExpandableProcessor;
	}


	public String getPackageFromExpandableProcessor() {
		return packageFromExpandableProcessor;
	}


	public void setPackageFromExpandableProcessor(
			String packageFromExpandableProcessor) {
		this.packageFromExpandableProcessor = packageFromExpandableProcessor;
	}


	public String getClassFromExpandableProcessor() {
		return classFromExpandableProcessor;
	}


	public void setClassFromExpandableProcessor(String classFromExpandableProcessor) {
		this.classFromExpandableProcessor = classFromExpandableProcessor;
	}
	
	public String getOriginPackageFromExpandableProcessor() {
		return originPackageFromExpandableProcessor;
	}

	public void setOriginPackageFromExpandableProcessor(
			String originPackageFromExpandableProcessor) {
		this.originPackageFromExpandableProcessor = originPackageFromExpandableProcessor;
	}

	public String getOriginClassFromExpandableProcessor() {
		return originClassFromExpandableProcessor;
	}

	public void setOriginClassFromExpandableProcessor(
			String originClassFromExpandableProcessor) {
		this.originClassFromExpandableProcessor = originClassFromExpandableProcessor;
	}
	
	public String getOriginAttributeFromExpandableProcessor() {
		return originAttributeFromExpandableProcessor;
	}

	public void setOriginAttributeFromExpandableProcessor(
			String originAttributeFromExpandableProcessor) {
		this.originAttributeFromExpandableProcessor = originAttributeFromExpandableProcessor;
	}
	
	@Override
	public Element toXml() {
		Element p_xElement = super.toXml();
		if (this.isCreateFromExpandableProcessor()) {
			p_xElement.addElement("create-from-expandable-processor").setText(this.createFromExpandableProcessor ? "true" : "false");
			p_xElement.addElement("package-from-expandable-processor").setText(this.packageFromExpandableProcessor);
			p_xElement.addElement("class-from-expandable-processor").setText(this.classFromExpandableProcessor);
			p_xElement.addElement("originPackageFromExpandableProcessor").setText(this.originPackageFromExpandableProcessor);
			p_xElement.addElement("originClassFromExpandableProcessor").setText(this.originClassFromExpandableProcessor);
		}
		return p_xElement;
	}

}
